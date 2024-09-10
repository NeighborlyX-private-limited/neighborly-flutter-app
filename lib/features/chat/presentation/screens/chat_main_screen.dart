import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
  late var chatMainCubit;
  bool showSearch = false;

  final searchEC = TextEditingController();
  @override
  void initState() {
    super.initState();

    chatMainCubit = BlocProvider.of<ChatMainCubit>(context);

    chatMainCubit.init();
  }

  @override
  void dispose() {
    super.dispose();
    searchEC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        title: showSearch
            ? TextFormField(
                controller: searchEC,
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
                textAlignVertical: TextAlignVertical.center,
                onFieldSubmitted: (value) {},
                onChanged: (value) {
                  if (value.length > 3) {
                    chatMainCubit.filterRoomList(value);
                  } else {
                    chatMainCubit.cleanSearchFilter();
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  // fillColor: widget.isDarkmode! ? Colors.grey[800] : Colors.grey[200],
                  fillColor: AppColors.lightBackgroundColor,
                  hintText: 'type to search your groups', // 'Buscar',
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 20, vertical: 5), // Inside box padding
                  // hintStyle: TextStyle(color: widget.isDarkmode! ? Colors.white.withOpacity(0.4) : Colors.black26),
                  hintStyle: TextStyle(
                      color: Colors.black.withOpacity(0.6),
                      fontSize: 20,
                      fontWeight: FontWeight.w400),
                  border: OutlineInputBorder(
                    gapPadding: 0,
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    gapPadding: 0,
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                cursorColor: Colors.black,
              )
            : Text(
                'Chat',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                showSearch = !showSearch;

                if (!showSearch) {
                  chatMainCubit.cleanSearchFilter();
                }
              });
            },
            icon: Icon(
              showSearch ? Icons.close : Icons.search,
              size: 31,
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: BlocConsumer<ChatMainCubit, ChatMainState>(
        listener: (context, state) {
          switch (state.status) {
            case Status.loading:
              break;
            case Status.failure:
              print('ERROR ${state.failure?.message}');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text('Something went wrong! ${state.failure?.message}'),
                ),
              );
              break;
            case Status.success:
              break;
            case Status.initial:
              break;
          }
        },
        builder: (context, state) {
          //h
          //
          return BlocBuilder<ChatMainCubit, ChatMainState>(
            bloc: chatMainCubit,
            builder: (context, state) {
              if (state.status == Status.loading) {
                return const ChatRoomsSheemer();
              }

              if (state.status != Status.loading &&
                  state.rooms.length == 0 &&
                  state.isSearching == false) {
                return ChatEmptyWidget();
              }

              if (state.isSearching == true && state.rooms.length == 0) {
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
                        print('selectedRoom=${selectedRoom}');

                        var goTo = selectedRoom.isGroup ? 'group' : 'private';
                        print('... goTo=${goTo}');

                        context.push('/chat/${goTo}/${state.rooms[index].id}',
                            extra: state.rooms[index]);
                      },
                    );
                  }),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
