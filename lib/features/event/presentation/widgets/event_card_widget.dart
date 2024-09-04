import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../data/model/event_model.dart';

class EventCardWidget extends StatelessWidget {
  final EventModel event;
  final double width;
  final Function(EventModel) onSelect;
  const EventCardWidget({
    Key? key,
    required this.event,
    required this.width,
    required this.onSelect,
  }) : super(key: key);

  void openCommunity(BuildContext context) {
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (BuildContext context) {
    //       return CommunityDetailsScreen(
    //         event: this.event,
    //       );
    //     },
    //   ),
    // );

    context.push('/events/detail/${event.id}', extra: event);
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
    return GestureDetector(
      onTap: () {
        openCommunity(context);
      },
      child: SizedBox(
        height: 300,
        child: Card(
          elevation: 0,
          child: Container(
            width: width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 190,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(event.avatarUrl),
                    ),
                  ),
                ),
                // Text('More here'),
                //
                //
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          formatDate(event.dateStart),
                          // 'March 14, 2023 at 7:00 AM',
                          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        //
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                event.title,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        //
                        Row(
                          children: [
                            SvgPicture.asset('assets/icon_location.svg', height: 16,),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                               event.locationStr,
                              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
         
              ],
            ),
          ),
        ),
      ),
    );
  }
}
