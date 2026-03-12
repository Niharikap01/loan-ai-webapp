import 'package:flutter/material.dart';

class FullScreenBackground extends StatelessWidget {
  final String imagePath;
  const FullScreenBackground({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        alignment: Alignment.center,
      ),
    );
  }
}
