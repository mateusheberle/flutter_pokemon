import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_pokemon/features/pokemon/domain/entities/pokemon_entity.dart';
import 'package:flutter_pokemon/features/pokemon/domain/repositories/pokemon_repository.dart';
import 'package:flutter_pokemon/features/pokemon/domain/usecases/get_pokemon_detail_usecase.dart';

class MockPokemonRepository extends Mock implements PokemonRepository {}

void main() {
  late GetPokemonDetailUseCase usecase;
  late MockPokemonRepository repository;

  setUp(() {
    repository = MockPokemonRepository();
    usecase = GetPokemonDetailUseCase(repository);
  });

  group('GetPokemonDetailUseCase', () {
    const pokemonId = 1;
    final pokemon = PokemonEntity(
      id: pokemonId,
      name: 'bulbasaur',
      imageUrl: 'https://example.com/bulbasaur.svg',
      types: ['grass', 'poison'],
      height: 7,
      weight: 69,
    );

    test('deve retornar detalhes de um Pokémon do repositório', () async {
      // Arrange
      when(
        () => repository.getPokemonDetail(pokemonId),
      ).thenAnswer((_) async => pokemon);

      // Act
      final result = await usecase(pokemonId);

      // Assert
      expect(result, equals(pokemon));
      verify(() => repository.getPokemonDetail(pokemonId)).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('deve propagar exceção quando repositório falha', () async {
      // Arrange
      when(
        () => repository.getPokemonDetail(pokemonId),
      ).thenThrow(Exception('Erro ao buscar Pokémon'));

      // Act & Assert
      expect(() => usecase(pokemonId), throwsA(isA<Exception>()));
      verify(() => repository.getPokemonDetail(pokemonId)).called(1);
    });

    test('deve retornar Pokémon com múltiplos tipos', () async {
      // Arrange
      final multiTypePokemon = PokemonEntity(
        id: 6,
        name: 'charizard',
        imageUrl: 'https://example.com/charizard.svg',
        types: ['fire', 'flying'],
        height: 17,
        weight: 905,
      );

      when(
        () => repository.getPokemonDetail(6),
      ).thenAnswer((_) async => multiTypePokemon);

      // Act
      final result = await usecase(6);

      // Assert
      expect(result.types.length, equals(2));
      expect(result.types, contains('fire'));
      expect(result.types, contains('flying'));
    });
  });
}
