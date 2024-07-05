import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/theme/text_style.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/bloc/get_profile_bloc/get_profile_bloc.dart';

class ActivityAndStatsScreen extends StatefulWidget {
  const ActivityAndStatsScreen({super.key});

  @override
  State<ActivityAndStatsScreen> createState() => _ActivityAndStatsScreenState();
}

class _ActivityAndStatsScreenState extends State<ActivityAndStatsScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetProfileBloc>(context)
        .add(GetProfileButtonPressedEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: const Color(0xFFF5F5FF),
            appBar: AppBar(
              backgroundColor: Colors.white,
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
                      color: Colors.white,
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
                          InkWell(
                            onTap: () {
                              // BlocProvider.of<GiveAwardBloc>(context).add(
                              //   GiveAwardButtonPressedEvent(
                              //     id: widget.post.id,
                              //     awardType: 'Local Legend',
                              //     type: 'post',
                              //   ),
                              // );

                              // Navigator.pop(context, awardsCount + 1);
                            },
                            child: Row(
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
                                  // Ensures the text wraps within the available space
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Karma',
                                        style: blackNormalTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'Lorem ipsum dolor sit met, constur adipiscing elit,',
                                        style: mediumGreyTextStyleBlack,
                                        softWrap: true, // Enables text wrapping
                                      ),
                                    ],
                                  ),
                                ),
                                BlocBuilder<GetProfileBloc, GetProfileState>(
                                  builder: (context, state) {
                                    if (state is GetProfileLoadingState) {
                                      return const CircularProgressIndicator();
                                    } else if (state
                                        is GetProfileSuccessState) {
                                      return Text(
                                          state.profile.karma.toString(),
                                          style: onboardingBlackBody2Style);
                                    }
                                    return const SizedBox();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ])),
                const SizedBox(
                  height: 10,
                ),
                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: const BoxDecoration(
                      color: Colors.white,
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
                          InkWell(
                            onTap: () {
                              // BlocProvider.of<GiveAwardBloc>(context).add(
                              //   GiveAwardButtonPressedEvent(
                              //     id: widget.post.id,
                              //     awardType: 'Local Legend',
                              //     type: 'post',
                              //   ),
                              // );

                              // Navigator.pop(context, awardsCount + 1);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset(
                                  'assets/Local_Legend.svg',
                                  width: 84,
                                  height: 84,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  // Ensures the text wraps within the available space
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Local Legend',
                                        style: blackNormalTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'Recognizing users who consistently contribute high-quality content.',
                                        style: mediumGreyTextStyleBlack,
                                        softWrap: true, // Enables text wrapping
                                      ),
                                    ],
                                  ),
                                ),
                                Text('12', style: onboardingBlackBody2Style),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              // BlocProvider.of<GiveAwardBloc>(context).add(
                              //   GiveAwardButtonPressedEvent(
                              //     id: widget.post.id,
                              //     awardType: 'Local Legend',
                              //     type: 'post',
                              //   ),
                              // );

                              // Navigator.pop(context, awardsCount + 1);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset(
                                  'assets/Sunflower.svg',
                                  width: 84,
                                  height: 84,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  // Ensures the text wraps within the available space
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Sunflower',
                                        style: blackNormalTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'For bringing positivity and cheerfulness to the community.',
                                        style: mediumGreyTextStyleBlack,
                                        softWrap: true, // Enables text wrapping
                                      ),
                                    ],
                                  ),
                                ),
                                Text('12', style: onboardingBlackBody2Style),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              // BlocProvider.of<GiveAwardBloc>(context).add(
                              //   GiveAwardButtonPressedEvent(
                              //     id: widget.post.id,
                              //     awardType: 'Local Legend',
                              //     type: 'post',
                              //   ),
                              // );

                              // Navigator.pop(context, awardsCount + 1);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset(
                                  'assets/Streetlight.svg',
                                  width: 84,
                                  height: 84,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  // Ensures the text wraps within the available space
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Streetlight',
                                        style: blackNormalTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'For providing clear guidance and valuable insights.',
                                        style: mediumGreyTextStyleBlack,
                                        softWrap: true, // Enables text wrapping
                                      ),
                                    ],
                                  ),
                                ),
                                Text('12', style: onboardingBlackBody2Style),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              // BlocProvider.of<GiveAwardBloc>(context).add(
                              //   GiveAwardButtonPressedEvent(
                              //     id: widget.post.id,
                              //     awardType: 'Local Legend',
                              //     type: 'post',
                              //   ),
                              // );

                              // Navigator.pop(context, awardsCount + 1);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset(
                                  'assets/Park_Bench.svg',
                                  width: 84,
                                  height: 84,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  // Ensures the text wraps within the available space
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Park Bench',
                                        style: blackNormalTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'For offering comforting and supportive posts.',
                                        style: mediumGreyTextStyleBlack,
                                        softWrap: true, // Enables text wrapping
                                      ),
                                    ],
                                  ),
                                ),
                                Text('12', style: onboardingBlackBody2Style),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              // BlocProvider.of<GiveAwardBloc>(context).add(
                              //   GiveAwardButtonPressedEvent(
                              //     id: widget.post.id,
                              //     awardType: 'Local Legend',
                              //     type: 'post',
                              //   ),
                              // );

                              // Navigator.pop(context, awardsCount + 1);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset(
                                  'assets/Map.svg',
                                  width: 84,
                                  height: 84,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  // Ensures the text wraps within the available space
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Map',
                                        style: blackNormalTextStyle,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'For creating informative and detailed content.',
                                        style: mediumGreyTextStyleBlack,
                                        softWrap: true, // Enables text wrapping
                                      ),
                                    ],
                                  ),
                                ),
                                Text('12', style: onboardingBlackBody2Style),
                              ],
                            ),
                          ),
                        ])),
              ],
            )));
  }
}
