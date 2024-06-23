import 'package:dartz/dartz.dart';
import 'package:neighborly_flutter_app/core/error/failures.dart';
import 'package:neighborly_flutter_app/features/posts/domain/entities/comment_entity.dart';
import 'package:neighborly_flutter_app/features/posts/domain/entities/post_enitity.dart';

abstract class PostRepositories {
  Future<Either<Failure, List<PostEntity>>> getAllPosts();
  Future<Either<Failure, PostEntity>> getPostById({
    required num id,
  });
  Future<Either<Failure, void>> deletePost({
    required num id,
  });
  Future<Either<Failure, void>> reportPost(
      {required String reason, required num postId});
  Future<Either<Failure, void>> feedback(
      {required num id, required String feedback, required String type});
  Future<Either<Failure, List<CommentEntity>>> getCommentsByPostId({
    required num postId,
  });
  Future<Either<Failure, void>> addComment({
    required num postId,
    required String text,
  });
}
