import 'dart:convert';
import '../../../../core/models/community_model.dart';
import '../../../../core/models/user_simple_model.dart';

class SearchResultModel {
  final List<CommunityModel> communities;
  final List<UserSimpleModel> people;
  SearchResultModel({
    required this.communities,
    required this.people,
  });

  @override
  String toString() =>
      'SearchResultModel(communities: $communities, people: $people)';

  Map<String, dynamic> toMap() {
    return {
      'communities': communities.map((x) => x.toMap()).toList(),
      'people': people.map((x) => x.toMap()).toList(),
    };
  }

  factory SearchResultModel.fromMap(Map<String, dynamic> map) {
    return SearchResultModel(
      communities: List<CommunityModel>.from(
          map['communities']?.map((x) => CommunityModel.fromMap(x))),
      people: List<UserSimpleModel>.from(
          map['people']?.map((x) => UserSimpleModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchResultModel.fromJson(String source) =>
      SearchResultModel.fromMap(json.decode(source));
}
