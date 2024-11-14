import 'dart:math';

import 'package:flutter/material.dart';

class StackedAvatarIndicator extends StatelessWidget {
  final List<String> avatarUrls;
  final int? showOnly;
  final double? avatarSize;
  final double? radius;
  final VoidCallback? onTap;

  const StackedAvatarIndicator({
    super.key,
    required this.avatarUrls,
    this.showOnly = 3,
    this.avatarSize = 32,
    this.onTap,
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context) {
    if (avatarUrls.isEmpty) return SizedBox.shrink();

    final widthMultiplier =
        avatarUrls.length < showOnly! ? avatarUrls.length : showOnly;

    return InkWell(
      onTap: () {
        if (onTap != null) onTap!();
      },
      child: Container(
        width: (21 * widthMultiplier!) + 4,
        height: avatarSize! + 6,
        color: Colors.transparent,
        child: Stack(
          children: [
            for (int i = 0; i < min(avatarUrls.length, showOnly!); i++)
              Positioned(
                left: i.toDouble() * avatarSize!,
                child: CircleAvatar(
                  radius: radius! + 1,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: radius,
                    backgroundImage: NetworkImage(avatarUrls[i]),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
