import 'package:flutter/material.dart';

import '../../data/models/pokemon_model.dart';
import '../pages/pokemon_detail_page.dart';
import '../state/arguments.dart';
import '../state/pokemon_controller.dart';
import 'imagem_item.dart';

class CarouselCard extends StatelessWidget {
  const CarouselCard({
    super.key,
    required this.index,
    required this.name,
    required this.pokemon,
    required this.color,
    required this.homePageController,
    required this.indexSelectedContainer,
    required this.sizeSelectedContainer,
    required this.itemFocusNode,
  });

  final int index;
  final String name;
  final Pokemon pokemon;
  final Color color;
  final HomePageController homePageController;
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
                    PokemonDetail(pokemon: pokemon),
                settings: RouteSettings(
                  arguments: Arguments(
                    tag: tag,
                    homePageController: homePageController,
                    pokemon: pokemon,
                  ),
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
