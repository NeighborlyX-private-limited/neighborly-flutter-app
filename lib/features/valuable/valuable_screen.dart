import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neighborly_flutter_app/features/valuable/controller.dart' as vc;

class InsightsScreen extends StatelessWidget {
  final vc.InsightsController controller = Get.put(vc.InsightsController());

  InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: const [
                  Icon(Icons.lightbulb_outline, color: Colors.amber),
                  SizedBox(width: 8),
                  Text(
                    "Valuable Insights",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                "Sector 69, Gurgaon",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                "Sector 69 is full of societies and PGs. Genpact office provides many jobs. Crowd is mostly working professionals and students.",
              ),
              const SizedBox(height: 12),

              // Tabs (no Obx here to avoid improper use warning)
              Row(
                children: [
                  _tabButton("Food", vc.CategoryType.food),
                  const SizedBox(width: 8),
                  _tabButton("Social", vc.CategoryType.social),
                  const SizedBox(width: 8),
                  _tabButton("Misc", vc.CategoryType.misc),
                ],
              ),

              const SizedBox(height: 12),

              // Posts
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.insights.isEmpty) {
                    return const Center(child: Text("No posts found."));
                  }
                  return ListView.builder(
                    itemCount: controller.insights.length,
                    itemBuilder: (context, index) {
                      final post = controller.insights[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title + verified
                              Row(
                                children: [
                                  const Icon(Icons.restaurant_menu,
                                      color: Colors.orange),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      post.title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  if (post.isVerified)
                                    Chip(
                                      label: const Text(
                                        "Verified",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      backgroundColor: Colors.green[50],
                                      avatar: const Icon(
                                        Icons.verified,
                                        color: Colors.green,
                                        size: 16,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(post.description),
                              const SizedBox(height: 10),

                              // Buttons
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () =>
                                            controller.likePost(post.id),
                                        icon: const Icon(
                                            Icons.thumb_up_alt_outlined),
                                      ),
                                      Text(post.likes.toString()),
                                      const SizedBox(width: 12),
                                      IconButton(
                                        onPressed: () =>
                                            controller.dislikePost(post.id),
                                        icon: const Icon(
                                            Icons.thumb_down_alt_outlined),
                                      ),
                                      Text(post.dislikes.toString()),
                                    ],
                                  ),
                                  IconButton(
                                    onPressed: () =>
                                        controller.reportPost(post.id),
                                    icon: const Icon(Icons.flag_outlined),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabButton(String label, vc.CategoryType type) {
    return Obx(() {
      final isSelected = controller.selectedCategory.value == type;
      return GestureDetector(
        onTap: () {
          controller.selectedCategory.value = type;
          controller.fetchInsights();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    });
  }
}
