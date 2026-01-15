import '../entities/pokemon_entity.dart';

abstract class PokemonRepository {
  Future<List<PokemonEntity>> getPokemons({
    required int limit,
    required int offset,
  });

  Future<PokemonEntity> getPokemonDetail(int id);
}
