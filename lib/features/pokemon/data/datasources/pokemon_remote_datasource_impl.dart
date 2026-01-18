import 'package:dio/dio.dart';
import '../models/pokemon_model.dart';
import 'pokemon_remote_datasource.dart';

class PokemonRemoteDataSourceImpl implements PokemonRemoteDataSource {
  final Dio dio;

  PokemonRemoteDataSourceImpl(this.dio);

  @override
  Future<List<PokemonModel>> getPokemons({
    required int limit,
    required int offset,
  }) async {
    final response = await dio.get(
      'https://pokeapi.co/api/v2/pokemon',
      queryParameters: {'limit': limit, 'offset': offset},
    );

    final results = response.data['results'] as List;

    return Future.wait(
      results.map((e) async {
        final detail = await dio.get(e['url']);
        return PokemonModel.fromJson(detail.data);
      }),
    );
  }

  @override
  Future<PokemonModel> getPokemonDetail(int id) async {
    final response = await dio.get('https://pokeapi.co/api/v2/pokemon/$id');
    return PokemonModel.fromJson(response.data);
  }
}
