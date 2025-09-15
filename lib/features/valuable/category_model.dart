class CategoryModel {
  final String id;
  final String slug;
  final String name;
  final String iconUrl;

  CategoryModel({
    required this.id,
    required this.slug,
    required this.name,
    required this.iconUrl,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? '',
      slug: json['slug'] ?? '',
      name: json['name'] ?? '',
      iconUrl: json['icon_url'] ?? '',
    );
  }
}

class InsightModel {
  final String id;
  final String title;
  final String summary;
   int cheers;
   int boos;
  final String? statusTag;
  final String source;

  InsightModel({
    required this.id,
    required this.title,
    required this.summary,
    required this.cheers,
    required this.boos,
    required this.source,
    this.statusTag,
  });

  factory InsightModel.fromJson(Map<String, dynamic> json) {
    return InsightModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      summary: json['summary'] ?? '',
      cheers: json['cheers'] ?? 0,
      boos: json['boos'] ?? 0,
      source: json['source'] ?? '',
      statusTag: json['status_tag'],
    );
  }
}

class InsightsResponse {
  final String locationSummary;
  final List<CategoryModel> categories;
  final Map<String, List<InsightModel>> insights;

  InsightsResponse({
    required this.locationSummary,
    required this.categories,
    required this.insights,
  });

  factory InsightsResponse.fromJson(Map<String, dynamic> json) {
    final categories = (json['categories'] as List)
        .map((e) => CategoryModel.fromJson(e))
        .toList();

    final Map<String, List<InsightModel>> insights = {};
    (json['insights'] as Map<String, dynamic>).forEach((key, value) {
      insights[key] =
          (value as List).map((e) => InsightModel.fromJson(e)).toList();
    });

    return InsightsResponse(
      locationSummary: json['location_summary'] ?? '',
      categories: categories,
      insights: insights,
    );
  }
}
