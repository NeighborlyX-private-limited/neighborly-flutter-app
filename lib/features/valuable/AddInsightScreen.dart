import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/features/valuable/insight_controller.dart';

class AddInsightScreen extends StatelessWidget {
  final String id;
  AddInsightScreen({super.key, required this.id});

  final TextEditingController titleController = TextEditingController();
  final TextEditingController summaryController = TextEditingController();
  final InsightController controller = Get.put(InsightController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Insight"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   "Insight for ID: $id",
            //   style: const TextStyle(
            //     fontSize: 20,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            const SizedBox(height: 20),

            // 🔹 Title Field
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // 🔹 Summary Field
            TextField(
              controller: summaryController,
              decoration: const InputDecoration(
                labelText: "Summary",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 40),

            // 🔹 Button in middle
            Center(
              child: Obx(() => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor, // red background
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: controller.isInLoading.value
                    ? null
                    : () {
                  controller.submitInsight(
                    id,
                    titleController.text,
                    summaryController.text,
                    context
                  );
                },
                child: controller.isInLoading.value
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text(
                  "Add Insight",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
