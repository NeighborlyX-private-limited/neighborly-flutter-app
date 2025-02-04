import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/widgets/custom_sizedbox.dart';

import '../../../../core/theme/colors.dart';

class GroupPinnedMessagesScreen extends StatefulWidget {
  final List pineedMessages;
  const GroupPinnedMessagesScreen({super.key, required this.pineedMessages});

  @override
  State<GroupPinnedMessagesScreen> createState() =>
      _GroupPinnedMessagesScreenState();
}

class _GroupPinnedMessagesScreenState extends State<GroupPinnedMessagesScreen> {
  final List pinnedMessages = [
    {
      "username": "Akash2411",
      "time": "05:49 pm",
      "message":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
      "date": "1 June, 2024"
    },
    {
      "username": "JohnDoe",
      "time": "06:15 pm",
      "message":
          "Another pinned message. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.",
      "date": "2 June, 2024"
    },
    {
      "username": "JaneSmith",
      "time": "07:30 pm",
      "message":
          "This is yet another pinned message. Excepteur sint occaecat cupidatat non proident.",
      "date": "2 June, 2024"
    }
  ];

  @override
  void initState() {
    super.initState();
    print('pinned msg: ${widget.pineedMessages}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${pinnedMessages.length} Pinned Messages',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Divider(),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 0),
              itemCount: pinnedMessages.length,
              itemBuilder: (context, index) {
                final message = pinnedMessages[index];
                final bool isNewDate = index == 0 ||
                    message["date"] != pinnedMessages[index - 1]["date"];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isNewDate)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            message["date"],
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ),
                      ),
                    ListTile(
                      onTap: () {
                        //_showBottomSheet(widget.roomId, widget.roomId);
                      },
                      leading: CircleAvatar(

                          //backgroundImage: AssetImage('assets/avatar.png'),
                          ),
                      title: Row(
                        children: [
                          Text(
                            message["username"],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 8),
                          Text(
                            message["time"],
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          SizedBox(width: 5),
                          Icon(Icons.push_pin, size: 16, color: Colors.grey),
                        ],
                      ),
                      subtitle: Text(message["message"]),
                    ),
                  ],
                );
              },
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            child: ElevatedButton(
              onPressed: () {
                // Handle Unpin All Messages
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text('Unpin All Messages'),
            ),
          ),
        ],
      ),
    );
  }

  /// open bag bottom sheet method
  void _showBottomSheet(
    var roomId,
    var messageId,
  ) {
    showModalBottomSheet(
      useRootNavigator: true,
      showDragHandle: true,
      backgroundColor: AppColors.whiteColor,
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          padding: EdgeInsets.symmetric(
              horizontal: 16, vertical: 16), // Add padding for a cleaner look
          child: Wrap(
            children: [
              GestureDetector(
                onTap: () {
                  context.pop();
                  //context.push('/chat/group/pinned-message/$roomId}');
                  print('pinnedMessages: $pinnedMessages');
                },
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/unpinned.svg',
                      height: 20,
                      width: 20,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text('Unpin'),
                  ],
                ),
              ),
              CustomSizedBox(
                height: 20,
              ),
            ],
          ),
        );
      },
    );
  }
}
