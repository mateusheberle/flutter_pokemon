import 'package:flutter/foundation.dart';
import '../../domain/entities/pokemon_entity.dart';
import '../../domain/usecases/get_pokemon_detail_usecase.dart';

class PokemonDetailController extends ChangeNotifier {
  final GetPokemonDetailUseCase getPokemonDetailUseCase;

  PokemonDetailController(this.getPokemonDetailUseCase);

  PokemonEntity? pokemon;
  bool isLoading = false;
  String? error;

  Future<void> loadPokemon(int id) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      pokemon = await getPokemonDetailUseCase(id);
    } catch (e) {
      error = 'Erro ao carregar Pokémon';
    }

    isLoading = false;
    notifyListeners();
  }
}
