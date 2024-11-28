/*
///...... bouncing app logo indicator
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BouncingLogoIndicator extends StatefulWidget {
  final String logo;
  const BouncingLogoIndicator({required this.logo, super.key});

  @override
  BouncingLogoIndicatorState createState() => BouncingLogoIndicatorState();
}

class BouncingLogoIndicatorState extends State<BouncingLogoIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _bounceAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);

    _bounceAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: const Offset(0, 0.3),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
          ),
          SlideTransition(
            position: _bounceAnimation,
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: SvgPicture.asset(widget.logo),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';

dynamic BouncingLogoIndicator({required String logo}) {
  return CircularProgressIndicator(
    color: AppColors.primaryColor,
  );
}
