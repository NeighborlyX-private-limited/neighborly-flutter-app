import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/features/authentication/presentation/cubit/tutorial_cubit.dart';
import 'package:neighborly_flutter_app/features/authentication/presentation/cubit/tutorial_state.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/custom_snackbar.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  TutorialScreenState createState() => TutorialScreenState();
}

class TutorialScreenState extends State<TutorialScreen> {
  late TutorialCubit _tutorialCubit;
  int _currentPage = 0;
  double topPositionOffset = 0.38;
  double leftPositionOffset = 0.05;

  final List<Map<String, String>> tutorialContent = [
    {
      'title': 'Cheers',
      'description':
          'Show your appreciation!\nTap Cheers to celebrate great posts or comments and spread positivity in your neighborhood.'
    },
    {
      'title': 'Boos',
      'description':
          'Express your opinion!\nTap Boo to let others know when you disagree with a post or comment—your voice matters.'
    },
    {
      'title': 'Earn Awards',
      'description':
          'Stand out in your community!\nContribute, engage, and earn Awards for being an active and helpful neighbor. Recognize others and be recognized for your efforts!'
    },
    {
      'title': 'Change Your Location',
      'description':
          'Switch locations effortlessly and stay updated on local posts, events, communities, and discussions!'
    },
    {
      'title': 'Stay Updated with Popular Locations',
      'description':
          'Quickly explore top cities and connect with local posts, events, communities and discussions!'
    },
  ];

  final List<String> tutorialImages = [
    AppImages.tute1,
    AppImages.tute2,
    AppImages.tute3,
    AppImages.tute4,
    AppImages.tute5,
  ];

  // INIT STATE
  @override
  void initState() {
    super.initState();
    _tutorialCubit = GetIt.instance<TutorialCubit>();
  }

  // SWITCH TO NEXT SCREEN
  void _nextPage() {
    setState(
      () {
        if (_currentPage < tutorialContent.length - 1) {
          _currentPage++;
          if (_currentPage == 1) {
            leftPositionOffset = 0.2;
          }
          if (_currentPage == 2) {
            leftPositionOffset = 0.07;
          }
          if (_currentPage == 3) {
            topPositionOffset = 0.32;
            leftPositionOffset = 0.1;
          }
          if (_currentPage == 4) {
            topPositionOffset = 0.30;
            leftPositionOffset = 0.15;
          }
        } else {
          _tutorialCubit.updateTutorialStatus(true, false);
        }
      },
    );
  }

  // PRESS SKIP
  void _skipTutorial() {
    _tutorialCubit.updateTutorialStatus(false, true);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: BlocListener<TutorialCubit, TutorialState>(
          bloc: _tutorialCubit,
          listener: (context, state) {
            // SUCCESS STATE
            if (state is TutorialUpdateSuccess) {
              context.go('/home');
            }
            // FAILURE STATE
            if (state is TutorialUpdateFailure) {
              if (mounted) {
                showSnackBar(context: context, message: state.error);
              }
            }
          },
          child: Stack(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _currentPage != 4
                    ? SvgPicture.asset(
                        tutorialImages[_currentPage],
                        key: ValueKey<int>(_currentPage),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        placeholderBuilder: (context) =>
                            CircularProgressIndicator(),
                      )
                    : Image.asset(
                        AppImages.tute5,
                        fit: BoxFit.cover,
                      ),
              ),
              Positioned(
                top: screenHeight * topPositionOffset,
                left: screenWidth * leftPositionOffset,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      key: ValueKey<int>(_currentPage),
                      width: screenWidth * 0.7,
                      padding: const EdgeInsets.only(
                        top: 8.0,
                        right: 12.0,
                        bottom: 1.0,
                        left: 18.0,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.blackColor.withOpacity(0.26),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              tutorialContent[_currentPage]['title']!,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              tutorialContent[_currentPage]['description']!,
                              style: const TextStyle(fontSize: 14),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: _nextPage,
                                child: Text(
                                  _currentPage < tutorialContent.length - 1
                                      ? 'Next'
                                      : 'End Tour',
                                ),
                              ),
                              if (_currentPage < tutorialContent.length - 1)
                                TextButton(
                                  onPressed: _skipTutorial,
                                  child: const Text(
                                    'Skip',
                                    style:
                                        TextStyle(color: AppColors.greyColor),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
