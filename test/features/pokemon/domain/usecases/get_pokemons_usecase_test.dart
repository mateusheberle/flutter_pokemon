import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_pokemon/features/pokemon/domain/entities/pokemon_entity.dart';
import 'package:flutter_pokemon/features/pokemon/domain/repositories/pokemon_repository.dart';
import 'package:flutter_pokemon/features/pokemon/domain/usecases/get_pokemons_usecase.dart';

class MockPokemonRepository extends Mock implements PokemonRepository {}

void main() {
  late GetPokemonsUseCase usecase;
  late MockPokemonRepository repository;

  setUp(() {
    repository = MockPokemonRepository();
    usecase = GetPokemonsUseCase(repository);
  });

  test('deve retornar uma lista de Pokémon do repositório', () async {
    final pokemons = [
      PokemonEntity(
        id: 1,
        name: 'bulbasaur',
        imageUrl: 'url',
        types: ['grass', 'poison'],
        height: 7,
        weight: 69,
      ),
    ];

    when(
      () => repository.getPokemons(limit: 20, offset: 0),
    ).thenAnswer((_) async => pokemons);

    final result = await usecase(limit: 20, offset: 0);

    expect(result, equals(pokemons));
    verify(() => repository.getPokemons(limit: 20, offset: 0)).called(1);
    verifyNoMoreInteractions(repository);
  });
}
