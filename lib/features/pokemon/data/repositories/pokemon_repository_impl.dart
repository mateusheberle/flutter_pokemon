import '../../domain/entities/pokemon_entity.dart';
import '../../domain/repositories/pokemon_repository.dart';
import '../datasources/pokemon_remote_datasource.dart';

class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonRemoteDataSource remoteDataSource;

  PokemonRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<PokemonEntity>> getPokemons({
    required int limit,
    required int offset,
  }) {
    return remoteDataSource.getPokemons(limit: limit, offset: offset);
  }

  @override
  Future<PokemonEntity> getPokemonDetail(int id) {
    return remoteDataSource.getPokemonDetail(id);
  }
}
