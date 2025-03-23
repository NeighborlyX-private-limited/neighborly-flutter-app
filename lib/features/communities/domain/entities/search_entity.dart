class SearchEntity {
  final List<PostEntity> globalSearchData;
  final List<PostEntity> localSearchData;

  SearchEntity({
    required this.globalSearchData,
    required this.localSearchData,
  });
}

class PostEntity {
  final int contentId;
  final String userId;
  final String username;
  final String title;
  final String body;
  final List<String> multimedia;
  final DateTime createdAt;
  final int cheers;
  final int boos;
  final String postLocation;
  final String city;
  final String type;
  final List<PollOptionEntity>? pollOptions;
  final bool allowMultipleVotes;
  final String? thumbnail;
  final bool quarantined;

  PostEntity({
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
}

class PollOptionEntity {
  final String option;
  final int optionId;

  PollOptionEntity({
    required this.option,
    required this.optionId,
  });
}
