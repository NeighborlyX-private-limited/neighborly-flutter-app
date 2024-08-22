import 'package:flutter/material.dart';

class AppbatButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final Color? iconColor;
  final double? iconSize;
  final double? opacity;
  final double? size;
  const AppbatButton({
    Key? key,
    required this.onTap,
    required this.icon,
    this.iconColor = Colors.white,
    this.iconSize = 20,
    this.opacity = 0.5,
    this.size = 40,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size!,
      width: size!,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(opacity!), // Cor de fundo
        shape: BoxShape.circle,
      ),
      child: GestureDetector(
        child: Center(
          child: Icon(
            icon,
            color: iconColor!,
            size: iconSize!,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
