import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:neighborly_flutter_app/core/widgets/custom_snackbar.dart';
import 'package:neighborly_flutter_app/core/widgets/indicator/custom_circular_progress_indicator.dart';
import 'package:neighborly_flutter_app/features/chat/data/model/pinned_message_model.dart';
import 'package:neighborly_flutter_app/features/chat/presentation/bloc/featch_pinned_messages_bloc.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/custom_sizedbox.dart';
import '../../../../core/widgets/user_avatar_styled_widget.dart';
import '../bloc/pin_message_bloc.dart';

class GroupPinnedMessagesScreen extends StatefulWidget {
  final String groupId;
  const GroupPinnedMessagesScreen({super.key, required this.groupId});

  @override
  State<GroupPinnedMessagesScreen> createState() =>
      _GroupPinnedMessagesScreenState();
}

class _GroupPinnedMessagesScreenState extends State<GroupPinnedMessagesScreen> {
  List<PinnedMessageModel> pinnedMessages = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<FeatchPinnedMessagesBloc>(context).add(
      FeatchAllPinnedMessagesEvent(groupId: widget.groupId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            BlocListener<FeatchPinnedMessagesBloc, FeatchPinnedMessagesState>(
          listener: (context, state) {
            if (state is FeatchPinnedMessagesSuccessState) {
              pinnedMessages = state.pinnedMessages;
            }
          },
          child: Text(
            '${pinnedMessages.length} Pinned Messages',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<FeatchPinnedMessagesBloc, FeatchPinnedMessagesState>(
        listener: (context, state) {
          if (state is FeatchPinnedMessagesFailureState) {
            showSnackBar(context: context, message: state.error);
          }
          if (state is FeatchPinnedMessagesSuccessState) {
            pinnedMessages = state.pinnedMessages;
          }
        },
        builder: (context, state) {
          if (state is FeatchPinnedMessagesLoadingState) {
            return CustomCircularIndicator();
          }
          if (state is FeatchPinnedMessagesSuccessState) {
            if (state.pinnedMessages.isEmpty) {
              return noPinnedMessage();
            }
            return Column(
              children: [
                Divider(),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    itemCount: pinnedMessages.length,
                    itemBuilder: (context, index) {
                      final pinnedMessage = pinnedMessages[index];
                      final bool isNewDate = index == 0 ||
                          DateUtilsHelper.simplifyISOtimeString(
                                pinnedMessage.sendAt.toString(),
                              ) !=
                              DateUtilsHelper.simplifyISOtimeString(
                                pinnedMessages[index - 1].sendAt.toString(),
                              );

                      // final bool isNewDate = index == 0 ||
                      //     pinnedMessage.sendAt !=
                      //         pinnedMessages[index - 1].sendAt;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isNewDate)
                            Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  DateUtilsHelper.simplifyISOtimeString(
                                    pinnedMessage.sendAt.toString(),
                                  ),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ListTile(
                            onTap: () {
                              showOptionsBottomSheet(
                                context: context,
                                messageId: pinnedMessage.id,
                              );
                            },
                            onLongPress: () {
                              showOptionsBottomSheet(
                                context: context,
                                messageId: pinnedMessage.id,
                              );
                            },
                            leading: CircleAvatar(
                              radius: 20,
                              onBackgroundImageError: (_, __) => SizedBox(),
                              backgroundImage: CachedNetworkImageProvider(
                                  pinnedMessage.userpicture),
                            ),
                            // leading: UserAvatarStyledWidget(
                            //   avatarUrl: pinnedMessage.userpicture,
                            // ),
                            title: Row(
                              children: [
                                Text(
                                  pinnedMessage.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  DateUtilsHelper.simplifyISOtimeStringOnlyHour(
                                    pinnedMessage.sendAt.toString(),
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
                            subtitle: Text(pinnedMessage.message),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return SizedBox();
        },
      ),
    );
  }

  Widget noPinnedMessage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/no-request-pending-image.svg',
            // 'assets/private-lock-icon.svg',
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

  void showOptionsBottomSheet({
    required BuildContext context,
    required String messageId,
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
              // unPinned Messages Option
              BlocListener<PinMessageBloc, PinMessagesState>(
                listener: (context, state) {
                  if (state is PinMessagesStateFailureState) {
                    showSnackBar(context: context, message: state.error);
                  }
                  if (state is PinMessagesStateSuccessState) {
                    BlocProvider.of<FeatchPinnedMessagesBloc>(context).add(
                      FeatchAllPinnedMessagesEvent(groupId: widget.groupId),
                    );
                  }
                },
                child: ListTile(
                  leading: SvgPicture.asset('assets/unpinned.svg'),
                  title:
                      Text('UnPinned Message', style: TextStyle(fontSize: 16)),
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
