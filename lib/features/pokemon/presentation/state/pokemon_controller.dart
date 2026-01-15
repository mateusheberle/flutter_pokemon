import 'package:flutter/foundation.dart';
import '../../domain/entities/pokemon_entity.dart';
import '../../domain/usecases/get_pokemons_usecase.dart';

class PokemonController extends ChangeNotifier {
  final GetPokemonsUseCase getPokemonsUseCase;

  PokemonController(this.getPokemonsUseCase);

  final List<PokemonEntity> pokemons = [];

  bool isLoading = false;
  String? error;

  int _offset = 0;
  final int _limit = 20;
  bool _hasMore = true;

  Future<void> loadPokemons() async {
    if (isLoading || !_hasMore) return;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final result = await getPokemonsUseCase(limit: _limit, offset: _offset);

      if (result.isEmpty) {
        _hasMore = false;
      } else {
        pokemons.addAll(result);
        _offset += _limit;
      }
    } catch (e) {
      error = 'Erro ao carregar Pokémon';
    }

    isLoading = false;
    notifyListeners();
  }

  void refresh() {
    _offset = 0;
    _hasMore = true;
    pokemons.clear();
    loadPokemons();
  }
}
