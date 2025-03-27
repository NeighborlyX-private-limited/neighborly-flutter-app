class SearchModel {
  final List<PostModel> globalSearchData;
  final List<PostModel> localSearchData;

  SearchModel({
    required this.globalSearchData,
    required this.localSearchData,
  });

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    return SearchModel(
      globalSearchData: (json['globalSearchData'] as List)
          .map((e) => PostModel.fromJson(e))
          .toList(),
      localSearchData: (json['localSearchData'] as List)
          .map((e) => PostModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'globalSearchData': globalSearchData.map((e) => e.toJson()).toList(),
      'localSearchData': localSearchData.map((e) => e.toJson()).toList(),
    };
  }
}

class PostModel {
  final int contentId;
  final String userId;
  final String username;
  final String title;
  final String body;
  final List<String> multimedia;
  final String createdAt;
  final int cheers;
  final int boos;
  final String postLocation;
  final String city;
  final String type;
  final List<PollOptionModel>? pollOptions;
  final bool allowMultipleVotes;
  final String? thumbnail;
  final bool quarantined;

  PostModel({
    required this.contentId,
    required this.userId,
    required this.username,
    required this.title,
    required this.body,
    required this.multimedia,
    required this.createdAt,
    required this.cheers,
    required this.boos,
    required this.postLocation,
    required this.city,
    required this.type,
    required this.pollOptions,
    required this.allowMultipleVotes,
    required this.thumbnail,
    required this.quarantined,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      contentId: json['contentid'],
      userId: json['userid'],
      username: json['username'],
      title: json['title'],
      body: json['body'],
      multimedia: List<String>.from(json['multimedia']),
      createdAt: json['createdat'],
      cheers: json['cheers'],
      boos: json['boos'],
      postLocation: json['postlocation'],
      city: json['city'],
      type: json['type'],
      pollOptions: json['poll_options'] != null
          ? (json['poll_options'] as List)
              .map((e) => PollOptionModel.fromJson(e))
              .toList()
          : null,
      allowMultipleVotes: json['allow_multiple_votes'],
      thumbnail: json['thumbnail'],
      quarantined: json['quarantined'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contentid': contentId,
      'userid': userId,
      'username': username,
      'title': title,
      'body': body,
      'multimedia': multimedia,
      'createdat': createdAt,
      'cheers': cheers,
      'boos': boos,
      'postlocation': postLocation,
      'city': city,
      'type': type,
      'poll_options': pollOptions?.map((e) => e.toJson()).toList(),
      'allow_multiple_votes': allowMultipleVotes,
      'thumbnail': thumbnail,
      'quarantined': quarantined,
    };
  }
}

class PollOptionModel {
  final String option;
  final int optionId;

  PollOptionModel({
    required this.option,
    required this.optionId,
  });

  factory PollOptionModel.fromJson(Map<String, dynamic> json) {
    return PollOptionModel(
      option: json['option'],
      optionId: json['optionId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'option': option,
      'optionId': optionId,
    };
  }
}
