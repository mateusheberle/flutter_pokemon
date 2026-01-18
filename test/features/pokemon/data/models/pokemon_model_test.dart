import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_pokemon/features/pokemon/data/models/pokemon_model.dart';

void main() {
  group('PokemonModel', () {
    group('fromJson', () {
      test('deve converter JSON válido em PokemonModel', () {
        // Arrange
        final json = {
          'id': 1,
          'name': 'bulbasaur',
          'sprites': {
            'other': {
              'dream_world': {
                'front_default': 'https://example.com/bulbasaur.svg',
              },
            },
          },
          'types': [
            {
              'type': {'name': 'grass'},
            },
            {
              'type': {'name': 'poison'},
            },
          ],
          'height': 7,
          'weight': 69,
        };

        // Act
        final pokemon = PokemonModel.fromJson(json);

        // Assert
        expect(pokemon.id, equals(1));
        expect(pokemon.name, equals('bulbasaur'));
        expect(pokemon.imageUrl, equals('https://example.com/bulbasaur.svg'));
        expect(pokemon.types, equals(['grass', 'poison']));
        expect(pokemon.height, equals(7));
        expect(pokemon.weight, equals(69));
      });

      test('deve usar string vazia quando imageUrl é null', () {
        // Arrange
        final json = {
          'id': 1,
          'name': 'test',
          'sprites': {
            'other': {
              'dream_world': {'front_default': null},
            },
          },
          'types': [
            {
              'type': {'name': 'normal'},
            },
          ],
          'height': 10,
          'weight': 100,
        };

        // Act
        final pokemon = PokemonModel.fromJson(json);

        // Assert
        expect(pokemon.imageUrl, equals(''));
      });

      test('deve converter Pokémon com um único tipo', () {
        // Arrange
        final json = {
          'id': 25,
          'name': 'pikachu',
          'sprites': {
            'other': {
              'dream_world': {'front_default': 'url'},
            },
          },
          'types': [
            {
              'type': {'name': 'electric'},
            },
          ],
          'height': 4,
          'weight': 60,
        };

        // Act
        final pokemon = PokemonModel.fromJson(json);

        // Assert
        expect(pokemon.types.length, equals(1));
        expect(pokemon.types, contains('electric'));
      });

      test('deve converter Pokémon com múltiplos tipos', () {
        // Arrange
        final json = {
          'id': 6,
          'name': 'charizard',
          'sprites': {
            'other': {
              'dream_world': {'front_default': 'url'},
            },
          },
          'types': [
            {
              'type': {'name': 'fire'},
            },
            {
              'type': {'name': 'flying'},
            },
          ],
          'height': 17,
          'weight': 905,
        };

        // Act
        final pokemon = PokemonModel.fromJson(json);

        // Assert
        expect(pokemon.types.length, equals(2));
        expect(pokemon.types, containsAll(['fire', 'flying']));
      });

      test('deve preservar ordem dos tipos', () {
        // Arrange
        final json = {
          'id': 1,
          'name': 'test',
          'sprites': {
            'other': {
              'dream_world': {'front_default': 'url'},
            },
          },
          'types': [
            {
              'type': {'name': 'water'},
            },
            {
              'type': {'name': 'ground'},
            },
          ],
          'height': 10,
          'weight': 100,
        };

        // Act
        final pokemon = PokemonModel.fromJson(json);

        // Assert
        expect(pokemon.types[0], equals('water'));
        expect(pokemon.types[1], equals('ground'));
      });

      test('deve criar PokemonModel que herda de PokemonEntity', () {
        // Arrange
        final json = {
          'id': 1,
          'name': 'test',
          'sprites': {
            'other': {
              'dream_world': {'front_default': 'url'},
            },
          },
          'types': [
            {
              'type': {'name': 'normal'},
            },
          ],
          'height': 10,
          'weight': 100,
        };

        // Act
        final pokemon = PokemonModel.fromJson(json);

        // Assert
        expect(pokemon.id, isA<int>());
        expect(pokemon.name, isA<String>());
        expect(pokemon.imageUrl, isA<String>());
        expect(pokemon.types, isA<List<String>>());
        expect(pokemon.height, isA<int>());
        expect(pokemon.weight, isA<int>());
      });

      test('deve converter valores numéricos grandes corretamente', () {
        // Arrange
        final json = {
          'id': 143,
          'name': 'snorlax',
          'sprites': {
            'other': {
              'dream_world': {'front_default': 'url'},
            },
          },
          'types': [
            {
              'type': {'name': 'normal'},
            },
          ],
          'height': 21,
          'weight': 4600,
        };

        // Act
        final pokemon = PokemonModel.fromJson(json);

        // Assert
        expect(pokemon.height, equals(21));
        expect(pokemon.weight, equals(4600));
      });
    });

    group('equality', () {
      test('dois PokemonModel com mesmos valores devem ser iguais', () {
        // Arrange
        const pokemon1 = PokemonModel(
          id: 1,
          name: 'bulbasaur',
          imageUrl: 'url',
          types: ['grass', 'poison'],
          height: 7,
          weight: 69,
        );

        const pokemon2 = PokemonModel(
          id: 1,
          name: 'bulbasaur',
          imageUrl: 'url',
          types: ['grass', 'poison'],
          height: 7,
          weight: 69,
        );

        // Assert
        expect(pokemon1, equals(pokemon2));
      });

      test('dois PokemonModel com valores diferentes não devem ser iguais', () {
        // Arrange
        const pokemon1 = PokemonModel(
          id: 1,
          name: 'bulbasaur',
          imageUrl: 'url',
          types: ['grass', 'poison'],
          height: 7,
          weight: 69,
        );

        const pokemon2 = PokemonModel(
          id: 2,
          name: 'ivysaur',
          imageUrl: 'url2',
          types: ['grass', 'poison'],
          height: 10,
          weight: 130,
        );

        // Assert
        expect(pokemon1, isNot(equals(pokemon2)));
      });
    });
  });
}
