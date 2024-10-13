import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/features/authentication/presentation/cubit/tutorial_cubit.dart';
import 'package:neighborly_flutter_app/features/authentication/presentation/cubit/tutorial_state.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  TutorialScreenState createState() => TutorialScreenState();
}

class TutorialScreenState extends State<TutorialScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  late TutorialCubit _tutorialCubit;
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

  // List of tutorial images
  final List<String> tutorialImages = [
    'assets/tute1.svg',
    'assets/tute2.svg',
    'assets/tute3.svg',
    'assets/tute4.svg',
    'assets/tute5.svg',
  ];

  @override
  void initState() {
    super.initState();

    _tutorialCubit = GetIt.instance<TutorialCubit>();
  }

  // Move to the next tutorial page
  void _nextPage() {
    if (_currentPage < tutorialContent.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _tutorialCubit.updateTutorialStatus(true, false);
    }
  }

  //// Skip tutorial
  void _skipTutorial() {
    _tutorialCubit.updateTutorialStatus(false, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<TutorialCubit, TutorialState>(
        bloc: _tutorialCubit,
        listener: (context, state) {
          if (state is TutorialUpdateSuccess) {
            context.go('/home/false');
          } else if (state is TutorialUpdateFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Failed to update status: ${state.error}')),
            );
          }
        },
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: tutorialContent.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    // Background Image based on current page
                    Positioned.fill(
                      child: SvgPicture.asset(
                        tutorialImages[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Positioned.fill(
                    //   child: Image.asset(
                    //     tutorialImages[index],
                    //     fit: BoxFit.cover,
                    //   ),
                    // ),
                    // Overlay container with title, description, and buttons
                    Positioned.fill(
                      top: 50,
                      child: Center(
                        child: Container(
                          height: 260,
                          width: MediaQuery.of(context).size.width * 0.8,
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Display title based on current tutorial content (left-aligned)
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  tutorialContent[index]['title']!,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                             
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  tutorialContent[index]['description']!,
                                  style: const TextStyle(fontSize: 16),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (index < tutorialContent.length - 1)
                                    ElevatedButton(
                                      onPressed: _skipTutorial,
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 24, vertical: 12),
                                      ),
                                      child: const Text('Skip'),
                                    ),
                                  const SizedBox(width: 16),
                                  ElevatedButton(
                                    onPressed: _nextPage,
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 12),
                                    ),
                                    child: Text(
                                      index < tutorialContent.length - 1
                                          ? 'Next'
                                          : 'End Tour',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
