import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_it/share_it.dart';

import '../../../../core/theme/colors.dart';
import '../../data/model/event_model.dart';
import '../widgets/event_card_widget.dart';

class EventSuccessSuccessScreen extends StatelessWidget {
  final EventModel event;
  final String type; // create | join
  const EventSuccessSuccessScreen({
    super.key,
    required this.event,
    required this.type,
  });

  String titleSelector() {
    switch (type) {
      case 'join':
        return "You're in";
      case 'create':
        return "Event Created Successfully!";
      default:
        return "...";
    }
  }

  String textSelector() {
    switch (type) {
      case 'join':
        return "You've successfully joined the event. See you soon!";
      case 'create':
        return "Your event is live. Time to make some memories!";
      default:
        return "...";
    }
  }

  String imageSelector() {
    switch (type) {
      case 'join':
        return 'assets/join_sucess2.svg';
      case 'create':
        return 'assets/join_sucess2.svg';
      default:
        return "...";
    }
  }

  String formatDate(String dateStr) {
    try {
      DateFormat format = DateFormat("yyyy-MM-dd HH:MM"); //  HH:mm:ss
      DateFormat dateFormat = DateFormat("MMMM d, yyyy 'at' hh:mm a");
      DateTime dateTime = format.parse(dateStr);

      return dateFormat.format(dateTime);
    } catch (e) {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Success'),
      // ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //
            //
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      imageSelector(),
                      width: MediaQuery.of(context).size.width *
                          (type == 'join' ? 0.50 : 0.35),
                      // height: 84,
                    ),
                    const SizedBox(height: 20),
                    //
                    //
                    Text(
                      titleSelector(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 10),
                    //
                    //
                    Text(
                      textSelector(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                    //
                    //
                    if (type == 'create') ...[
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: EventCardWidget(
                          event: event,
                          width: double.infinity,
                          onSelect: (value) {},
                        ),
                      ),
                    ],
                    //
                    //
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            //
            //

            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20, 0, 20, 5),
              child: ElevatedButton(
                onPressed: () async {
                  String message = '''
                  Hey, check this event:   ${event.title}
                  ${formatDate(event.dateStart)} at  ${event.locationStr}
                  ''';
                  // Lógica ao clicar no botão
                  // context.go('/groups/create');
                  ShareIt.text(
                      content: message, androidSheetTitle: 'Look this event');

                  // print('shareResult: ${shareResult}');
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          50), // Ajuste o raio conforme necessário
                    ),
                    padding: EdgeInsets.all(15)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Share with Friends',
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            //
            //
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: ElevatedButton(
                onPressed: () {
                  context.go('/home/Home');
                  //  back Home
                  // Navigator.of(context).pop();
                  // if (Navigator.canPop(context)) {
                  //   Navigator.of(context).pop();
                  // }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          50), // Ajuste o raio conforme necessário
                    ),
                    padding: EdgeInsets.all(15)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Back to home',
                    style: TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
