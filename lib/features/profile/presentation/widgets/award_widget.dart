import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/theme/text_style.dart';

class AwardWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String count;
  const AwardWidget(
      {super.key,
      required this.imageUrl,
      required this.title,
      required this.description,
      required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SvgPicture.asset(
          imageUrl,
          width: 84,
          height: 84,
        ),
        const SizedBox(
          width: 5,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: blackNormalTextStyle,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                description,
                style: mediumGreyTextStyleBlack,
                softWrap: true,
              ),
            ],
          ),
        ),
        Text(count, style: onboardingBlackBody2Style),
      ],
    );
  }
}
