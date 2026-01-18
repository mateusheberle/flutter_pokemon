import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_pokemon/features/pokemon/data/datasources/pokemon_local_datasource_impl.dart';
import 'package:flutter_pokemon/features/pokemon/data/models/pokemon_model.dart';

void main() {
  late PokemonLocalDataSourceImpl dataSource;

  setUp(() {
    dataSource = PokemonLocalDataSourceImpl();
  });

  group('PokemonLocalDataSourceImpl', () {
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

    group('cachePokemons e getCachedPokemons', () {
      test('deve retornar null quando cache está vazio', () {
        // Act
        final result = dataSource.getCachedPokemons(0);

        // Assert
        expect(result, isNull);
      });

      test('deve armazenar e recuperar lista de Pokémon', () {
        // Arrange
        const offset = 0;

        // Act
        dataSource.cachePokemons(pokemonsList, offset);
        final result = dataSource.getCachedPokemons(offset);

        // Assert
        expect(result, equals(pokemonsList));
        expect(result?.length, equals(2));
      });

      test('deve cachear páginas diferentes independentemente', () {
        // Arrange
        const offset1 = 0;
        const offset2 = 10;
        final page1 = [pokemonsList.first];
        final page2 = [pokemonsList.last];

        // Act
        dataSource.cachePokemons(page1, offset1);
        dataSource.cachePokemons(page2, offset2);

        // Assert
        final result1 = dataSource.getCachedPokemons(offset1);
        final result2 = dataSource.getCachedPokemons(offset2);

        expect(result1, equals(page1));
        expect(result2, equals(page2));
        expect(result1, isNot(equals(result2)));
      });

      test('deve retornar null para offset não cacheado', () {
        // Arrange
        dataSource.cachePokemons(pokemonsList, 0);

        // Act
        final result = dataSource.getCachedPokemons(10);

        // Assert
        expect(result, isNull);
      });

      test('deve sobrescrever cache de mesma página', () {
        // Arrange
        const offset = 0;
        final newList = [
          PokemonModel(
            id: 3,
            name: 'venusaur',
            imageUrl: 'url3',
            types: ['grass', 'poison'],
            height: 20,
            weight: 1000,
          ),
        ];

        // Act
        dataSource.cachePokemons(pokemonsList, offset);
        dataSource.cachePokemons(newList, offset);
        final result = dataSource.getCachedPokemons(offset);

        // Assert
        expect(result, equals(newList));
        expect(result?.length, equals(1));
      });
    });

    group('cachePokemonDetail e getCachedPokemonDetail', () {
      final pokemon = pokemonsList.first;

      test('deve retornar null quando cache de detalhes está vazio', () {
        // Act
        final result = dataSource.getCachedPokemonDetail(1);

        // Assert
        expect(result, isNull);
      });

      test('deve armazenar e recuperar detalhes de Pokémon', () {
        // Act
        dataSource.cachePokemonDetail(pokemon);
        final result = dataSource.getCachedPokemonDetail(pokemon.id);

        // Assert
        expect(result, equals(pokemon));
        expect(result?.id, equals(1));
        expect(result?.name, equals('bulbasaur'));
      });

      test('deve cachear detalhes de Pokémon diferentes', () {
        // Arrange
        final pokemon1 = pokemonsList[0];
        final pokemon2 = pokemonsList[1];

        // Act
        dataSource.cachePokemonDetail(pokemon1);
        dataSource.cachePokemonDetail(pokemon2);

        // Assert
        final result1 = dataSource.getCachedPokemonDetail(pokemon1.id);
        final result2 = dataSource.getCachedPokemonDetail(pokemon2.id);

        expect(result1, equals(pokemon1));
        expect(result2, equals(pokemon2));
      });

      test('deve cachear automaticamente ao usar cachePokemons', () {
        // Act
        dataSource.cachePokemons(pokemonsList, 0);

        // Assert
        final pokemon1 = dataSource.getCachedPokemonDetail(1);
        final pokemon2 = dataSource.getCachedPokemonDetail(2);

        expect(pokemon1, equals(pokemonsList[0]));
        expect(pokemon2, equals(pokemonsList[1]));
      });

      test('deve sobrescrever detalhes de mesmo Pokémon', () {
        // Arrange
        final originalPokemon = pokemon;
        final updatedPokemon = PokemonModel(
          id: originalPokemon.id,
          name: 'updated-bulbasaur',
          imageUrl: 'updated-url',
          types: ['grass'],
          height: 8,
          weight: 70,
        );

        // Act
        dataSource.cachePokemonDetail(originalPokemon);
        dataSource.cachePokemonDetail(updatedPokemon);
        final result = dataSource.getCachedPokemonDetail(originalPokemon.id);

        // Assert
        expect(result, equals(updatedPokemon));
        expect(result?.name, equals('updated-bulbasaur'));
      });
    });

    group('clearCache', () {
      test('deve limpar cache de páginas', () {
        // Arrange
        dataSource.cachePokemons(pokemonsList, 0);

        // Act
        dataSource.clearCache();
        final result = dataSource.getCachedPokemons(0);

        // Assert
        expect(result, isNull);
      });

      test('deve limpar cache de detalhes', () {
        // Arrange
        dataSource.cachePokemonDetail(pokemonsList.first);

        // Act
        dataSource.clearCache();
        final result = dataSource.getCachedPokemonDetail(1);

        // Assert
        expect(result, isNull);
      });

      test('deve limpar todo o cache', () {
        // Arrange
        dataSource.cachePokemons(pokemonsList, 0);
        dataSource.cachePokemons(pokemonsList, 10);
        dataSource.cachePokemonDetail(pokemonsList.first);

        // Act
        dataSource.clearCache();

        // Assert
        expect(dataSource.getCachedPokemons(0), isNull);
        expect(dataSource.getCachedPokemons(10), isNull);
        expect(dataSource.getCachedPokemonDetail(1), isNull);
      });

      test('deve permitir novo cache após limpar', () {
        // Arrange
        dataSource.cachePokemons(pokemonsList, 0);
        dataSource.clearCache();

        // Act
        dataSource.cachePokemons(pokemonsList, 0);
        final result = dataSource.getCachedPokemons(0);

        // Assert
        expect(result, equals(pokemonsList));
      });
    });
  });
}
