import 'dart:convert';

import '../../domain/entities/search_history_entity.dart';

class SearchHistoryModel extends SearchHistoryEntity {
  SearchHistoryModel({required super.term});

  SearchHistoryEntity copyWith({
    String? term,
  }) {
    return SearchHistoryEntity(
      term: term ?? this.term,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'term': term,
    };
  }

  factory SearchHistoryModel.fromMap(Map<String, dynamic> map) {
    return SearchHistoryModel(
      term: map['term'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchHistoryModel.fromJson(String source) =>
      SearchHistoryModel.fromMap(json.decode(source));

  static List<SearchHistoryModel> fromJsonList(List<dynamic> json) {
    var list = <SearchHistoryModel>[];

    if (json.isNotEmpty) {
      list = json
          .map<SearchHistoryModel>(
              (jsomItem) => SearchHistoryModel.fromMap(jsomItem))
          .toList();
    }

    return list;
  }

  @override
  String toString() => 'SearchHistoryModel(term: $term)';
}
