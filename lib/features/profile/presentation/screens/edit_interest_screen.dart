import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';

import '../../../../core/utils/shared_preference.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../../../../core/widgets/indicator/custom_circular_progress_indicator.dart';
import '../../../chat/presentation/bloc/bloc/interest_bloc.dart';
import '../../../chat/presentation/bloc/bloc/save_interest_bloc.dart';
import '../../../chat/presentation/bloc/bloc/save_interest_event.dart';

class EditInterestScreen extends StatefulWidget {
  // final List<String> selectedInterests; // Interests from previous screen

  const EditInterestScreen({super.key});

  @override
  EditInterestScreenState createState() => EditInterestScreenState();
}

class EditInterestScreenState extends State<EditInterestScreen> {
  Set<String> selectedCategories = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InterestBloc>().add(FeatchInterestEvent());
    });
    // setUserInterest();
  }

  setUserInterest() async {
    List<String> interests = await ShardPrefHelper.getUserInterests();
    selectedCategories = interests.toSet();
  }

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Go back
          },
        ),
        surfaceTintColor: AppColors.whiteColor,
        elevation: 2, // Increase for deeper shadow
        backgroundColor: AppColors.lightBackgroundColor,
        shadowColor: AppColors.blackColor,
        // foregroundColor: Colors.black,
        title: Text("Your Interests"),
        actions: [
          BlocConsumer<SaveInterestBloc, SaveInterestState>(
            listener: (context, state) {
              if (state is SaveInterestSuccessState) {
                Navigator.pop(context);
              } else if (state is SaveInterestFailureState) {
                showSnackBar(context: context, message: state.error);
              }
            },
            builder: (context, state) {
              if (state is SaveInterestLoadingState) {
                return CustomCircularIndicator();
              }
              return TextButton(
                onPressed: isButtonActive
                    ? () {
                        context.read<SaveInterestBloc>().add(
                              SaveUserInterestEvent(
                                userInterests: selectedCategories.toList(),
                              ),
                            );

                        print("Selected Categories: $selectedCategories");
                      }
                    // ? () {
                    //     print('selectedCategories: $selectedCategories');
                    //     // Navigator.pop(context, selectedCategories.toList());
                    //   }
                    : null,
                child: Text(
                  "Save",
                  style: TextStyle(
                    color: isButtonActive
                        ? AppColors.primaryColor
                        : AppColors.greyColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
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
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children:
                          state.interests.availableInterests.map((category) {
                        bool isSelected = selectedCategories.contains(category);
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
