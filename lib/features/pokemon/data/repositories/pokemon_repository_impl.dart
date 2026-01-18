import '../../domain/entities/pokemon_entity.dart';
import '../../domain/repositories/pokemon_repository.dart';
import '../datasources/pokemon_remote_datasource.dart';
import '../datasources/pokemon_local_datasource.dart';

class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonRemoteDataSource remoteDataSource;
  final PokemonLocalDataSource localDataSource;

  PokemonRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<List<PokemonEntity>> getPokemons({
    required int limit,
    required int offset,
  }) async {
    // Verifica se há cache disponível para esta página
    final cachedPokemons = localDataSource.getCachedPokemons(offset);
    if (cachedPokemons != null && cachedPokemons.isNotEmpty) {
      return cachedPokemons;
    }

    // Se não houver cache, busca da API
    final pokemons = await remoteDataSource.getPokemons(
      limit: limit,
      offset: offset,
    );

    // Armazena no cache
    localDataSource.cachePokemons(pokemons, offset);

    return pokemons;
  }

  @override
  Future<PokemonEntity> getPokemonDetail(int id) async {
    // Verifica se há cache disponível para este Pokémon
    final cachedPokemon = localDataSource.getCachedPokemonDetail(id);
    if (cachedPokemon != null) {
      return cachedPokemon;
    }

    // Se não houver cache, busca da API
    final pokemon = await remoteDataSource.getPokemonDetail(id);

    // Armazena no cache
    localDataSource.cachePokemonDetail(pokemon);

    return pokemon;
  }
}
