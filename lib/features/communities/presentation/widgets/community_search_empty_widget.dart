import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/theme/colors.dart';

class CommunitySearchEmptyWidget extends StatelessWidget {
  final String searchTem;
  const CommunitySearchEmptyWidget({
    Key? key,
    required this.searchTem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.lightBackgroundColor,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //
          //
          SvgPicture.asset(
            'assets/search-empty.svg',
            width: MediaQuery.of(context).size.width * 0.60,
            // height: 84,
          ),
          const SizedBox(height: 20),
          //
          //
          Text(
            'No results for "${searchTem}"',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 10),
          //
          //
          Text(
            'We couldn\'t find any matches. Try adjusting your search or using different keywords.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 25),
          //
          //
        ],
      ),
    );
  }
}
