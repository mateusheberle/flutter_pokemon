import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/di/injection_container.dart';
import 'features/pokemon/presentation/state/pokemon_controller.dart';
import 'features/pokemon/presentation/pages/home_page.dart';
import 'features/pokemon/presentation/pages/pokemon_detail_page.dart';
import 'features/pokemon/presentation/state/pokemon_detail_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupInjection();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PokemonController>(
          create: (_) => sl<PokemonController>()..loadPokemons(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Pokémon',
        theme: ThemeData.dark(),
        home: const HomePage(),
        onGenerateRoute: (settings) {
          if (settings.name == '/pokemon-detail') {
            final int pokemonId = settings.arguments as int;
            return MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider(
                create: (_) => sl<PokemonDetailController>(),
                child: PokemonDetail(pokemonId: pokemonId),
              ),
            );
          }
          return null;
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
