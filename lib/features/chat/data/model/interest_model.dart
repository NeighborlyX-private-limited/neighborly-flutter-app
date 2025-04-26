import '../../domain/entities/interest_entity.dart';

class InterestModel extends InterestEntity {
  const InterestModel({
    required super.availableInterests,
    required super.userInterests,
  });

  factory InterestModel.fromJson(Map<String, dynamic> json) {
    return InterestModel(
      availableInterests: List<String>.from(json['availableInterests'] ?? []),
      userInterests: List<String>.from(json['userInterests'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'availableInterests': availableInterests,
      'userInterests': userInterests,
    };
  }
}
