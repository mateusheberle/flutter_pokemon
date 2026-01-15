import '../entities/pokemon_entity.dart';
import '../repositories/pokemon_repository.dart';

class GetPokemonsUseCase {
  final PokemonRepository repository;

  GetPokemonsUseCase(this.repository);

  Future<List<PokemonEntity>> call({required int limit, required int offset}) {
    return repository.getPokemons(limit: limit, offset: offset);
  }
}
