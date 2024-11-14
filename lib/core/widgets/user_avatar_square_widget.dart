import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants/core_dimens.dart';

class UserAvatarSquareWidget extends StatelessWidget {
  final String? imageUrl;
  final String? imageAssetPath;
  final double? size;
  final double? borderSize;
  final double? borderRadius;

  const UserAvatarSquareWidget({
    super.key,
    this.imageUrl,
    this.imageAssetPath,
    this.size = 100,
    this.borderSize = kBorderWidthBig,
    this.borderRadius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(borderRadius!),
        image: imageUrl != null
            ? DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(imageUrl!),
              )
            : imageAssetPath != null
                ? DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(imageAssetPath!),
                  )
                : null,
      ),
    );
  }
}
