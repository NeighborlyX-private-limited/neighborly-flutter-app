import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/constants/app_images.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/features/chat/presentation/screens/chat_group_screen.dart';

class InterestSelectionScreen extends StatefulWidget {
  const InterestSelectionScreen({super.key});

  @override
  InterestSelectionScreenState createState() => InterestSelectionScreenState();
}

class InterestSelectionScreenState extends State<InterestSelectionScreen> {
  // Simulating backend data
  final List<String> categories = [
    "Music",
    "Movies",
    "Cricket",
    "Travel",
    "Books",
    "Cars",
    "Bikes",
    "Technology",
    "Blockchain",
    "Guitar",
    "Fashion",
    "Painting",
    "Hip-Hop",
    "Dance",
    "Pets",
    "Piano",
    "Food",
    "Yoga & Meditation",
    "Cycling Clubs",
    "Museums",
    "Career",
    "Handicrafts",
    "Poetry",
    "Lifestyle",
    "Gardening",
    "Sustainable Living",
    "Mental Health",
    "Cooking",
    "Option 1",
    "Photography",
    "Fitness",
    "Coding",
    "Nature",
    "Art",
    "Gaming",
    "Entrepreneurship"
  ];

  Set<String> selectedCategories = {}; // Store selected categories

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
      ),
      body: Column(
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
                      fontSize: 20,
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "Choose three or more options",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.greyColor,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Categories Grid
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: categories.map((category) {
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
                  SizedBox(height: 100),
                ],
              ),
            ),
          ),

          // Sticky Bottom Button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: isButtonActive
                    ? () {
                        context.push('/edit-interest');
                        print("Selected Categories: $selectedCategories");
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor:
                      AppColors.primaryColor.withOpacity(0.3),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  "Save Interest",
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
