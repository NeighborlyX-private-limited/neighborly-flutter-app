import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/theme/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CommunitySearchEmptyWidget extends StatelessWidget {
  final String searchTem;
  const CommunitySearchEmptyWidget({
    super.key,
    required this.searchTem,
  });

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
          SvgPicture.asset(
            'assets/search-empty.svg',
            width: MediaQuery.of(context).size.width * 0.60,
          ),
          const SizedBox(height: 20),
          Text(
            '${AppLocalizations.of(context)!.no_results_for} "$searchTem"',
            //'No results for "$searchTem"',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            AppLocalizations.of(context)!.we_couldnt_find_any_matches_Try_adjusting_your_search_or_using_different_keywords,
           // 'We couldn\'t find any matches. Try adjusting your search or using different keywords.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
