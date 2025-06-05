import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/constants/app_images.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/core/widgets/custom_snackbar.dart';
import 'package:neighborly_flutter_app/core/widgets/indicator/custom_circular_progress_indicator.dart';
import 'package:neighborly_flutter_app/features/chat/presentation/screens/chat_group_screen.dart';

import '../../../../core/widgets/svg_icon.dart';
import '../../../communities/presentation/bloc/community_detail_cubit.dart';
import '../bloc/bloc/interest_bloc.dart';
import '../bloc/bloc/save_interest_bloc.dart';
import '../bloc/bloc/save_interest_event.dart';

class InterestSelectionScreen extends StatefulWidget {
  const InterestSelectionScreen({super.key});

  @override
  InterestSelectionScreenState createState() => InterestSelectionScreenState();
}

class InterestSelectionScreenState extends State<InterestSelectionScreen> {
  late InterestBloc interestBloc;
  @override
  void initState() {
    print('i am inside correct screen');
    super.initState();

    interestBloc = BlocProvider.of<InterestBloc>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InterestBloc>().add(FeatchInterestEvent());
    });
  }

  Set<String> selectedCategories = {};

  void toggleCategory(String category) {
    setState(() {
      if (selectedCategories.contains(category)) {
        selectedCategories.remove(category);
      } else {
        selectedCategories.add(category);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isButtonActive = selectedCategories.length >= 3;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              SvgPicture.asset(
                AppImages.appLogo,
                height: 24,
                width: 24,
              ),
            ],
          ),
        ),
        actions: [
          // CHAT BUTTON
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: InkWell(
              onTap: () {
                context.push('/chat');
              },
              child: CircularSvgImage(
                assetPath: AppImages.chatIcon,
              ),
            ),
          ),
        ],
      ),
      body: BlocConsumer<InterestBloc, InterestState>(
        listener: (context, state) {
          if (state is InterestSuccessState) {
            selectedCategories.addAll(state.interests.userInterests.toList());
          }
        },
        builder: (context, state) {
          if (state is InterestLoadingState) {
            return CustomCircularIndicator();
          }
          if (state is InterestFailureState) {
            return Text('error');
          }
          if (state is InterestSuccessState) {
            print(state.interests);
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Choose Your Interests",
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Choose three or more options",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.greyColor,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Categories Grid
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: state.interests.availableInterests
                              .map((category) {
                            bool isSelected =
                                selectedCategories.contains(category);
                            return GestureDetector(
                              onTap: () => toggleCategory(category),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primaryColor
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: AppColors.primaryColor,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  category,
                                  style: TextStyle(
                                    color: isSelected
                                        ? AppColors.whiteColor
                                        : AppColors.blackColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),

                // Sticky Bottom Button
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: BlocConsumer<SaveInterestBloc, SaveInterestState>(
                      listener: (context, state) {
                        if (state is SaveInterestSuccessState) {
                          context.push('/discover');
                        } else if (state is SaveInterestFailureState) {
                          showSnackBar(context: context, message: state.error);
                        }
                      },
                      builder: (context, state) {
                        if (state is SaveInterestLoadingState) {
                          return CustomCircularIndicator();
                        }
                        return ElevatedButton(
                          onPressed: isButtonActive
                              ? () {
                                  context.read<SaveInterestBloc>().add(
                                        SaveUserInterestEvent(
                                          userInterests:
                                              selectedCategories.toList(),
                                        ),
                                      );

                                  print(
                                      "Selected Categories: $selectedCategories");
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor:
                                AppColors.primaryColor.withOpacity(0.2),
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Text(
                            "Save Interest",
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}
