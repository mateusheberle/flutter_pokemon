import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../state/pokemon_controller.dart';
import '../../domain/entities/pokemon_entity.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Pokédex',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Consumer<PokemonController>(
        builder: (context, controller, _) {
          // 🔄 Loading inicial
          if (controller.isLoading && controller.pokemons.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // ❌ Erro
          if (controller.error != null && controller.pokemons.isEmpty) {
            return Center(
              child: Text(
                controller.error!,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return NotificationListener<ScrollNotification>(
            onNotification: (scroll) {
              if (scroll.metrics.pixels >=
                  scroll.metrics.maxScrollExtent - 200) {
                controller.loadPokemons();
              }
              return false;
            },
            child: ListView.builder(
              itemCount:
                  controller.pokemons.length + (controller.isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= controller.pokemons.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                }

                final pokemon = controller.pokemons[index];
                return _PokemonCard(pokemon: pokemon);
              },
            ),
          );
        },
      ),
    );
  }
}

class _PokemonCard extends StatelessWidget {
  final PokemonEntity pokemon;

  const _PokemonCard({required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
        elevation: 4,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/pokemon-detail',
              arguments: pokemon.id,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                _PokemonAvatar(pokemon: pokemon),
                const SizedBox(width: 16),
                _PokemonInfo(pokemon: pokemon),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PokemonAvatar extends StatelessWidget {
  final PokemonEntity pokemon;

  const _PokemonAvatar({required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      width: 64,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white10,
      ),
      padding: const EdgeInsets.all(6),
      child: SvgPicture.network(
        pokemon.imageUrl,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
      ),
    );
  }
}

class _PokemonInfo extends StatelessWidget {
  final PokemonEntity pokemon;

  const _PokemonInfo({required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '#${pokemon.id.toString().padLeft(3, '0')}',
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          pokemon.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
