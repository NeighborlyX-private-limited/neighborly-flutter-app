import '../../../core/routes/routes.dart';
import '../../../core/utils/shared_preference.dart';

class MessageHandlerHelper {
  Map<String, dynamic> messageData;
  MessageHandlerHelper({
    required this.messageData,
  });
  void doTheJump() {
    String? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      router.go('/');
    }
    print('step 4 with data :$messageData');
    if (messageData['postId'] != null) {
      router.push(
          '/post-detail/${messageData['postId']}/true/${messageData['userId']}/0');
    }

    if (messageData['groupId'] != null) {
      router.push('/groups/${messageData['groupId']}');
    }

    if (messageData['messageId'] != null) {
      router.push('/group-chat-thread/${messageData['messageId']}');
    }

    if (messageData['eventId'] != null) {
      router.push('/events/detail/${messageData['eventId']}');
    }
  }
}
