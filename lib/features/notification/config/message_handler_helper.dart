import '../../../core/routes/routes.dart';
import '../../../core/utils/shared_preference.dart';
import 'package:go_router/go_router.dart';

class MessageHandlerHelper {
  Map<String, dynamic> messageData;
  MessageHandlerHelper({
    required this.messageData,
  });
  void doTheJump() {
    if (messageData['dmId'] != null) {
      router.push(
        '/chat-private/${messageData['dmId']}',
        extra: {
          'profilePic': messageData['dmUserProfile'] ?? '',
          'userName': messageData['dmUserName'] ?? '',
        },
      );
      return;
    }
    // context.push
    print('message data: $messageData');
    String? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      router.go('/');
    }

    if (messageData['triggerType'] == 'AwardTrigger' &&
        (messageData['postId'] == null || messageData['postId'] == '') &&
        messageData['commentId'] != null) {
      print('awards trigger');

      router
          .push('/post-detail-of-specific-comment/${messageData['commentId']}');
    } else if (messageData['triggerType'] == 'GroupTrigger') {
      router.push('/group-details/${messageData['groupId']}');

      // router.push('/post-detail-of-specific-comment/${notification.commentId}');
    } else if (messageData['triggerType'] == 'MessageTrigger') {
      print('message trigger');

      router.push('/group-chat/${messageData['groupId']}');
    } else if (messageData['triggerType'] == 'PostTrigger' ||
        messageData['triggerType'] == 'CommentTrigger' ||
        messageData['triggerType'] == 'AwardTrigger' ||
        messageData['triggerType'] == 'ReplyTrigger') {
      router.push('/post-detail/${messageData['postId']}');
    } else if (messageData['postId'] != null) {
      print('post,comment,reply trigger ${messageData['triggerType']}');
      router.push('/post-detail/${messageData['postId']}');
      // context.push(
      //     '/post-detail/${notification.postId}/${ispost.toString()}/${notification.userId}/$commentid');
    }
  }
}
