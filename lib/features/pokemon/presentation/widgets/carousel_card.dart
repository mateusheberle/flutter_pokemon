import 'package:flutter/material.dart';
import '../../domain/entities/pokemon_entity.dart';
import '../pages/pokemon_detail_page.dart';
import '../state/arguments.dart';
import 'imagem_item.dart';

class CarouselCard extends StatelessWidget {
  const CarouselCard({
    super.key,
    required this.index,
    required this.pokemon,
    required this.color,
    required this.indexSelectedContainer,
    required this.sizeSelectedContainer,
    required this.itemFocusNode,
  });

  final int index;
  final PokemonEntity pokemon;
  final Color color;
  final ValueNotifier<int> indexSelectedContainer;
  final ValueNotifier<double> sizeSelectedContainer;
  final ValueNotifier<FocusNode> itemFocusNode;

  @override
  Widget build(BuildContext context) {
    var tag = '0';
    return ValueListenableBuilder<int>(
      valueListenable: indexSelectedContainer,
      builder: (context, value, _) {
        return InkWell(
          onTap: () {
            if (indexSelectedContainer.value == index) {
              indexSelectedContainer.value = -1;
            } else {
              indexSelectedContainer.value = index;
              sizeSelectedContainer.value = 200;
              itemFocusNode.value.requestFocus();
            }
            itemFocusNode.value.requestFocus();
            Future.delayed(const Duration(milliseconds: 700));

            Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 1000),
                reverseTransitionDuration: const Duration(milliseconds: 500),
                pageBuilder: (context, animation, secondaryAnimation) =>
                    PokemonDetail(pokemonId: pokemon.id),
                settings: RouteSettings(
                  arguments: Arguments(tag: tag, pokemon: pokemon),
                ),
              ),
            );
          },
          focusNode: itemFocusNode.value,
          child: Container(
            width: sizeSelectedContainer.value,
            margin: const EdgeInsets.symmetric(horizontal: 1.0),
            child: ImageItem(pokemon: pokemon, tag: tag, color: color),
          ),
        );
      },
    );
  }
}
