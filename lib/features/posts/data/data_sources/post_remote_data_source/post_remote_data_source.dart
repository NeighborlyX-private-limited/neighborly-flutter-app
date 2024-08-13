import 'package:neighborly_flutter_app/features/posts/data/model/comments_model.dart';
import 'package:neighborly_flutter_app/core/models/post_model.dart';
import 'package:neighborly_flutter_app/features/posts/data/model/reply_model.dart';

abstract class PostRemoteDataSource {
  Future<List<PostModel>> getAllPosts({
    required bool isHome,
  });
  Future<PostModel> getPostById({required num id});
  Future<void> deletePost({required num id, required String type});
  Future<void> reportPost(
      {required String reason, required String type, required num postId});
  Future<void> feedback(
      {required num id, required String feedback, required String type});
  Future<void> giveAward(
      {required num id, required String awardType, required String type});
  Future<List<CommentModel>> getCommentsByPostId({required num postId});
  Future<void> addComment(
      {required num postId, required String text, num? commentId});
  Future<void> votePoll({required num pollId, required num optionId});
  Future<List<ReplyModel>> fetchCommentReply({required num commentId});
  // Future<void> replyComment(
  //     {required num commentId, required String text, required num postId});
}
