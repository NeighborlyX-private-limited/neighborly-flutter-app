import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:readmore/readmore.dart';

import '../../../../core/constants/status.dart';
import '../../../../core/models/user_simple_model.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/appbat_button.dart';
import '../../../../core/widgets/user_avatar_styled_widget.dart';
import '../../../chat/data/model/chat_room_model.dart';
import '../../data/model/event_model.dart';
import '../bloc/event_detail_cubit.dart';

class EventDetailScreen extends StatefulWidget {
  final String eventId;
  final EventModel? event;

  const EventDetailScreen({
    Key? key,
    required this.eventId,
    this.event,
  }) : super(key: key);

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  late EventDetailCubit eventDetailCubit;
  int currentStep = 1;
  File? fileToUpload;

  @override
  void initState() {
    super.initState();

    eventDetailCubit = BlocProvider.of<EventDetailCubit>(context);
    eventDetailCubit.init(widget.eventId, widget.event!);

    currentStep = 1;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget topElement(String? avatarUrl) {
    if (avatarUrl == null || avatarUrl == '') {
      return Text('LOADING?');
    }
    return Container(
      height: MediaQuery.of(context).size.height * 0.30,
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: CachedNetworkImageProvider(avatarUrl),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Container(
          margin: EdgeInsets.all(9.0),
          height: 40,
          width: 40,
          child: AppbatButton(
            onTap: () {
              Navigator.pop(context);
            },
            // icon: LineIcons.angleLeft,
            icon: Icons.chevron_left_rounded,
            iconSize: 30,
          ),
        ),
        backgroundColor: Colors.transparent,
        // title: const Text('community create'),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppbatButton(
                onTap: () {
                  // TODO: remove this, only for presentation/test porpouse
                  // context.push('/groups/admin', extra: communityCache);
                  print('...TAP menu SHARE');
                },
                icon: Icons.share,
                iconSize: 20,
              ),
              const SizedBox(width: 10),
              AppbatButton(
                onTap: () {
                  print('...TAP menu settings');

                  // if (isAdmin) {
                  //   context.push('/groups/admin', extra: communityCache);
                  // } else {
                  //   if (isJoined) {
                  //     bottomSheetMenu(context, '', communityCache?.name ?? '', communityCache?.isMuted ?? false);
                  //   }
                  // }
                },
                // icon: LineIcons.verticalEllipsis,
                icon: Icons.more_vert_outlined,
                iconSize: 25,
              ),
              const SizedBox(width: 10),
            ],
          )
        ],
      ),
      body: BlocConsumer<EventDetailCubit, EventDetailState>(
        listener: (context, state) {
          // print('... state.currentUser: ${state.status}');

          if (state.eventDetails != null) {
            // var localEvent = state.eventDetails!;
            print('\n\n\n... EVENT name=${state.eventDetails!.title}');
            print('... EVENT isMine=${state.eventDetails!.isMine}');
            print('... EVENT name=${state.eventDetails!.isJoined}');
          }

          switch (state.status) {
            case Status.loading:
              break;
            case Status.failure:
              // hideLoader();
              // showError(state.errorMessage ?? 'Some error');
              print('ERROR ${state.failure?.message}');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text('Something went wrong! ${state.failure?.message}'),
                ),
              );
              break;
            case Status.success:
              if (state.successMessage == 'Event joined') {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.successMessage ?? ''),
                  ),
                );
              }

              if (state.successMessage == 'Event canceled') {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.successMessage ?? ''),
                  ),
                );
                Navigator.of(context).pop();
              }

              break;
            case Status.initial:
              break;
          }
        },
        builder: (context, state) {
          //
          //
          return BlocBuilder<EventDetailCubit, EventDetailState>(
            bloc: eventDetailCubit,
            builder: (context, state) {
              // if (state.status == Status.loading) {
              //   // return const EventMainSheemer();
              //   return Text('loading');
              // }

              print('...state.event:${state}');
              return Container(
                // padding: EdgeInsets.only(top: 15),
                width: double.infinity,
                color: Colors.white,
                child: state.eventDetails == null
                    ? Center(
                        child: Text('LOAD THIS'),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //
                            //
                            //
                            //
                            topElement(state.eventDetails?.avatarUrl),
                            //
                            TitleArea(
                              title: state.eventDetails!.title,
                              locationStr: state.eventDetails!.locationStr,
                            ),
                            //
                            //
                            DateArea(
                              dateStart: DateUtilsHelper.simplifyISOtimeString(
                                  state.eventDetails!
                                      .dateStart), // 'March 14, 2023', //
                              dateEnd: DateUtilsHelper.simplifyISOtimeString(
                                  state.eventDetails!.dateEnd),
                              hourStart:
                                  DateUtilsHelper.simplifyISOtimeStringOnlyHour(
                                      state.eventDetails!
                                          .dateStart), // '07:00 AM',
                              hourEnd:
                                  DateUtilsHelper.simplifyISOtimeStringOnlyHour(
                                      state
                                          .eventDetails!.dateEnd), //'09:00 AM',
                            ),
                            //
                            //
                            ChatArea(event: state.eventDetails!),

                            //
                            //
                            AboutArea(
                                description: state.eventDetails!.description),
                            //
                            //
                            Divider(
                                thickness: 10,
                                color: AppColors.lightBackgroundColor),
                            LocationDetailArea(
                              locationStr: state.eventDetails!.locationStr,
                              address: state.eventDetails!.address,
                            ),
                            //
                            //
                            if (state.eventDetails!.isMine == false) ...[
                              Divider(
                                  thickness: 10,
                                  color: AppColors.lightBackgroundColor),
                              HostArea(
                                host: state.eventDetails!.host,
                              ),
                            ],
                            //
                            //
                            Divider(
                                thickness: 10,
                                color: AppColors.lightBackgroundColor),

                            if (state.eventDetails!.isMine == true)
                              AuthorArea(onCancel: () {
                                print(' ON CANCEL pressed');
                                eventDetailCubit.cancelEvent('reason');
                              }, onEdit: () {
                                print(' ON EDIT pressed'); // XXXr
                                Navigator.of(context).pop();
                                context.push('/events/edit',
                                    extra: state.eventDetails);
                              }),
                            //
                            //
                            if (state.eventDetails!.isMine == false &&
                                state.eventDetails!.isJoined == false)
                              JoinArea(
                                onJoin: () {
                                  // XXX
                                  print('JOINED IN ${state.eventDetails}');
                                  // eventDetailCubit.onPressJoin();
                                  context.push('/events/join',
                                      extra: state.eventDetails);
                                },
                                isLoading: state.status == Status.loading,
                              ),
                            //
                            //
                          ],
                        ),
                      ),
              );
            },
          );
        },
      ),
    );
  }
}

// #####################################################
// #####################################################
// #####################################################

class TitleArea extends StatelessWidget {
  final String title;
  final String locationStr;

  const TitleArea({
    Key? key,
    required this.title,
    required this.locationStr,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              SvgPicture.asset(
                'assets/icon_location.svg',
                height: 24,
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                locationStr,
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const SizedBox(height: 2),
          //
          Divider(color: Colors.grey[300])
        ],
      ),
    );
  }
}

// #####################################################
// #####################################################
// #####################################################

class DateArea extends StatelessWidget {
  final String dateStart;
  final String dateEnd;
  final String hourStart;
  final String hourEnd;

  const DateArea({
    Key? key,
    required this.dateStart,
    required this.dateEnd,
    required this.hourStart,
    required this.hourEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: SvgPicture.asset(
              'assets/calendar_icon.svg',
              height: 20,
            ),
          ),
          const SizedBox(
            width: 18,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '${dateStart} - ${dateEnd}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                '${hourStart} - ${hourEnd}',
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              //
              Divider(color: Colors.grey[300])
            ],
          ),
        ],
      ),
    );
  }
}

// #####################################################
// #####################################################
// #####################################################

class ChatArea extends StatelessWidget {
  final EventModel event;
  final bool? allowTap;

  const ChatArea({
    Key? key,
    required this.event,
    this.allowTap = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: allowTap == false
          ? null
          : () {
              context.push(
                '/chat/group/${event.id}',
                extra: ChatRoomModel(
                    id: event.id,
                    name: event.title,
                    avatarUrl: event.avatarUrl,
                    lastMessage: '',
                    lastMessageDate: '',
                    isMuted: false,
                    isGroup: true,
                    unreadCount: 0),
              );
            },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: SvgPicture.asset(
                'assets/chat_event_icon.svg',
                height: 23,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Event chat',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Keep connected with others people',
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  //
                  Divider(color: Colors.grey[300])
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}

// #####################################################
// #####################################################
// #####################################################

class AboutArea extends StatelessWidget {
  final String description;

  const AboutArea({
    Key? key,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About this event',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ReadMoreText(
            description,
            trimLines: 3,
            style: TextStyle(fontSize: 16, height: 1.3),
            trimMode: TrimMode.Line,
            trimCollapsedText: ' See more',
            trimExpandedText: ' See less',
            moreStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.blue),
            lessStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.blue),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

// #####################################################
// #####################################################
// #####################################################

class LocationDetailArea extends StatelessWidget {
  final String locationStr;
  final String address;

  const LocationDetailArea({
    Key? key,
    required this.locationStr,
    required this.address,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Location',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: SvgPicture.asset(
                  'assets/icon_location.svg',
                  height: 25,
                ),
              ),
              const SizedBox(
                width: 18,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      locationStr,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      address,
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 16),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    //
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// #####################################################
// #####################################################
// #####################################################

class JoinArea extends StatefulWidget {
  final VoidCallback onJoin;
  final bool isLoading;

  const JoinArea({
    Key? key,
    required this.onJoin,
    required this.isLoading,
  }) : super(key: key);

  @override
  State<JoinArea> createState() => _JoinAreaState();
}

class _JoinAreaState extends State<JoinArea> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox(
                  value: _isChecked,
                  onChanged: (value) {
                    setState(() {
                      _isChecked = value!;
                    });
                  }),
              const SizedBox(
                width: 6,
              ),
              Expanded(
                child: Text(
                    'Neighborly is not responsible for any events and it is up to user’s discretion to look for their safety.',
                    style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          //
          //

          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // #message
                if (widget.isLoading) return;

                widget.onJoin();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _isChecked ? AppColors.primaryColor : Colors.grey[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      50), // Ajuste o raio conforme necessário
                ),
                // padding: EdgeInsets.all(15)
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 1,
                    vertical: widget.isLoading == true ? 17 : 25),
                child: widget.isLoading == true
                    ? SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'Join',
                        style: TextStyle(
                            color: _isChecked ? Colors.white : Colors.grey,
                            fontSize: 18,
                            height: 0.3),
                      ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

// #####################################################
// #####################################################
// #####################################################

class HostArea extends StatelessWidget {
  final UserSimpleModel host;

  const HostArea({
    Key? key,
    required this.host,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Host',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UserAvatarStyledWidget(
                avatarUrl: host.avatarUrl,
                avatarBorderSize: 0,
                avatarSize: 25,
              ),
              const SizedBox(
                width: 18,
              ),
              Expanded(
                child: Text(
                  host.name,
                  maxLines: 2,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // #message

                  context.push(
                    '/chat/group/${host.id}',
                    extra: ChatRoomModel(
                        id: host.id,
                        name: host.name,
                        avatarUrl: host.avatarUrl,
                        lastMessage: '',
                        lastMessageDate: '',
                        isMuted: false,
                        isGroup: false,
                        unreadCount: 0),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        50), // Ajuste o raio conforme necessário
                  ),
                  // padding: EdgeInsets.all(15)
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1),
                  child: Text(
                    'Message',
                    style: TextStyle(
                        color: Colors.black, fontSize: 18, height: 0.3),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

// #####################################################
// #####################################################
// #####################################################

class AuthorArea extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onEdit;

  const AuthorArea({
    Key? key,
    required this.onCancel,
    required this.onEdit,
  }) : super(key: key);

  Future<dynamic> bottomSheetConfirmCancelEvent(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        // String? userId = ShardPrefHelper.getUserID();
        return Container(
          color: Colors.white,
          height: 120,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Are you sure whant to cancel the event?',
                style: TextStyle(fontSize: 16),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              50), // Ajuste o raio conforme necessário
                        ),
                        // padding: EdgeInsets.all(15)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                              color: Colors.black, fontSize: 18, height: 0.3),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    flex: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        onCancel();
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              50), // Ajuste o raio conforme necessário
                        ),
                        // padding: EdgeInsets.all(15)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Yes',
                          style: TextStyle(
                              color: Colors.white, fontSize: 18, height: 0.3),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // #message

                bottomSheetConfirmCancelEvent(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      50), // Ajuste o raio conforme necessário
                ),
                // padding: EdgeInsets.all(15)
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 1, vertical: 20),
                child: Text(
                  'Cancel Event',
                  style:
                      TextStyle(color: Colors.black, fontSize: 18, height: 0.3),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),

          //
          //

          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // #message
                onEdit();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      50), // Ajuste o raio conforme necessário
                ),
                // padding: EdgeInsets.all(15)
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 1, vertical: 20),
                child: Text(
                  'Edit Event',
                  style:
                      TextStyle(color: Colors.white, fontSize: 18, height: 0.3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
