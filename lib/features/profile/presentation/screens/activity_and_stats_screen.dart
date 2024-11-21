import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';

import '../../../../core/theme/text_style.dart';
import '../bloc/get_my_awards_bloc/get_my_awards_bloc.dart';
import '../bloc/get_profile_bloc/get_profile_bloc.dart';
import '../widgets/award_widget.dart';

class ActivityAndStatsScreen extends StatefulWidget {
  final String karma;
  const ActivityAndStatsScreen({super.key, required this.karma});

  @override
  State<ActivityAndStatsScreen> createState() => _ActivityAndStatsScreenState();
}

class _ActivityAndStatsScreenState extends State<ActivityAndStatsScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetProfileBloc>(context)
        .add(GetProfileButtonPressedEvent());
    BlocProvider.of<GetMyAwardsBloc>(context)
        .add(GetMyAwardsButtonPressedEvent());
  }

  @override
  Widget build(BuildContext context) {
    dynamic checkStringInList(String str) {
      switch (str) {
        case 'Local Legend':
          return {
            'imageUrl': 'assets/Local_Legend.svg',
            'title': 'Local Legend',
            'description':
                'Recognizing users who consistently contribute high-quality content.'
          };
        case 'Sunflower':
          return {
            'imageUrl': 'assets/Sunflower.svg',
            'title': 'Sunflower',
            'description':
                'For bringing positivity and cheerfulness to the community.'
          };
        case 'Streetlight':
          return {
            'imageUrl': 'assets/Streetlight.svg',
            'title': 'Streetlight',
            'description': 'For providing clear guidance and valuable insights.'
          };
        case 'Park Bench':
          return {
            'imageUrl': 'assets/Park_Bench.svg',
            'title': 'Park Bench',
            'description': 'For offering comforting and supportive posts.'
          };
        case 'Map':
          return {
            'imageUrl': 'assets/Map.svg',
            'title': 'Map',
            'description': 'For creating informative and detailed content.'
          };
        default:
          return 'assets/react7.png';
      }
    }

    return SafeArea(
        child: Scaffold(
            backgroundColor: AppColors.lightBackgroundColor,
            appBar: AppBar(
              backgroundColor: AppColors.whiteColor,
              leading: InkWell(
                child: const Icon(Icons.arrow_back_ios, size: 20),
                onTap: () => context.pop(),
              ),
              title: Text(
                'Activity and Stats',
                style: blackNormalTextStyle,
              ),
            ),
            body: Column(
              children: [
                Container(
                    height: 154,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: const BoxDecoration(
                      color: AppColors.whiteColor,
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Karma Score',
                            style: blackNormalTextStyle,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SvgPicture.asset(
                                'assets/karma.svg',
                                width: 84,
                                height: 84,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Karma',
                                      style: blackNormalTextStyle,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Your Karma score reflects your engagement within the community. Share, help, and connect to build your score.',
                                      style: mediumGreyTextStyleBlack,
                                      softWrap: true,
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                widget.karma.toString(),
                                style: onboardingBlackBody2Style,
                              )
                            ],
                          ),
                        ])),
                const SizedBox(
                  height: 10,
                ),
                BlocBuilder<GetMyAwardsBloc, GetMyAwardsState>(
                  builder: (context, state) {
                    if (state is GetMyAwardsSuccessState) {
                      return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: const BoxDecoration(
                            color: AppColors.whiteColor,
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Awards',
                                  style: blackNormalTextStyle,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                if (state.awards.isNotEmpty)
                                  SizedBox(
                                    height: 500,
                                    child: ListView.separated(
                                      itemCount: state.awards.length,
                                      itemBuilder: (context, index) {
                                        final award = state.awards[index];
                                        String title = checkStringInList(
                                            award['type'])['title'];
                                        String description = checkStringInList(
                                            award['type'])['description'];
                                        String imageUrl = checkStringInList(
                                            award['type'])['imageUrl'];

                                        return AwardWidget(
                                          imageUrl: imageUrl,
                                          title: title,
                                          description: description,
                                          count: award['count'].toString(),
                                        );
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return const Padding(
                                          padding:
                                              EdgeInsets.only(bottom: 10.0),
                                        );
                                      },
                                    ),
                                  )
                                else
                                  Column(children: [
                                    AwardWidget(
                                      imageUrl: 'assets/Local_Legend.svg',
                                      title: 'Local Legend',
                                      description:
                                          'Recognizing users who consistently contribute high-quality content.',
                                      count: '0',
                                    ),
                                    AwardWidget(
                                      imageUrl: 'assets/Sunflower.svg',
                                      title: 'Sunflower',
                                      description:
                                          'For bringing positivity and cheerfulness to the community.',
                                      count: '0',
                                    ),
                                    AwardWidget(
                                      imageUrl: 'assets/Streetlight.svg',
                                      title: 'Streetlight',
                                      description:
                                          'For providing clear guidance and valuable insights.',
                                      count: '0',
                                    ),
                                    AwardWidget(
                                      imageUrl: 'assets/Park_Bench.svg',
                                      title: 'Park Bench',
                                      description:
                                          'For offering comforting and supportive posts.',
                                      count: '0',
                                    ),
                                    AwardWidget(
                                      imageUrl: 'assets/Map.svg',
                                      title: 'Map',
                                      description:
                                          'For creating informative and detailed content.',
                                      count: '0',
                                    ),
                                  ])
                              ]));
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ],
            )));
  }
}
