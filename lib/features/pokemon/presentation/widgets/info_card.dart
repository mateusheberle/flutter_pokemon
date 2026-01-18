import 'package:flutter/material.dart';

import '../../../../core/usecase/app_strings.dart';
import '../../../../core/usecase/string_utils.dart';

class InfoCard extends StatelessWidget {
  final pokemon;

  const InfoCard({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _line(AppStrings.id, '#${pokemon.id}'),
          _line(AppStrings.species, StringUtils.capitalize(pokemon.name)),
          _line(
            AppStrings.type,
            pokemon.types.map(StringUtils.capitalize).join(', '),
          ),
          _line(AppStrings.height, pokemon.height.toString()),
          _line(AppStrings.weight, pokemon.weight.toString()),
        ],
      ),
    );
  }

  Widget _line(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
