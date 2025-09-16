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
  // Future<void> voteOnInsight(String insightId, String voteType,BuildContext ct) async {
  //   try {
  //     final success = await _service.voteOnInsight(insightId, voteType);
  //     if (success) {
  //       final list = currentInsights;
  //       final item = list.firstWhereOrNull((e) => e.id == insightId);
  //       if (item != null) {
  //         if (voteType == "cheer") {
  //           item.cheers += 1;
  //         } else if (voteType == "boo") {
  //           item.boos += 1;
  //         }
  //         item.userVote = UserVoteModel(
  //           hasVoted: true,
  //           voteType: voteType,
  //         );
  //         insightsResponse.refresh(); // trigger UI update
  //         //showSnackBar(context: ct, message: 'We have received your report and will evaluate the insight, meanwhile try to ignore the noise!');
  //
  //       }
  //     } else {
  //       print('error');
  //     }
  //   } catch (e) {
  //     print('error: $e');
  //
  //   }
  // }
  // Future<void> voteOnInsight(String insightId, String voteType, BuildContext ct) async {
  //   try {
  //     final success = await _service.voteOnInsight(insightId, voteType);
  //
  //     if (success) {
  //       final list = currentInsights;
  //       final item = list.firstWhereOrNull((e) => e.id == insightId);
  //
  //       if (item != null) {
  //         final previousVote = item.userVote?.voteType;
  //
  //         // Case 1: user clicks the same vote again → remove vote
  //         if (previousVote == voteType) {
  //           if (voteType == "cheer" && item.cheers > 0) {
  //             item.cheers -= 1;
  //           } else if (voteType == "boo" && item.boos > 0) {
  //             item.boos -= 1;
  //           }
  //           item.userVote = UserVoteModel(hasVoted: false, voteType: null);
  //         }
  //         // Case 2: user switches vote (cheer → boo or boo → cheer)
  //         else if (previousVote != null && previousVote != voteType) {
  //           if (previousVote == "cheer" && item.cheers > 0) {
  //             item.cheers -= 1;
  //           } else if (previousVote == "boo" && item.boos > 0) {
  //             item.boos -= 1;
  //           }
  //
  //           if (voteType == "cheer") {
  //             item.cheers += 1;
  //           } else if (voteType == "boo") {
  //             item.boos += 1;
  //           }
  //           item.userVote = UserVoteModel(hasVoted: true, voteType: voteType);
  //         }
  //         // Case 3: fresh vote
  //         else {
  //           if (voteType == "cheer") {
  //             item.cheers += 1;
  //           } else if (voteType == "boo") {
  //             item.boos += 1;
  //           }
  //           item.userVote = UserVoteModel(hasVoted: true, voteType: voteType);
  //         }
  //
  //         insightsResponse.refresh(); // trigger UI update
  //       }
  //     } else {
  //       print('Vote API failed');
  //     }
  //   } catch (e) {
  //     print('Vote error: $e');
  //   }
  // }
  Future<void> voteOnInsight(String insightId, String voteType, BuildContext ct) async {
    // if (_votingInProgress.contains(insightId)) return; // prevent multiple taps
    // _votingInProgress.add(insightId);

    try {
      final success = await _service.voteOnInsight(insightId, voteType);
      if (!success) return;

      final list = currentInsights;
      final item = list.firstWhereOrNull((e) => e.id == insightId);
      if (item == null) return;

      final previousVote = item.userVote?.voteType;

      // 👉 Case 1: clicking the same vote again -> remove it
      if (previousVote == voteType) {
        if (voteType == 'cheer' && item.cheers > 0) item.cheers -= 1;
        if (voteType == 'boo' && item.boos > 0) item.boos -= 1;
        item.userVote = UserVoteModel(hasVoted: false, voteType: null);
      }

      // 👉 Case 2: switching vote (boo -> cheer OR cheer -> boo)
      else if (previousVote != null && previousVote != voteType) {
        // remove previous
        if (previousVote == 'cheer' && item.cheers > 0) item.cheers -= 1;
        if (previousVote == 'boo' && item.boos > 0) item.boos -= 1;

        // add new
        if (voteType == 'cheer') item.cheers += 1;
        if (voteType == 'boo') item.boos += 1;

        item.userVote = UserVoteModel(hasVoted: true, voteType: voteType);
      }

      // 👉 Case 3: first time vote
      else {
        if (voteType == 'cheer') item.cheers += 1;
        if (voteType == 'boo') item.boos += 1;
        item.userVote = UserVoteModel(hasVoted: true, voteType: voteType);
      }

      insightsResponse.refresh(); // trigger UI update
    } catch (e) {
      debugPrint('Vote error: $e');
    } finally {
      // _votingInProgress.remove(insightId);
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
