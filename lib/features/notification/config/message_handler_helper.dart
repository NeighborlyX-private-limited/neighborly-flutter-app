import '../../../core/routes/routes.dart';

class MessageHandlerHelper {
  Map<String, dynamic> messageData;
  MessageHandlerHelper({
    required this.messageData,
  });

  void doTheJump() {
    print('...MessageHandlerHelper start with');
    print('messageData:$messageData');
    print('messageData userId: ${messageData["userId"]}');

    if (messageData['userId'] != null) {
      router.push('/userProfileScreen/${messageData['userId']}');
    }

    if (messageData['postId'] != null) {
      router.push(
          '/post-detail/${messageData['postId']}/true/${messageData['userId']}/0');
    }

    if (messageData['groupId'] != null) {
      router.push('/groups/${messageData['groupId']}');
    }

    if (messageData['messageId'] != null) {
      router.push('/chat/group/thread/${messageData['messageId']}');
    }

    if (messageData['eventId'] != null) {
      router.push('/events/detail/${messageData['eventId']}');
    }

    /*
    Testing: 
    userId: 669bfe2c8486500123a10754
    groupId: 668164e760dbe07a2fd9df5b
    eventId: 668164e760dbe07a2fd9df5b
    messageId: 668164e760dbe07a2fd9df5b
    postId: 163
      */
  }
}
