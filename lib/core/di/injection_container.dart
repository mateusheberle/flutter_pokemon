import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/pokemon/domain/usecases/get_pokemons_usecase.dart';
import '../../features/pokemon/domain/usecases/get_pokemon_detail_usecase.dart';
import '../../features/pokemon/domain/repositories/pokemon_repository.dart';

import '../../features/pokemon/data/datasources/pokemon_remote_datasource.dart';
import '../../features/pokemon/data/datasources/pokemon_remote_datasource_impl.dart';
import '../../features/pokemon/data/datasources/pokemon_local_datasource.dart';
import '../../features/pokemon/data/datasources/pokemon_local_datasource_impl.dart';
import '../../features/pokemon/data/repositories/pokemon_repository_impl.dart';

import '../../features/pokemon/presentation/state/pokemon_controller.dart';
import '../../features/pokemon/presentation/state/pokemon_detail_controller.dart';

final GetIt sl = GetIt.instance;

Future<void> setupInjection() async {
  // External
  sl.registerLazySingleton<Dio>(() {
    return Dio(
        BaseOptions(
          baseUrl: 'https://pokeapi.co/api/v2/',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          // Aumenta o pool de conexões para melhor paralelismo
          maxRedirects: 5,
        ),
      )
      ..interceptors.add(
        LogInterceptor(requestBody: false, responseBody: false),
      );
  });

  // Data
  sl.registerLazySingleton<PokemonLocalDataSource>(
    () => PokemonLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<PokemonRemoteDataSource>(
    () => PokemonRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<PokemonRepository>(
    () => PokemonRepositoryImpl(sl(), sl()),
  );

  // Domain
  sl.registerLazySingleton(() => GetPokemonsUseCase(sl()));
  sl.registerLazySingleton(() => GetPokemonDetailUseCase(sl()));

  // Presentation
  sl.registerFactory(() => PokemonController(sl()));
  sl.registerFactory(() => PokemonDetailController(sl()));
}
