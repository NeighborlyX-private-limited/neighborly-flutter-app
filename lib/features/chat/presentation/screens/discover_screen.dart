import 'package:flutter/material.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  DiscoverScreenState createState() => DiscoverScreenState();
}

class DiscoverScreenState extends State<DiscoverScreen> {
  final List<Map<String, dynamic>> users = [
    {
      "name": "Cameron Williamson",
      "distance": "1 KM (Approx.)",
      "image": "https://via.placeholder.com/50",
      "interests": ["Music", "Cars", "Guitar", "Technology", "Movies"],
    },
    {
      "name": "Angel",
      "distance": "1 KM (Approx.)",
      "image": "https://via.placeholder.com/50",
      "interests": ["Nature", "Technology", "Movies"],
    },
    {
      "name": "Mitchell",
      "distance": "5 KM (Approx.)",
      "image": "https://via.placeholder.com/50",
      "interests": [
        "Music",
        "Guitar",
        "Technology",
        "Technology",
        "Technology",
        "Technology",
        "Technology"
      ],
    },
    {
      "name": "tinyLeopard720",
      "distance": "3 KM (Approx.)",
      "image": "https://via.placeholder.com/50",
      "interests": ["Gaming", "Coding", "AI", "Tech"],
    },
  ];

  Map<String, bool> showMoreMap = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Connect with Neighbours"),
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: users.length,
        itemBuilder: (context, index) {
          var user = users[index];
          bool showMore = showMoreMap[user["name"]] ?? false;
          int maxTags = 3;

          return Container(
            margin: EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.lightGreyColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Details
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user["image"]),
                    radius: 24,
                  ),
                  title: Text(
                    user["name"],
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    user["distance"],
                    style: TextStyle(color: Colors.grey),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.chat_bubble_outline, color: Colors.blue),
                    onPressed: () {
                      // Handle chat button click
                    },
                  ),
                ),

                SizedBox(height: 8),

                // Interests
                Padding(
                  padding: const EdgeInsets.only(
                    left: 12,
                    right: 12,
                    bottom: 12,
                  ),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ...user["interests"]
                          .take(showMore ? user["interests"].length : maxTags)
                          .map((interest) => InterestChip(interest)),
                      if (user["interests"].length > maxTags)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              showMoreMap[user["name"]] = !showMore;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.primaryColor),
                            ),
                            child: Text(
                              showMore ? "Show less" : "Show more",
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Widget for Interest Chips
class InterestChip extends StatelessWidget {
  final String interest;
  const InterestChip(this.interest, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.greyColor),
      ),
      child: Text(
        interest,
        style: TextStyle(
          color: AppColors.greyColor.withOpacity(0.7),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
