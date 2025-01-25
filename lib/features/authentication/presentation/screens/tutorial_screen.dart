import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/features/authentication/presentation/cubit/tutorial_cubit.dart';
import 'package:neighborly_flutter_app/features/authentication/presentation/cubit/tutorial_state.dart';
import '../../../../core/theme/colors.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  TutorialScreenState createState() => TutorialScreenState();
}

class TutorialScreenState extends State<TutorialScreen> {
  int _currentPage = 0;
  late TutorialCubit _tutorialCubit;
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
      'title': 'Set Your Home Location',
      'description':
          'Your home location helps you stay connected with your community. It defaults to New Delhi, but you can update it anytime!'
    },
    {
      'title': 'Stay Updated with Your Current Location',
      'description':
          'Keep track of what’s happening around you! Your current location is updated automatically using GPS so you can stay connected with nearby neighbors wherever you go.'
    },
  ];

  final List<String> tutorialImages = [
    'assets/tute1.svg',
    'assets/tute2.svg',
    'assets/tute3.svg',
    'assets/tute4.svg',
    'assets/tute5.svg',
  ];

  /// init method
  @override
  void initState() {
    super.initState();
    _tutorialCubit = GetIt.instance<TutorialCubit>();
  }

  /// go to next page method
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
            topPositionOffset = 0.1;
            leftPositionOffset = 0.1;
          }
          if (_currentPage == 4) {
            topPositionOffset = 0.1;
            leftPositionOffset = 0.15;
          }
        } else {
          _tutorialCubit.updateTutorialStatus(true, false);
        }
      },
    );
  }

  /// skip button method
  void _skipTutorial() {
    _tutorialCubit.updateTutorialStatus(false, true);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: BlocListener<TutorialCubit, TutorialState>(
        bloc: _tutorialCubit,
        listener: (context, state) {
          ///success state
          if (state is TutorialUpdateSuccess) {
            context.go('/home/Home');
          } else if (state is TutorialUpdateFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to update status: ${state.error}'),
              ),
            );
          }
        },
        child: Stack(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: SvgPicture.asset(
                tutorialImages[_currentPage],
                key: ValueKey<int>(_currentPage),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
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
                                  style: TextStyle(color: AppColors.greyColor),
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
    );
  }
}
