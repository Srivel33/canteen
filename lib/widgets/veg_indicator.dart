import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class VegIndicator extends StatelessWidget {
  final bool isVeg;
  final double size;

  const VegIndicator({
    super.key,
    required this.isVeg,
    this.size = 14,
  });

  @override
  Widget build(BuildContext context) {
    final color = isVeg ? AppTheme.vegColor : AppTheme.nonVegColor;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 1.5),
        borderRadius: BorderRadius.circular(3),
      ),
      padding: EdgeInsets.all(size * 0.15),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
