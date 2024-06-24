import 'package:neighborly_flutter_app/features/posts/data/model/comments_model.dart';
import 'package:neighborly_flutter_app/features/posts/data/model/post_model.dart';

abstract class PostRemoteDataSource {
  Future<List<PostModel>> getAllPosts();
  Future<PostModel> getPostById({required num id});
  Future<void> deletePost({required num id});
  Future<void> reportPost(
      {required String reason, required String type, required num postId});
  Future<void> feedback(
      {required num id, required String feedback, required String type});
  Future<List<CommentModel>> getCommentsByPostId({required num postId});
  Future<void> addComment({required num postId, required String text});
  Future<void> votePoll({required num pollId, required num optionId});
}
