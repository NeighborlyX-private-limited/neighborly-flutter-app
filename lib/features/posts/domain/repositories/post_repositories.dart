import 'package:dartz/dartz.dart';
import 'package:neighborly_flutter_app/core/error/failures.dart';
import 'package:neighborly_flutter_app/features/posts/domain/entities/post_enitity.dart';

abstract class PostRepositories {
  Future<Either<Failure, List<PostEntity>>> getAllPosts();
  Future<Either<Failure, void>> reportPost(
      {required String reason, required num postId});
  Future<Either<Failure, void>> feedback(
      {required num id, required String feedback, required String type});
}
