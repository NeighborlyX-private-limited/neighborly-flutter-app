import 'package:flutter/material.dart'; 
import 'package:flutter_svg/svg.dart';
import 'package:readmore/readmore.dart';

import '../../../../core/widgets/menu_icon_widget.dart';
import '../../data/model/chat_message_model.dart';

class ChatMessagePinnedWidget extends StatelessWidget {
  final ChatMessageModel message;
  final VoidCallback onClose;
  final Function(ChatMessageModel) onUnpin;
  final bool? isAdmin;
  const ChatMessagePinnedWidget({
    Key? key,
    required this.message,
    required this.onClose,
    required this.onUnpin,
    this.isAdmin = false,
  }) : super(key: key);

  void _removeOverlay(OverlayEntry _overlayEntry) {
    _overlayEntry.remove();
    // _overlayEntry = null;
  }

  void _showOverlay(BuildContext context, OverlayEntry? _overlayEntry) {
    print('Showing overlay');

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: () {
          _removeOverlay(_overlayEntry!);
        },
        child: Container(
          color: Colors.black54,
          alignment: Alignment.bottomCenter,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //
                // menu area
                Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      )),
                  child: Column(
                    children: [
                      //
                      //

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 5,
                            width: 40,
                            margin: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(50),
                            ),
                          )
                        ],
                      ),
                      //

                      //
                      //

                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: MenuIconItem(
                            title: 'Remove Pinned Message',
                            svgPath: 'assets/menu_pinned.svg',
                            iconSize: 25,
                            textColor: Colors.black,
                            onTap: () {
                              onUnpin(message);
                              _removeOverlay(_overlayEntry!);
                            }),
                      ),
                      //
                      //
                    ],
                  ),
                ),
                //
                //
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    OverlayEntry? overlayEntry;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: (){
              if(isAdmin == true){
                _showOverlay(  context,   overlayEntry);
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: SvgPicture.asset(
                'assets/pinned.svg',
                height: 30,
                width: 30,
              ),
            ),
          ),
          const SizedBox(width: 22),
          //
          //
          Expanded(
            child: ReadMoreText(
              message.text,
              trimLines: 3,
              // style: TextStyle(fontSize: 14, height: 1.3),
              trimMode: TrimMode.Line,
              trimCollapsedText: ' See more',
              trimExpandedText: ' See less',
              moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.blue),
              lessStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.blue),
            ),
          ),
          const SizedBox(width: 5),
          //
          //
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: GestureDetector(
              onTap: onClose,
              child: Icon(Icons.close),
            ),
          ),
        ],
      ),
    );
  }
}
