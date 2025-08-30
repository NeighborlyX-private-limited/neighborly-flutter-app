import 'package:get/get.dart';
import 'package:neighborly_flutter_app/features/valuable/valueable_model.dart';

enum CategoryType { food, social, misc }

class InsightsController extends GetxController {
  var insights = <InsightModel>[].obs;
  var isLoading = false.obs;
  var selectedCategory = CategoryType.food.obs;

  Future<void> fetchInsights({String? location}) async {
    isLoading.value = true;
    try {
      final category = selectedCategory.value.name;
      final url = location != null
          ? "https://api.example.com/insights?category=$category&location=$location"
          : "https://api.example.com/insights?category=$category";

      final response = await GetConnect().get(url);

      if (response.statusCode == 200) {
        insights.value = (response.body as List)
            .map((e) => InsightModel.fromJson(e))
            .toList();
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> likePost(String id) async {
    await GetConnect().post("https://api.example.com/like/$id", {});
    fetchInsights();
  }

  Future<void> dislikePost(String id) async {
    await GetConnect().post("https://api.example.com/dislike/$id", {});
    fetchInsights();
  }

  Future<void> reportPost(String id) async {
    await GetConnect().post("https://api.example.com/report/$id", {});
    Get.snackbar("Reported", "Thanks for your feedback!");
  }
}
