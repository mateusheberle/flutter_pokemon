import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_pokemon/features/pokemon/data/datasources/pokemon_local_datasource.dart';
import 'package:flutter_pokemon/features/pokemon/data/datasources/pokemon_remote_datasource.dart';
import 'package:flutter_pokemon/features/pokemon/data/models/pokemon_model.dart';
import 'package:flutter_pokemon/features/pokemon/data/repositories/pokemon_repository_impl.dart';

class MockPokemonRemoteDataSource extends Mock
    implements PokemonRemoteDataSource {}

class MockPokemonLocalDataSource extends Mock
    implements PokemonLocalDataSource {}

class FakePokemonModel extends Fake implements PokemonModel {}

void main() {
  late PokemonRepositoryImpl repository;
  late MockPokemonRemoteDataSource mockRemoteDataSource;
  late MockPokemonLocalDataSource mockLocalDataSource;

  setUpAll(() {
    registerFallbackValue(FakePokemonModel());
  });

  setUp(() {
    mockRemoteDataSource = MockPokemonRemoteDataSource();
    mockLocalDataSource = MockPokemonLocalDataSource();
    repository = PokemonRepositoryImpl(
      mockRemoteDataSource,
      mockLocalDataSource,
    );
  });

  group('getPokemons', () {
    const limit = 10;
    const offset = 0;
    final pokemonsList = [
      PokemonModel(
        id: 1,
        name: 'bulbasaur',
        imageUrl: 'url1',
        types: ['grass', 'poison'],
        height: 7,
        weight: 69,
      ),
      PokemonModel(
        id: 2,
        name: 'ivysaur',
        imageUrl: 'url2',
        types: ['grass', 'poison'],
        height: 10,
        weight: 130,
      ),
    ];

    test('deve retornar dados do cache quando disponível', () async {
      // Arrange
      when(
        () => mockLocalDataSource.getCachedPokemons(offset),
      ).thenReturn(pokemonsList);

      // Act
      final result = await repository.getPokemons(limit: limit, offset: offset);

      // Assert
      expect(result, equals(pokemonsList));
      verify(() => mockLocalDataSource.getCachedPokemons(offset)).called(1);
      verifyNever(
        () => mockRemoteDataSource.getPokemons(
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
        ),
      );
      verifyNoMoreInteractions(mockLocalDataSource);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('deve buscar dados remotos quando cache está vazio', () async {
      // Arrange
      when(
        () => mockLocalDataSource.getCachedPokemons(offset),
      ).thenReturn(null);
      when(
        () => mockRemoteDataSource.getPokemons(limit: limit, offset: offset),
      ).thenAnswer((_) async => pokemonsList);
      when(
        () => mockLocalDataSource.cachePokemons(pokemonsList, offset),
      ).thenReturn(null);

      // Act
      final result = await repository.getPokemons(limit: limit, offset: offset);

      // Assert
      expect(result, equals(pokemonsList));
      verify(() => mockLocalDataSource.getCachedPokemons(offset)).called(1);
      verify(
        () => mockRemoteDataSource.getPokemons(limit: limit, offset: offset),
      ).called(1);
      verify(
        () => mockLocalDataSource.cachePokemons(pokemonsList, offset),
      ).called(1);
    });

    test('deve armazenar em cache após buscar dados remotos', () async {
      // Arrange
      when(
        () => mockLocalDataSource.getCachedPokemons(offset),
      ).thenReturn(null);
      when(
        () => mockRemoteDataSource.getPokemons(limit: limit, offset: offset),
      ).thenAnswer((_) async => pokemonsList);
      when(
        () => mockLocalDataSource.cachePokemons(pokemonsList, offset),
      ).thenReturn(null);

      // Act
      await repository.getPokemons(limit: limit, offset: offset);

      // Assert
      verify(
        () => mockLocalDataSource.cachePokemons(pokemonsList, offset),
      ).called(1);
    });

    test(
      'deve buscar dados remotos quando cache retorna lista vazia',
      () async {
        // Arrange
        when(
          () => mockLocalDataSource.getCachedPokemons(offset),
        ).thenReturn([]);
        when(
          () => mockRemoteDataSource.getPokemons(limit: limit, offset: offset),
        ).thenAnswer((_) async => pokemonsList);
        when(
          () => mockLocalDataSource.cachePokemons(pokemonsList, offset),
        ).thenReturn(null);

        // Act
        final result = await repository.getPokemons(
          limit: limit,
          offset: offset,
        );

        // Assert
        expect(result, equals(pokemonsList));
        verify(
          () => mockRemoteDataSource.getPokemons(limit: limit, offset: offset),
        ).called(1);
      },
    );

    test('deve propagar exceção quando datasource remoto falha', () async {
      // Arrange
      when(
        () => mockLocalDataSource.getCachedPokemons(offset),
      ).thenReturn(null);
      when(
        () => mockRemoteDataSource.getPokemons(limit: limit, offset: offset),
      ).thenThrow(Exception('Network error'));

      // Act & Assert
      expect(
        () => repository.getPokemons(limit: limit, offset: offset),
        throwsA(isA<Exception>()),
      );
    });

    test('deve cachear páginas diferentes independentemente', () async {
      // Arrange
      const offset2 = 10;
      when(
        () => mockLocalDataSource.getCachedPokemons(offset),
      ).thenReturn(null);
      when(
        () => mockLocalDataSource.getCachedPokemons(offset2),
      ).thenReturn(null);
      when(
        () => mockRemoteDataSource.getPokemons(limit: limit, offset: offset),
      ).thenAnswer((_) async => pokemonsList);
      when(
        () => mockRemoteDataSource.getPokemons(limit: limit, offset: offset2),
      ).thenAnswer((_) async => pokemonsList);
      when(
        () => mockLocalDataSource.cachePokemons(any(), any()),
      ).thenReturn(null);

      // Act
      await repository.getPokemons(limit: limit, offset: offset);
      await repository.getPokemons(limit: limit, offset: offset2);

      // Assert
      verify(
        () => mockLocalDataSource.cachePokemons(pokemonsList, offset),
      ).called(1);
      verify(
        () => mockLocalDataSource.cachePokemons(pokemonsList, offset2),
      ).called(1);
    });
  });

  group('getPokemonDetail', () {
    const pokemonId = 1;
    final pokemon = PokemonModel(
      id: pokemonId,
      name: 'bulbasaur',
      imageUrl: 'https://example.com/bulbasaur.svg',
      types: ['grass', 'poison'],
      height: 7,
      weight: 69,
    );

    test('deve retornar detalhes do cache quando disponível', () async {
      // Arrange
      when(
        () => mockLocalDataSource.getCachedPokemonDetail(pokemonId),
      ).thenReturn(pokemon);

      // Act
      final result = await repository.getPokemonDetail(pokemonId);

      // Assert
      expect(result, equals(pokemon));
      verify(
        () => mockLocalDataSource.getCachedPokemonDetail(pokemonId),
      ).called(1);
      verifyNever(() => mockRemoteDataSource.getPokemonDetail(any()));
      verifyNoMoreInteractions(mockLocalDataSource);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('deve buscar detalhes remotos quando cache está vazio', () async {
      // Arrange
      when(
        () => mockLocalDataSource.getCachedPokemonDetail(pokemonId),
      ).thenReturn(null);
      when(
        () => mockRemoteDataSource.getPokemonDetail(pokemonId),
      ).thenAnswer((_) async => pokemon);
      when(
        () => mockLocalDataSource.cachePokemonDetail(pokemon),
      ).thenReturn(null);

      // Act
      final result = await repository.getPokemonDetail(pokemonId);

      // Assert
      expect(result, equals(pokemon));
      verify(
        () => mockLocalDataSource.getCachedPokemonDetail(pokemonId),
      ).called(1);
      verify(() => mockRemoteDataSource.getPokemonDetail(pokemonId)).called(1);
      verify(() => mockLocalDataSource.cachePokemonDetail(pokemon)).called(1);
    });

    test('deve armazenar em cache após buscar detalhes remotos', () async {
      // Arrange
      when(
        () => mockLocalDataSource.getCachedPokemonDetail(pokemonId),
      ).thenReturn(null);
      when(
        () => mockRemoteDataSource.getPokemonDetail(pokemonId),
      ).thenAnswer((_) async => pokemon);
      when(
        () => mockLocalDataSource.cachePokemonDetail(pokemon),
      ).thenReturn(null);

      // Act
      await repository.getPokemonDetail(pokemonId);

      // Assert
      verify(() => mockLocalDataSource.cachePokemonDetail(pokemon)).called(1);
    });

    test('deve propagar exceção quando datasource remoto falha', () async {
      // Arrange
      when(
        () => mockLocalDataSource.getCachedPokemonDetail(pokemonId),
      ).thenReturn(null);
      when(
        () => mockRemoteDataSource.getPokemonDetail(pokemonId),
      ).thenThrow(Exception('Network error'));

      // Act & Assert
      expect(
        () => repository.getPokemonDetail(pokemonId),
        throwsA(isA<Exception>()),
      );
    });

    test('deve cachear Pokémon diferentes independentemente', () async {
      // Arrange
      const pokemonId2 = 2;
      final pokemon2 = PokemonModel(
        id: pokemonId2,
        name: 'ivysaur',
        imageUrl: 'url2',
        types: ['grass', 'poison'],
        height: 10,
        weight: 130,
      );

      when(
        () => mockLocalDataSource.getCachedPokemonDetail(pokemonId),
      ).thenReturn(null);
      when(
        () => mockLocalDataSource.getCachedPokemonDetail(pokemonId2),
      ).thenReturn(null);
      when(
        () => mockRemoteDataSource.getPokemonDetail(pokemonId),
      ).thenAnswer((_) async => pokemon);
      when(
        () => mockRemoteDataSource.getPokemonDetail(pokemonId2),
      ).thenAnswer((_) async => pokemon2);
      when(
        () => mockLocalDataSource.cachePokemonDetail(any()),
      ).thenReturn(null);

      // Act
      await repository.getPokemonDetail(pokemonId);
      await repository.getPokemonDetail(pokemonId2);

      // Assert
      verify(() => mockLocalDataSource.cachePokemonDetail(pokemon)).called(1);
      verify(() => mockLocalDataSource.cachePokemonDetail(pokemon2)).called(1);
    });
  });
}
