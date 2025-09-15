class ReportReason {
  final String id;
  final String label;
  final String description;

  ReportReason({
    required this.id,
    required this.label,
    required this.description,
  });

  factory ReportReason.fromJson(Map<String, dynamic> json) {
    return ReportReason(
      id: json['id'],
      label: json['label'],
      description: json['description'],
    );
  }
}
