import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/colors.dart';
import '../../data/model/chat_message_model.dart';

class ChatMessageWidget extends StatefulWidget {
  final ChatMessageModel message;
  final bool? showIsReaded;
  final Function(ChatMessageModel) onTap;

  const ChatMessageWidget({
    Key? key,
    required this.message,
    this.showIsReaded = false,
    required this.onTap,
  }) : super(key: key);

  @override
  State<ChatMessageWidget> createState() => _ChatMessageWidgetState();
}

class _ChatMessageWidgetState extends State<ChatMessageWidget> {
  String formatTime(String lastMessageDate) {
    if (lastMessageDate == '') return lastMessageDate;
    DateTime parsedDate = DateTime.parse(lastMessageDate);

    // Format the date as "YYYY-MM-DD HH:mm:ss"
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(parsedDate);
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    final DateFormat timeFormat = DateFormat('hh:mm a');
    DateTime dateTime = dateFormat.parse(formattedDate);
    return timeFormat.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: widget.message.isMine
          ? MainAxisAlignment.start
          : MainAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.80,
            minWidth: 80,
          ),
          // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          decoration: BoxDecoration(
            color: widget.message.isMine
                ? Colors.grey[100]
                : AppColors.lightBackgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 15, 15, 25),
                child: widget.message.pictureUrl != ''
                    ? Image.network('${widget.message.pictureUrl}')
                    : Text(
                            // message.date,
                            widget.message.text,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
              ),
              //
              Positioned(
                bottom: 3,
                right: 7,
                child: Row(
                  children: [
                    if (widget.showIsReaded == true) ...[
                      SvgPicture.asset('assets/read_mark.svg'),
                      const SizedBox(width: 5),
                    ],
                    Text(
                      formatTime(widget.message.date),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
