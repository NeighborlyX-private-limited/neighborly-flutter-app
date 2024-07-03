import 'package:dartz/dartz.dart';
import 'package:neighborly_flutter_app/core/error/failures.dart';
import 'package:neighborly_flutter_app/features/posts/domain/entities/comment_entity.dart';
import 'package:neighborly_flutter_app/features/posts/domain/entities/post_enitity.dart';
import 'package:neighborly_flutter_app/features/posts/domain/entities/reply_entity.dart';

abstract class PostRepositories {
  Future<Either<Failure, List<PostEntity>>> getAllPosts({
    required bool isHome,
  });
  Future<Either<Failure, PostEntity>> getPostById({
    required num id,
  });
  Future<Either<Failure, void>> deletePost({
    required num id,
    required String type,
  });
  Future<Either<Failure, void>> reportPost(
      {required String reason, required String type, required num postId});
  Future<Either<Failure, void>> feedback(
      {required num id, required String feedback, required String type});
  Future<Either<Failure, List<CommentEntity>>> getCommentsByPostId({
    required num postId,
  });
  Future<Either<Failure, void>> addComment({
    required num postId,
    required String text,
    num? commentId,
  });
  Future<Either<Failure, void>> votePoll({
    required num pollId,
    required num optionId,
  });
  Future<Either<Failure, void>> giveAward({
    required num id,
    required String awardType,
    required String type,
  });
  // Future<Either<Failure, void>> replyComment({
  //   required num commentId,
  //   required String text,
  //   required num postId,
  // });
  Future<Either<Failure, List<ReplyEntity>>> fetchCommentReply({
    required num commentId,
  });
}
