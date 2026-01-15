import '../models/pokemon_model.dart';

abstract class PokemonRemoteDataSource {
  Future<List<PokemonModel>> getPokemons({
    required int limit,
    required int offset,
  });

  Future<PokemonModel> getPokemonDetail(int id);
}
