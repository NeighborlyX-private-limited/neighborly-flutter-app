import 'package:flutter/material.dart';
import 'package:neighborly_flutter_app/core/theme/text_style.dart';
import 'package:neighborly_flutter_app/features/upload_post/presentation/widgets/post_button_widget.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 14.0, left: 14.0, right: 14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        child: const Icon(
                          Icons.close,
                          size: 20,
                        ),
                        onTap: () {
                          // context.pop();
                        },
                      ),
                      const PostButtonWidget(),
                    ],
                  ),
                ),
                const Expanded(
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: 14.0, left: 14.0, right: 14.0),
                    child: Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'What\'s on your mind?',
                          border: InputBorder.none,
                          // contentPadding: EdgeInsets.symmetric(
                          //     vertical: 10,
                          //     horizontal:
                          //         10), // Optional: Adds padding inside the TextField
                        ),
                        keyboardType: TextInputType
                            .multiline, // Allows for multiline input
                        maxLines:
                            null, // Allows the TextField to expand vertically
                        minLines:
                            1, // Sets the minimum number of lines to display
                        expands:
                            false, // Expands the TextField vertically to fill the parent container
                      ),
                    ),
                  ),
                ),
              ],
            ),
            bottomSheet: Container(
              color: Colors.white,
              height: 200,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Image.asset('assets/add_a_photo.png'),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Add a Photo or GIF',
                        style: mediumTextStyleBlack,
                      ),
                    ],
                  ),
                  // Row(
                  //   children: [
                  //     Image.asset('assets/add_location.png'),
                  //     const SizedBox(
                  //       width: 10,
                  //     ),
                  //     Text(
                  //       'Add Location',
                  //       style: mediumTextStyleBlack,
                  //     ),
                  //   ],
                  // ),
                  Row(
                    children: [
                      Image.asset('assets/create_an_event.png'),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Create an Event',
                        style: mediumTextStyleBlack,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset('assets/create_a_poll.png'),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Create a Poll',
                        style: mediumTextStyleBlack,
                      ),
                    ],
                  ),
                ],
              ),
            )));
  }

  // Future<dynamic> bottomSheet(BuildContext context) {
  //   return showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return
  //     },
  //   );
  // }
}
