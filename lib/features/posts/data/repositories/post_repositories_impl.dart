import 'package:dartz/dartz.dart';
import 'package:neighborly_flutter_app/features/posts/data/model/specific_comment_model.dart';
import '../../../../core/entities/post_enitity.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/comment_entity.dart';
import '../../domain/entities/reply_entity.dart';
import '../../domain/repositories/post_repositories.dart';
import '../data_sources/post_remote_data_source/post_remote_data_source.dart';

class PostRepositoriesImpl implements PostRepositories {
  final PostRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  PostRepositoriesImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  // GET ALL POST
  @override
  Future<Either<Failure, List<PostEntity>>> getAllPosts() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getAllPosts();
        return Right(result);
      } on ServerFailure catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  // REPORT POST
  @override
  Future<Either<Failure, void>> reportPost({
    required String reason,
    required String type,
    required String postId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.reportPost(
          reason: reason,
          type: type,
          postId: postId,
        );

        return const Right(null);
      } on ServerFailure catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  // FEEDBACK
  @override
  Future<Either<Failure, void>> feedback({
    required num id,
    required String feedback,
    required String type,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.feedback(
          id: id,
          feedback: feedback,
          type: type,
        );
        return const Right(null);
      } on ServerFailure catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

// GET POST BY ID
  @override
  Future<Either<Failure, PostEntity>> getPostById({required num id}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getPostById(id: id);

        return Right(result);
      } on ServerFailure catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

// GET COMMENT BY ID
  @override
  Future<Either<Failure, SpecificCommentModel>> getCommentById(
      {required String id}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getCommentById(id: id);

        return Right(result);
      } on ServerFailure catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

// GET COMMENT BY POST ID
  @override
  Future<Either<Failure, List<CommentEntity>>> getCommentsByPostId({
    required num postId,
    required String commentId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getCommentsByPostId(
          postId: postId,
          commentId: commentId,
        );

        return Right(result);
      } on ServerFailure catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

// DELETE POST OR POLL
  @override
  Future<Either<Failure, void>> deletePost({
    required num id,
    required String type,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deletePost(id: id, type: type);
        return const Right(null);
      } on ServerFailure catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

// ADD COMMENT
  @override
  Future<Either<Failure, void>> addComment({
    required num postId,
    required String text,
    num? commentId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.addComment(
          postId: postId,
          text: text,
          commentId: commentId,
        );
        return const Right(null);
      } on ServerFailure catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

// VOTE POLL
  @override
  Future<Either<Failure, void>> votePoll({
    required num pollId,
    required num optionId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.votePoll(
          pollId: pollId,
          optionId: optionId,
        );
        return const Right(null);
      } on ServerFailure catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

// FEATCH REPLY ON A COMMENT
  @override
  Future<Either<Failure, List<ReplyEntity>>> fetchCommentReply({
    required num commentId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.fetchCommentReply(
          commentId: commentId,
        );

        return Right(result);
      } on ServerFailure catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

// GIVE AWARDS
  @override
  Future<Either<Failure, void>> giveAward({
    required num id,
    required String awardType,
    required String type,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.giveAward(
          id: id,
          awardType: awardType,
          type: type,
        );
        return const Right(null);
      } on ServerFailure catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }
}
