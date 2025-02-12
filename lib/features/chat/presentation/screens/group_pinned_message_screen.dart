import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/svg.dart';
import 'package:neighborly_flutter_app/core/widgets/custom_snackbar.dart';
import 'package:neighborly_flutter_app/core/widgets/indicator/custom_circular_progress_indicator.dart';
import 'package:neighborly_flutter_app/features/chat/data/model/pinned_message_model.dart';
import 'package:neighborly_flutter_app/features/chat/presentation/bloc/featch_pinned_messages_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/widgets/custom_sizedbox.dart';
import '../bloc/pin_message_bloc.dart';

class GroupPinnedMessagesScreen extends StatefulWidget {
  final String groupId;
  final bool isAdmin;
  const GroupPinnedMessagesScreen({
    super.key,
    required this.groupId,
    required this.isAdmin,
  });

  @override
  State<GroupPinnedMessagesScreen> createState() =>
      _GroupPinnedMessagesScreenState();
}

class _GroupPinnedMessagesScreenState extends State<GroupPinnedMessagesScreen> {
  // INIT STATE
  @override
  void initState() {
    super.initState();
    BlocProvider.of<FeatchPinnedMessagesBloc>(context).add(
      FeatchAllPinnedMessagesEvent(groupId: widget.groupId),
    );
  }

// REFRESH CALL
  Future<void> _onRefresh() async {
    BlocProvider.of<FeatchPinnedMessagesBloc>(context).add(
      FeatchAllPinnedMessagesEvent(groupId: widget.groupId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FeatchPinnedMessagesBloc, FeatchPinnedMessagesState>(
      listener: (context, state) {
        // FAILURE STATE
        if (state is FeatchPinnedMessagesFailureState) {
          showSnackBar(
            context: context,
            message: state.error,
          );
        }
      },
      builder: (context, state) {
        // LOADING STATE
        if (state is FeatchPinnedMessagesLoadingState) {
          return Scaffold(
            appBar: AppBar(),
            body: Column(
              children: [
                CustomCircularIndicator(),
              ],
            ),
          );
        }
        // SUCCESS STATE AND 0 PINNED MESSAGE
        if (state is FeatchPinnedMessagesSuccessState &&
            state.pinnedMessages.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                '0 Pinned Messages',
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
            body: noPinnedMessage(),
          );
        }
        // SUCCESS STATE WITH PINNED MESSAGES
        if (state is FeatchPinnedMessagesSuccessState) {
          return Scaffold(
              appBar: AppBar(
                title: Text(
                  '${state.pinnedMessages.length} Pinned Messages',
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
              body: RefreshIndicator(
                onRefresh: _onRefresh,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        itemCount: state.pinnedMessages.length,
                        itemBuilder: (context, index) {
                          final List<PinnedMessageModel> pinnedMessage =
                              state.pinnedMessages;
                          final bool isNewDate = index == 0 ||
                              DateUtilsHelper.simplifyISOtimeString(
                                    pinnedMessage[index].sendAt.toString(),
                                  ) !=
                                  DateUtilsHelper.simplifyISOtimeString(
                                    pinnedMessage[index - 1].sendAt.toString(),
                                  );

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (isNewDate)
                                Center(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Text(
                                      '${formatTimeDifference(
                                        pinnedMessage[index].sendAt.toString(),
                                      )} Ago',
                                      // convertToIndianTime(
                                      //   pinnedMessage[index].sendAt.toString(),
                                      // ),
                                      // DateUtilsHelper.simplifyISOtimeString(
                                      //   pinnedMessage[index].sendAt.toString(),
                                      // ),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ListTile(
                                onTap: () {
                                  if (widget.isAdmin) {
                                    showOptionsBottomSheet(
                                      context: context,
                                      messageId: pinnedMessage[index].id,
                                      onTap: () {
                                        _onRefresh();
                                      },
                                    );
                                  }
                                },
                                onLongPress: () {
                                  if (widget.isAdmin) {
                                    showOptionsBottomSheet(
                                      context: context,
                                      messageId: pinnedMessage[index].id,
                                      onTap: () {
                                        _onRefresh();
                                      },
                                    );
                                  }
                                },
                                leading: CircleAvatar(
                                  radius: 20,
                                  onBackgroundImageError: (_, __) => SizedBox(),
                                  backgroundImage: CachedNetworkImageProvider(
                                    pinnedMessage[index].userpicture,
                                  ),
                                ),
                                title: Row(
                                  children: [
                                    Text(
                                      pinnedMessage[index].name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      DateUtilsHelper
                                          .simplifyISOtimeStringOnlyHour(
                                        pinnedMessage[index].sendAt.toString(),
                                      ),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Icon(
                                      Icons.push_pin,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                                subtitle: Linkify(
                                  options: LinkifyOptions(
                                    looseUrl: true,
                                  ),
                                  onOpen: (link) async {
                                    if (await canLaunchUrl(
                                        Uri.parse(link.url))) {
                                      await launchUrl(Uri.parse(link.url),
                                          mode: LaunchMode.externalApplication);
                                    } else {
                                      throw "Could not launch ${link.url}";
                                    }
                                  },
                                  text: pinnedMessage[index].message,
                                  style: const TextStyle(fontSize: 16),
                                  linkStyle: const TextStyle(
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ));
        }
        return SizedBox();
      },
    );
  }

// EMPTY PINNED MESSAGE
  Widget noPinnedMessage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/no-request-pending-image.svg',
          ),
          CustomSizedBox(
            height: 12,
          ),
          Text(
            'No Pinned Message',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          CustomSizedBox(
            height: 4,
          ),
          Text(
            'You\'re all caught up! New pinned message will appear here.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.center,
            softWrap: true,
          )
        ],
      ),
    );
  }

// UNPIN MESSAGE BOTTOM SHEET
  void showOptionsBottomSheet({
    required BuildContext context,
    required String messageId,
    required VoidCallback onTap,
  }) {
    showModalBottomSheet(
      showDragHandle: true,
      useRootNavigator: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BlocListener<PinMessageBloc, PinMessagesState>(
                listener: (context, state) {
                  if (state is PinMessagesStateFailureState) {
                    showSnackBar(context: context, message: state.error);
                  }
                  if (state is PinMessagesStateSuccessState) {
                    onTap();
                  }
                },
                child: ListTile(
                  leading: SvgPicture.asset('assets/unpinned.svg'),
                  title: Text(
                    'Unpin Message',
                    style: TextStyle(fontSize: 16),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    BlocProvider.of<PinMessageBloc>(context).add(
                      PinnedAMessagesEvent(
                        messageId: messageId,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
