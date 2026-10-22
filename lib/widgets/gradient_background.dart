import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  GradientBackground({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0D6EFD), Color(0xFFFFF8E1), Color(0xFF7AC74F)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: child,
    );
  }
}
