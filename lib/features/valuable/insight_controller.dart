import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neighborly_flutter_app/features/valuable/report_reason_model.dart';

import '../../core/utils/shared_preference.dart';
import '../../core/widgets/custom_snackbar.dart';
import '../../main.dart';
import 'category_model.dart';
import 'insight_service.dart';

class InsightController extends GetxController {
  var isLoading = true.obs;
  var insightsResponse = Rxn<InsightsResponse>();
  var selectedCategorySlug = ''.obs;
  var isInLoading = false.obs;
  final _service = InsightService();



  @override
  void onInit() {
    super.onInit();
    double lat = ShardPrefHelper.getLat() ?? 0.0;
    double lng = ShardPrefHelper.getLng() ?? 0.0;
    fetchInsights(lat: lat, lon: lng); // example coordinates
  }

  void fetchInsights({required double lat, required double lon}) async {
    isLoading.value = true;
    try {
      final data = await _service.fetchInsights(lat: lat, lon: lon);
      insightsResponse.value = data;
      if (data.categories.isNotEmpty) {
        selectedCategorySlug.value = data.categories.first.slug;
      }
    } catch (e) {
     print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void selectCategory(String slug) {
    selectedCategorySlug.value = slug;
  }

  List<InsightModel> get currentInsights {
    if (insightsResponse.value == null) return [];
    return insightsResponse.value!.insights[selectedCategorySlug.value] ?? [];
  }

  // ✅ Voting method
  Future<void> voteOnInsight(String insightId, String voteType,BuildContext ct) async {
    try {
      final success = await _service.voteOnInsight(insightId, voteType);
      if (success) {
        final list = currentInsights;
        final item = list.firstWhereOrNull((e) => e.id == insightId);
        if (item != null) {
          if (voteType == "cheer") {
            item.cheers += 1;
          } else if (voteType == "boo") {
            item.boos += 1;
          }
          insightsResponse.refresh(); // trigger UI update
          //showSnackBar(context: ct, message: 'We have received your report and will evaluate the insight, meanwhile try to ignore the noise!');

        }
      } else {
        print('error');
      }
    } catch (e) {
      print('error: $e');

    }
  }
  Future<dynamic> getReportReasons() async {
    try {
      return await InsightService().fetchReportReasons();
    } catch (e) {
      debugPrint("Error fetching report reasons: $e");
      return [];
    }
  }

  Future<void> reportInsight(String insightId, String reason,BuildContext ct) async {
    try {
      await InsightService().sendReport(insightId, reason);
      print('donne');





    } catch (e) {

      print('error $e');
    }
  }
  Future<void> submitInsight(String id, String title,String summary,BuildContext ct) async {
    if (summary.isEmpty) {

      return;
    }

    try {
      isInLoading.value = true;
print('here');
      // 🔹 Mock API call (replace with real API)
      await InsightService().addInsight(categoryId: id, title:title,summary: summary);

      // Example: Success response
      //Get.snackbar("Success", "Insight submitted for ID: $id");
      rootScaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(
          content: Text(
              'Your insight has been added!'),
          duration: Duration(seconds: 2),
        ),
      );
      // Optionally: navigate back
     Navigator.pop(ct);
    } catch (e) {
      //Get.snackbar("Error", "Something went wrong");
    } finally {
      isInLoading.value = false;
    }
  }

}
