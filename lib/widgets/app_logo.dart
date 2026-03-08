import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final Color? color;

  const AppLogo({super.key, this.size = 40, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        'assets/images/logo_final.png',
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Fallback if image is missing
          return Icon(
            Icons.health_and_safety,
            size: size,
            color: color ?? const Color(0xFF00942A),
          );
        },
      ),
    );
  }
}
