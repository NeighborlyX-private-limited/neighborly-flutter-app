import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/widgets/custom_snackbar.dart';
import '../../../../core/constants/status.dart';
import '../../../../core/theme/colors.dart';
import '../bloc/chat_main_cubit.dart';
import '../widgets/chat_empty_widget.dart';
import '../widgets/chat_rooms_sheemer.dart';
import '../widgets/chat_search_empty_widget.dart';
import '../widgets/chat_tile_widget.dart';

class ChatMainScreen extends StatefulWidget {
  const ChatMainScreen({super.key});

  @override
  State<ChatMainScreen> createState() => _ChatMainScreenState();
}

class _ChatMainScreenState extends State<ChatMainScreen> {
  late ChatMainCubit chatMainCubit;
  final searchEC = TextEditingController();
  bool showSearch = false;

  // INIT STATE
  @override
  void initState() {
    super.initState();

    chatMainCubit = BlocProvider.of<ChatMainCubit>(context);
    chatMainCubit.init();
  }

// DISPOSE
  @override
  void dispose() {
    super.dispose();
    searchEC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.whiteColor,
        leading: showSearch
            ? null
            : GestureDetector(
                child: Icon(
                  Icons.arrow_back_ios,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
        title: showSearch
            // APP BAR SEARCH BOX
            ? TextFormField(
                controller: searchEC,
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
                textAlignVertical: TextAlignVertical.center,
                onFieldSubmitted: (value) {},
                onChanged: (value) {
                  if (value.length > 2) {
                    chatMainCubit.filterRoomList(value);
                  } else {
                    chatMainCubit.cleanSearchFilter();
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.lightBackgroundColor,
                  hintText: 'Search',
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.6),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  border: OutlineInputBorder(
                    gapPadding: 0,
                    borderSide: BorderSide(
                      width: 1,
                      style: BorderStyle.solid,
                      color: AppColors.greyColor,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    gapPadding: 0,
                    borderSide: BorderSide(
                      width: 1,
                      style: BorderStyle.solid,
                      color: AppColors.greyColor,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                cursorColor: AppColors.greyColor,
              )
            // APP BAR TITLE
            : Text(
                'Chat',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
        centerTitle: true,
        actions: [
          // SEARCH ICON
          GestureDetector(
            onTap: () {
              setState(() {
                showSearch = !showSearch;
                if (!showSearch) {
                  chatMainCubit.cleanSearchFilter();
                }
              });
            },
            child: Icon(
              showSearch ? Icons.close : Icons.search,
              size: 24,
            ),
          ),

          const SizedBox(width: 16),
        ],
      ),
      body: BlocConsumer<ChatMainCubit, ChatMainState>(
        listener: (context, state) {
          // FAILURE STATE
          if (state.status == Status.failure) {
            showSnackBar(
              context: context,
              message: "oops something went wrong",
            );
          }
        },
        builder: (context, state) {
          // LOADING STATE
          if (state.status == Status.loading) {
            return const ChatRoomsSheemer();
          }
          // NO LOADING STATE WITH EMPTY ROOM
          if (state.status != Status.loading &&
              state.rooms.isEmpty &&
              state.isSearching == false) {
            return ChatEmptyWidget();
          }
          // NO SEARCHED ROOM FOUND
          if (state.isSearching == true && state.rooms.isEmpty) {
            return ChatSearchEmptyWidget(searchTem: searchEC.text);
          }

          return Container(
            padding: EdgeInsets.only(top: 15),
            width: double.infinity,
            color: Colors.white,
            child: ListView.builder(
              itemCount: state.rooms.length,
              itemBuilder: ((context, index) {
                return ChatTileWidget(
                  room: state.rooms[index],
                  onTap: (selectedRoom) {
                    if (!selectedRoom.isGroup) {
                      context.push(
                        '/chat/private/${state.rooms[index].id}',
                        extra: state.rooms[index],
                      );
                    } else {
                      context.push(
                        '/group-chat/${state.rooms[index].id}',
                        extra: {
                          'chatModel':
                              state.rooms[index].copyWith(isJoined: true)
                        },
                      );
                    }
                  },
                );
              }),
            ),
          );
        },
      ),
    );
  }
}
