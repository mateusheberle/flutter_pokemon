import '../../domain/entities/pokemon_entity.dart';

/// UI State representing a collection of Pokemon
class CatalogState {
  const CatalogState({
    this.pokemons = const [],
    this.isLoading = false,
    this.error,
  });

  final List<PokemonEntity> pokemons;
  final bool isLoading;
  final String? error;

  CatalogState copyWith({
    List<PokemonEntity>? pokemons,
    bool? isLoading,
    String? error,
  }) {
    return CatalogState(
      pokemons: pokemons ?? this.pokemons,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
