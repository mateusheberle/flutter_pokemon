import '../models/pokemon_model.dart';
import 'pokemon_local_datasource.dart';

class PokemonLocalDataSourceImpl implements PokemonLocalDataSource {
  // Cache em memória para páginas de Pokémon (mapa por offset)
  final Map<int, List<PokemonModel>> _cachedPages = {};

  // Cache em memória para detalhes individuais dos Pokémon (mapa por ID)
  final Map<int, PokemonModel> _cachedDetails = {};

  @override
  List<PokemonModel>? getCachedPokemons(int offset) {
    return _cachedPages[offset];
  }

  @override
  PokemonModel? getCachedPokemonDetail(int id) {
    return _cachedDetails[id];
  }

  @override
  void cachePokemons(List<PokemonModel> pokemons, int offset) {
    _cachedPages[offset] = pokemons;

    // Também armazena cada Pokémon no cache de detalhes
    for (var pokemon in pokemons) {
      _cachedDetails[pokemon.id] = pokemon;
    }
  }

  @override
  void cachePokemonDetail(PokemonModel pokemon) {
    _cachedDetails[pokemon.id] = pokemon;
  }

  @override
  void clearCache() {
    _cachedPages.clear();
    _cachedDetails.clear();
  }
}
