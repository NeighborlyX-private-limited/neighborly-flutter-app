import 'package:flutter/material.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';

class EditInterestScreen extends StatefulWidget {
  // final List<String> selectedInterests; // Interests from previous screen

  const EditInterestScreen({super.key});

  @override
  EditInterestScreenState createState() => EditInterestScreenState();
}

class EditInterestScreenState extends State<EditInterestScreen> {
  // Simulating backend data
  final List<String> allCategories = [
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
    "Option 1E6",
    "Option 196",
    "Option 168",
    "Option 16824",
    "Option 186",
    "Option 168",
    "Option 1768",
    "Option 164",
    "Option 1241",
    "Option 14",
    "Option 12322",
    "Option 1243",
    "Option 124",
    "Option 142",
    "Option 1423",
    "Option 132",
    "Option 1532",
    "Option 1435",
    "Option 1242",
    "Option 1242",
    "Option 125",
    "Option 1112",
    "Option 133",
    "Option 132",
    "Option 113",
    "Option 123",
    "Option 124",
    "Option 12",
    "Option 13",
    "Option 3",
  ];
  Set<String> selectedCategories = {};
  // late Set<String> selectedCategories;

  @override
  void initState() {
    super.initState();
    selectedCategories.add('Lifestyle');
    selectedCategories.add('Cooking');
    selectedCategories.add('Career');
    // selectedCategories = widget.selectedInterests.toSet(); // Load previous interests
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Your Interests"),
        actions: [
          TextButton(
            onPressed: isButtonActive
                ? () {
                    print('selectedCategories: $selectedCategories');
                    // Navigator.pop(context, selectedCategories.toList());
                  }
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
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: allCategories.map((category) {
                  bool isSelected = selectedCategories.contains(category);
                  return GestureDetector(
                    onTap: () => toggleCategory(category),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
      ),
    );
  }
}
