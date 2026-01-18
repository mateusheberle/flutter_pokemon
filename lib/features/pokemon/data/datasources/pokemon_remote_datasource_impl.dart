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

    // Processa em lotes menores para não sobrecarregar
    const batchSize = 5;
    final List<PokemonModel> allPokemons = [];

    for (int i = 0; i < results.length; i += batchSize) {
      final batch = results.skip(i).take(batchSize);
      final batchResults = await Future.wait(
        batch.map((e) async {
          try {
            final detail = await dio.get(e['url']);
            return PokemonModel.fromJson(detail.data);
          } catch (e) {
            // Se falhar, retorna null e filtra depois
            return null;
          }
        }),
      );

      // Adiciona apenas os resultados bem-sucedidos
      allPokemons.addAll(batchResults.whereType<PokemonModel>());
    }

    return allPokemons;
  }

  @override
  Future<PokemonModel> getPokemonDetail(int id) async {
    final response = await dio.get('https://pokeapi.co/api/v2/pokemon/$id');
    return PokemonModel.fromJson(response.data);
  }
}
