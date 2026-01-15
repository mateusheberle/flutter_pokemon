import 'package:flutter/material.dart';

class CustomRefresh extends StatelessWidget {
  const CustomRefresh({super.key, required this.isLoading});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      return const SizedBox.shrink();
    }

    return const Positioned(
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
          strokeWidth: 2,
        ),
      ),
    );
  }
}
