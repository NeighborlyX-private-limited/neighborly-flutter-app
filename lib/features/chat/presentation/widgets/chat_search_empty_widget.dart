import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:neighborly_flutter_app/core/constants/app_images.dart';
import '../../../../core/theme/colors.dart';

class ChatSearchEmptyWidget extends StatelessWidget {
  final String searchTem;
  const ChatSearchEmptyWidget({
    super.key,
    required this.searchTem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.whiteColor,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppImages.emptySearch,
              width: MediaQuery.of(context).size.width * 0.60,
            ),
            const SizedBox(height: 20),
            Text(
              'No results found for "$searchTem"',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'We couldn\'t find any matches. Try adjusting your search or using different keywords.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
