import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/core_dimens.dart';

class UserAvatarStyledWidget extends StatelessWidget {
  final String avatarUrl;
  final double? avatarSize;
  final double? avatarBorderSize;
  final bool? isDarkmode;

  const UserAvatarStyledWidget({
    Key? key,
    required this.avatarUrl,
    this.avatarSize = 30,
    this.avatarBorderSize = kBorderWidthBig,
    this.isDarkmode = false,
  }) : super(key: key);

  // Widget avatarArea(BuildContext context, String avatarUrl, double? size) {
  //   final proportionalSize = CoreDimens.proportionalWidth(context, size ?? 30);
  //   return CircleAvatar(
  //     radius: proportionalSize,
  //     backgroundColor: Colors.grey[400],
  //     child: CircleAvatar(
  //       radius: proportionalSize - borderSize!,
  //       onBackgroundImageError: (_, __) => SvgPicture.asset('assets/vectors/my_profile_placeholder.svg'),
  //       backgroundImage: CachedNetworkImageProvider(avatarUrl),
  //     ),
  //   );
  // }

  Widget avatarArea(BuildContext context, String avatarUrl) {
    final proportionalSize =
        CoreDimens.proportionalWidth(context, avatarSize ?? 30);
    return CircleAvatar(
      radius: proportionalSize + avatarBorderSize!,
      backgroundColor: Colors.green,
      child: CircleAvatar(
        radius: proportionalSize,
        backgroundColor: isDarkmode! ? Colors.black : Colors.white,
        child: avatarUrl != null && avatarUrl.contains('.')? CircleAvatar(
          radius: proportionalSize - avatarBorderSize!,

          onBackgroundImageError: (_, __) =>
              SvgPicture.asset('assets/vectors/my_profile_placeholder.svg'),
          backgroundImage: CachedNetworkImageProvider(avatarUrl),
        ): CircleAvatar(
      radius: proportionalSize - avatarBorderSize!,
      backgroundColor: hexStringToColor(avatarUrl), // Set the color you want to display
    ),
      ),
    );
  }

  Color hexStringToColor(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 7) buffer.write('FF'); // add alpha if missing
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

  @override
  Widget build(BuildContext context) {
    return avatarArea(context, avatarUrl);
  }
}
