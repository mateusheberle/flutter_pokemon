import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/usecase/string_utils.dart';
import '../state/pokemon_detail_controller.dart';
import '../widgets/info_card.dart';

class PokemonDetail extends StatefulWidget {
  final int pokemonId;

  const PokemonDetail({super.key, required this.pokemonId});

  @override
  State<PokemonDetail> createState() => _PokemonDetailState();
}

class _PokemonDetailState extends State<PokemonDetail> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PokemonDetailController>().loadPokemon(widget.pokemonId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Pokédex',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Consumer<PokemonDetailController>(
        builder: (_, controller, __) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.error != null) {
            return Center(
              child: Text(
                controller.error!,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final pokemon = controller.pokemon;
          if (pokemon == null) {
            return const Center(
              child: Text(
                'Pokémon não encontrado',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              children: [
                const SizedBox(height: 24),

                Container(
                  height: 220,
                  width: 220,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white10,
                  ),
                  padding: const EdgeInsets.all(16),
                  child: SvgPicture.network(
                    pokemon.imageUrl,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  '#${pokemon.id.toString().padLeft(3, '0')}',
                  style: const TextStyle(color: Colors.white54, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  StringUtils.capitalize(pokemon.name),
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var type in pokemon.types)
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          StringUtils.capitalize(type),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 32),

                InfoCard(pokemon: pokemon),
              ],
            ),
          );
        },
      ),
    );
  }
}
