import 'dart:convert';
import '../../../../core/models/community_model.dart';
import '../../../../core/models/post_model.dart';
import '../../../../core/models/user_simple_model.dart';

class SearchResultModel {
  final List<PostModel> trendingPost;
  final List<PostModel> localPost;
  // final List<CommunityModel> communities;
  // final List<UserSimpleModel> people;
  SearchResultModel({
    // required this.communities,
    // required this.people,
    required this.trendingPost,
    required this.localPost,
  });

  @override
  String toString() =>
      'SearchResultModel(trendingPost: $trendingPost, localPost: $localPost)';

  // Map<String, dynamic> toMap() {
  //   return {
  //     'localPost': localPost.map((x) => x.toMap()).toList(),
  //     'trendingPost': trendingPost.map((x) => x.toMap()).toList(),
  //     // 'communities': communities.map((x) => x.toMap()).toList(),
  //     // 'people': people.map((x) => x.toMap()).toList(),
  //   };
  // }

  factory SearchResultModel.fromMap(Map<String, dynamic> map) {
    return SearchResultModel(
      trendingPost: List<PostModel>.from(
          map['globalSearchData']?.map((x) => PostModel.fromJson(x))),
      localPost: List<PostModel>.from(
          map['localSearchData']?.map((x) => PostModel.fromJson(x))),
    );
  }

  // String toJson() => json.encode(toMap());

  factory SearchResultModel.fromJson(String source) =>
      SearchResultModel.fromMap(json.decode(source));
}
