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

  @override
  Future<Either<Failure, List<PostEntity>>> getAllPosts({
    required bool isHome,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getAllPosts(
          isHome: isHome,
        );
        print('result in getAllPosts PostRepositoriesImpl: $result');

        return Right(result);
      } on ServerFailure catch (e) {
        print(
            'Server Failure in getAllPosts PostRepositoriesImpl: ${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch in getAllPosts PostRepositoriesImpl: $e');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      print('No Internet Connection in getAllPosts PostRepositoriesImpl');
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> reportPost({
    required String reason,
    required String type,
    required num postId,
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
        print(
            'Server Failure in reportPost PostRepositoriesImpl: ${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch in reportPost PostRepositoriesImpl: $e');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      print('No Internet Connection in reportPost PostRepositoriesImpl');
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

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
        print('Server Failure in feedback PostRepositoriesImpl: ${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch in feedback PostRepositoriesImpl: $e');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      print('No Internet Connection in feedback PostRepositoriesImpl');
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, PostEntity>> getPostById({required num id}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getPostById(id: id);
        print('result in getPostById PostRepositoriesImpl: $result');
        return Right(result);
      } on ServerFailure catch (e) {
        print(
            'Server Failure in getPostById PostRepositoriesImpl: ${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch in getPostById PostRepositoriesImpl: $e');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      print('No Internet Connection in getPostById PostRepositoriesImpl');
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, SpecificCommentModel>> getCommentById(
      {required String id}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getCommentById(id: id);
        print('result in getCommentById PostRepositoriesImpl: $result');
        return Right(result);
      } on ServerFailure catch (e) {
        print(
            'Server Failure in getCommentById PostRepositoriesImpl: ${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch in getCommentById PostRepositoriesImpl: $e');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      print('No Internet Connection in getCommentById PostRepositoriesImpl');
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<CommentEntity>>> getCommentsByPostId(
      {required num postId, required String commentId}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getCommentsByPostId(
          postId: postId,
          commentId: commentId,
        );
        print('result in getCommentsByPostId PostRepositoriesImpl: $result');
        return Right(result);
      } on ServerFailure catch (e) {
        print(
            'Server Failure in getCommentsByPostId PostRepositoriesImpl: ${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch in getCommentsByPostId PostRepositoriesImpl: $e');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      print(
          'No Internet Connection in getCommentsByPostId PostRepositoriesImpl');
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deletePost(
      {required num id, required String type}) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deletePost(id: id, type: type);
        return const Right(null);
      } on ServerFailure catch (e) {
        print(
            'Server Failure in deletePost PostRepositoriesImpl: ${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch in deletePost PostRepositoriesImpl: $e');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      print('No Internet Connection in deletePost PostRepositoriesImpl');
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> addComment(
      {required num postId, required String text, num? commentId}) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.addComment(
          postId: postId,
          text: text,
          commentId: commentId,
        );
        return const Right(null);
      } on ServerFailure catch (e) {
        print(
            'Server Failure in addComment PostRepositoriesImpl: ${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch in addComment PostRepositoriesImpl: $e');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      print('No Internet Connection in addComment PostRepositoriesImpl');
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> votePoll(
      {required num pollId, required num optionId}) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.votePoll(
          pollId: pollId,
          optionId: optionId,
        );
        return const Right(null);
      } on ServerFailure catch (e) {
        print('Server Failure in votePoll PostRepositoriesImpl: ${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch in votePoll PostRepositoriesImpl: $e');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      print('No Internet Connection in votePoll PostRepositoriesImpl');
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<ReplyEntity>>> fetchCommentReply(
      {required num commentId}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.fetchCommentReply(
          commentId: commentId,
        );
        print('result in fetchCommentReply PostRepositoriesImpl: $result');
        return Right(result);
      } on ServerFailure catch (e) {
        print(
            'Server Failure in fetchCommentReply PostRepositoriesImpl: ${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch in fetchCommentReply PostRepositoriesImpl: $e');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      print('No Internet Connection in fetchCommentReply PostRepositoriesImpl');
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> giveAward(
      {required num id,
      required String awardType,
      required String type}) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.giveAward(
          id: id,
          awardType: awardType,
          type: type,
        );
        return const Right(null);
      } on ServerFailure catch (e) {
        print('Server Failure in giveAward PostRepositoriesImpl: ${e.message}');
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        print('catch in giveAward PostRepositoriesImpl: $e');
        return Left(ServerFailure(message: '$e'));
      }
    } else {
      print('No Internet Connection in giveAward PostRepositoriesImpl');
      return const Left(ServerFailure(message: 'No internet connection'));
    }
  }

  // @override
  // Future<Either<Failure, void>> replyComment(
  //     {required num commentId,
  //     required String text,
  //     required num postId}) async {
  //   if (await networkInfo.isConnected) {
  //     try {
  //       await remoteDataSource.replyComment(
  //           commentId: commentId, text: text, postId: postId);
  //       return const Right(null);
  //     } on ServerFailure catch (e) {
  //       return Left(ServerFailure(message: e.message));
  //     } catch (e) {
  //       return Left(ServerFailure(message: '$e'));
  //     }
  //   } else {
  //     return const Left(ServerFailure(message: 'No internet connection'));
  //   }
  // }
}
