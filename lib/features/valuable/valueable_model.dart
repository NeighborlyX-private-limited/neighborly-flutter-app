class InsightModel {
  final String id;
  final String title;
  final String description;
  final bool isVerified;
  final int likes;
  final int dislikes;

  InsightModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isVerified,
    required this.likes,
    required this.dislikes,
  });

  factory InsightModel.fromJson(Map<String, dynamic> json) {
    return InsightModel(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      isVerified: json['isVerified'] ?? false,
      likes: json['likes'] ?? 0,
      dislikes: json['dislikes'] ?? 0,
    );
  }
}
