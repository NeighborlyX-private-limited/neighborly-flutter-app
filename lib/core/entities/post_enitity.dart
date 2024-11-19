import 'package:equatable/equatable.dart';

import 'option_entity.dart';

class PostEntity extends Equatable {
  final num id;
  final String userId;
  final String userName;
  final String? title;
  final String? content;
  final List<String>? multimedia;
  final String? thumbnail;
  final String createdAt;
  final num cheers;
  final num bools;
  final String? proPic;
  final String city;
  final num? commentCount;
  final String type;
  final List<dynamic> awardType;
  final List<OptionEntity>? pollOptions;
  final bool? allowMultipleVotes;
  final String userFeedback;

  const PostEntity({
    required this.city,
    required this.awardType,
    required this.pollOptions,
    required this.type,
    this.allowMultipleVotes,
    required this.id,
    required this.userId,
    required this.userName,
    required this.commentCount,
    this.title,
    this.content,
    required this.createdAt,
    required this.cheers,
    required this.bools,
    this.proPic,
    this.multimedia,
    this.thumbnail,
    required this.userFeedback,
  });

  PostEntity copyWith({
    num? id,
    String? userId,
    String? userName,
    String? title,
    String? content,
    String? thumbnail,
    List<String>? multimedia,
    String? createdAt,
    num? cheers,
    num? bools,
    String? proPic,
    String? city,
    num? commentCount,
    String? type,
    List<dynamic>? awardType,
    List<OptionEntity>? pollOptions,
    bool? allowMultipleVotes,
    String? userFeedback,
  }) {
    return PostEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      title: title ?? this.title,
      content: content ?? this.content,
      thumbnail: thumbnail ?? this.thumbnail,
      multimedia: multimedia ?? this.multimedia,
      createdAt: createdAt ?? this.createdAt,
      cheers: cheers ?? this.cheers,
      bools: bools ?? this.bools,
      proPic: proPic ?? this.proPic,
      city: city ?? this.city,
      commentCount: commentCount ?? this.commentCount,
      type: type ?? this.type,
      awardType: awardType ?? this.awardType,
      pollOptions: pollOptions ?? this.pollOptions,
      allowMultipleVotes: allowMultipleVotes ?? this.allowMultipleVotes,
      userFeedback: userFeedback ?? this.userFeedback,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        userName,
        pollOptions,
        commentCount,
        awardType,
        type,
        title,
        content,
        createdAt,
        cheers,
        city,
        proPic,
        allowMultipleVotes,
        bools,
        multimedia,
        userFeedback,
        thumbnail,
      ];
}
