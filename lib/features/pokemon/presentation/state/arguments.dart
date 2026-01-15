import '../../domain/entities/pokemon_entity.dart';

/// Arguments class for passing data between routes
///
/// This class encapsulates navigation arguments used when
/// transitioning to Pokemon detail pages.
class Arguments {
  const Arguments({required this.tag, required this.pokemon});

  /// Unique tag for hero animations
  final String tag;

  /// Pokemon data to display
  final PokemonEntity pokemon;

  Arguments copyWith({String? tag, PokemonEntity? pokemon}) {
    return Arguments(tag: tag ?? this.tag, pokemon: pokemon ?? this.pokemon);
  }
}
