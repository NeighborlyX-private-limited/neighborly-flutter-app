import 'package:neighborly_flutter_app/core/entities/option_entity.dart';

class OptionModel extends OptionEntity {
  const OptionModel({
    required super.option,
    required super.optionId,
    required super.votes,
  });

  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(
      option: json['option']['option'],
      optionId: json['optionId'],
      votes: json['votes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'option': option,
      'optionId': optionId,
      'votes': votes,
    };
  }
}
