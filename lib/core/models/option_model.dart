import '../entities/option_entity.dart';

class OptionModel extends OptionEntity {
  const OptionModel({
    required super.option,
    required super.optionId,
    required super.votes,
    required super.userVoted 
  });

  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(
      option: json['option']['option'],
      optionId: json['optionId'],
      votes: json['votes'],
      userVoted : json['userVoted'] ?? false
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'option': option,
      'optionId': optionId,
      'votes': votes,
      'userVoted ': userVoted 
    };
  }
}
