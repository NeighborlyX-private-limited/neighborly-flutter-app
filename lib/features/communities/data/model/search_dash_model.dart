
import 'dart:convert';

import '../../../../core/models/community_model.dart';
import 'search_history_model.dart';

class SearchDashModel {
  final List<SearchHistoryModel> history;
  final List<CommunityModel> trending;
  
  SearchDashModel({
    required this.history,
    required this.trending,
  });
  

  @override
  String toString() => 'SearchDashModel(history: $history, trending: $trending)';

  Map<String, dynamic> toMap() {
    return {
      'history': history.map((x) => x.toMap()).toList(),
      'trending': trending.map((x) => x.toMap()).toList(),
    };
  }

  factory SearchDashModel.fromMap(Map<String, dynamic> map) {
    return SearchDashModel(
      history: List<SearchHistoryModel>.from(map['history']?.map((x) => SearchHistoryModel.fromMap(x))),
      trending: List<CommunityModel>.from(map['trending']?.map((x) => CommunityModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchDashModel.fromJson(String source) => SearchDashModel.fromMap(json.decode(source));
}
