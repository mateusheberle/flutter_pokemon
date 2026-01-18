import '../models/pokemon_model.dart';

abstract class PokemonLocalDataSource {
  /// Obtém a lista de Pokémon do cache para um offset específico
  List<PokemonModel>? getCachedPokemons(int offset);

  /// Obtém um Pokémon específico do cache
  PokemonModel? getCachedPokemonDetail(int id);

  /// Armazena a lista de Pokémon no cache com offset
  void cachePokemons(List<PokemonModel> pokemons, int offset);

  /// Armazena um Pokémon específico no cache
  void cachePokemonDetail(PokemonModel pokemon);

  /// Limpa o cache
  void clearCache();
}
