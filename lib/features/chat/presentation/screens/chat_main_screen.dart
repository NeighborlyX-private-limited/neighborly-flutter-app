import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/constants/app_images.dart';
import 'package:neighborly_flutter_app/core/widgets/custom_snackbar.dart';
import '../../../../core/constants/status.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/widgets/svg_icon.dart';
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
        backgroundColor: AppColors.whiteColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: showSearch
            ? null
            : GestureDetector(
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                ),
                onTap: () {
                  context.pop();
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
                  hintText: 'Search',
                  filled: true,
                  fillColor: AppColors.lightBackgroundColor,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  hintStyle: mediumGreyTextStyle.copyWith(
                    color: AppColors.lightGreyColor,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                cursorColor: AppColors.greyColor,
              )
            // APP BAR TITLE
            : Text(
                'Chat',
                style: blackNormalTextStyle,
              ),
        actions: [
          // SEARCH ICON
          GestureDetector(
            onTap: () {
              setState(() {
                showSearch = !showSearch;
                if (!showSearch) {
                  chatMainCubit.cleanSearchFilter();
                  searchEC.clear();
                }
              });
            },
            child: CircularSvgImage(
              assetPath:
                  showSearch ? AppImages.closeIcon : AppImages.searchIcon,
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
              message: state.failure?.message ?? 'oops something went wrong',
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
            width: double.infinity,
            color: AppColors.whiteColor,
            child: ListView.builder(
              itemCount: state.rooms.length,
              itemBuilder: ((context, index) {
                return ChatTileWidget(
                  room: state.rooms[index],
                  onTap: (selectedRoom) {
                    if (!selectedRoom.isGroup) {
                      context.push(
                        '/chat/private/${state.rooms[index].id}',
                      );
                    } else {
                      context.push(
                        '/group-chat/${state.rooms[index].id}',
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
