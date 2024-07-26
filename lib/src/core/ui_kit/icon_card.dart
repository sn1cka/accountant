import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    this.icon,
    this.color,
    this.onTap,
  });

  final Widget? icon;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => TextButton(
        style: TextButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: color,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(4),
        ),
        onPressed: onTap,
        child: icon ?? const SizedBox(),
      );
}
