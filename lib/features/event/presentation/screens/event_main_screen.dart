import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/status.dart';
import '../../../../core/theme/colors.dart';
import '../../../posts/presentation/widgets/toggle_button_widget.dart';
import '../bloc/event_main_cubit.dart';
import '../widgets/event_card_widget.dart';
import '../widgets/event_empty_going.dart';
import '../widgets/event_empty_local.dart';
import '../widgets/event_empty_my.dart';
import '../widgets/event_sheemer.dart';

class EventMainScreen extends StatefulWidget {
  const EventMainScreen({super.key});

  @override
  State<EventMainScreen> createState() => _EventMainScreenState();
}

class _EventMainScreenState extends State<EventMainScreen>
    with SingleTickerProviderStateMixin {
  // ignore: unused_field
  late TabController _tabController;
  late var eventMainCubit;
  int selectedTab = 0;
  bool isNearBy = false;
  bool isSummary = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    eventMainCubit = BlocProvider.of<EventMainCubit>(context);
    eventMainCubit.init();

    // _tabController.addListener(() {
    //   if (_tabController.indexIsChanging) {
    //     // print('Tab changed to index: ${_tabController.index}');
    //     setState(() {});
    //   }
    // });
  }

  @override
  void dispose() {
    // _tabController.dispose();
    super.dispose();
  }

  Widget tabTitle(String title, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = selectedTab == 0 ? 1 : 0;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.45,
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            border: BorderDirectional(
                bottom: BorderSide(
          color: isSelected ? AppColors.primaryColor : Colors.white,
          width: 2,
        ))),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 19,
            color: isSelected ? Colors.black : Colors.grey,
          ),
        ),
      ),
    );
  }

  void handleToggle(bool value) {
    setState(() {
      isNearBy = value;
    });

    eventMainCubit.updateNearBy(!value);
  }

  void handleToggleIsSummary(bool value) {
    setState(() {
      isSummary = value;
      eventMainCubit.updateIsSummary(value, !isNearBy);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            children: [
              SvgPicture.asset(
                'assets/logo.svg',
                width: 30,
                height: 34,
              ),
              const SizedBox(width: 10),
              CustomToggleSwitch(
                imagePath1: 'assets/home.svg',
                imagePath2: 'assets/location.svg',
                onToggle: handleToggle, // Pass the callback function
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: InkWell(
                onTap: () {
                  context.push('/events/search');
                },
                child: SvgPicture.asset(
                  'assets/search.svg',
                  fit: BoxFit.contain,
                  width: 30, // Adjusted to fit within the AppBar
                  height: 30,
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(right: 16.0),
            //   child: InkWell(
            //     onTap: () {
            //       context.push('/chat');
            //     },
            //     child: SvgPicture.asset(
            //       'assets/chat.svg',
            //       fit: BoxFit.contain,
            //       width: 30, // Adjusted to fit within the AppBar
            //       height: 30,
            //     ),
            //   ),
            // ),
          ],
        ),
        body: BlocConsumer<EventMainCubit, EventMainState>(
          bloc: eventMainCubit,
          listener: (context, state) {
            print('... state.currentUser: ${state.status}');

            switch (state.status) {
              case Status.loading:
                break;
              case Status.failure:
                // hideLoader();
                // showError(state.errorMessage ?? 'Some error');
                print('ERROR ${state.failure?.message}');
                break;
              case Status.success:
                break;
              case Status.initial:
                break;
            }
          },
          builder: (context, state) {
            return BlocBuilder<EventMainCubit, EventMainState>(
              bloc: eventMainCubit,
              builder: (context, state) {
                if (state.status == Status.loading) {
                  return const EventMainSheemer();
                }

                print('...state.eventsGoing=${state.eventsGoing}');

                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        //
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                isSummary ? 'Local Events' : 'All Local Events',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              GestureDetector(
                                onTap: () {
                                  handleToggleIsSummary(!isSummary);
                                },
                                child: Text(
                                  isSummary ? 'See all' : 'See less',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xff635BFF),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // const SizedBox(height: 5),

                        if (state.eventsLocal.length == 0)
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: EventEmptyLocal(),
                          ),
                        //
                        //
                        if (state.eventsLocal.length > 0) ...[
                          Container(
                            height: 300,
                            margin: EdgeInsets.only(top: 10),
                            // color: Colors.green,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: state.eventsLocal.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: EdgeInsets.only(
                                      left: index == 0 ? 13 : 1),
                                  child: EventCardWidget(
                                    event: state.eventsLocal[index],
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    onSelect: (EventModel) {
                                      print('selected: ${EventModel}');
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                        // //
                        // //
                        const SizedBox(
                          height: 20,
                        ),
                        Divider(
                          color: AppColors.lightBackgroundColor,
                          thickness: 20,
                        ),

                        // //
                        // //
                        // TabBarView(
                        //   controller: _tabController,
                        //   children: [

                        //     My Events

                        //     //
                        //     //
                        //     if (state.eventsMine.length == 0) ...[
                        //       Container(
                        //         height: 400,
                        //         color: Colors.green,
                        //         child: GridView.builder(
                        //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        //               crossAxisCount: 2, // Número de colunas
                        //               crossAxisSpacing: 10.0, // Espaçamento horizontal entre os itens
                        //               mainAxisSpacing: 10.0, // Espaçamento vertical entre os itens
                        //               childAspectRatio: 1 / 1.5),
                        //           itemCount: state.eventsMine.length,
                        //           itemBuilder: (context, index) {
                        //             return Container(
                        //               child: EventCardWidget(
                        //                 event: state.eventsMine[index],
                        //               ),
                        //             );
                        //           },
                        //         ),
                        //       ),
                        //     ],
                        //     //
                        //     //
                        //     if (state.eventsGoing.length == 0)
                        //       Padding(
                        //         padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        //         child: EventEmptyMy(),
                        //       ),
                        //     //
                        //     //
                        //     if (state.eventsGoing.length != 0) ...[
                        //       Container(
                        //         height: 400,
                        //         color: Colors.green,
                        //         child: GridView.builder(
                        //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        //               crossAxisCount: 2, // Número de colunas
                        //               crossAxisSpacing: 10.0, // Espaçamento horizontal entre os itens
                        //               mainAxisSpacing: 10.0, // Espaçamento vertical entre os itens
                        //               childAspectRatio: 1 / 1.5),
                        //           itemCount: state.eventsGoing.length,
                        //           itemBuilder: (context, index) {
                        //             return Container(
                        //               child: EventCardWidget(
                        //                 event: state.eventsGoing[index],
                        //               ),
                        //             );
                        //           },
                        //         ),
                        //       ),
                        //     ],

                        //   ],
                        // ),
                        //
                        //
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            tabTitle('My Events', selectedTab == 0),
                            tabTitle('Going Events', selectedTab == 1),
                          ],
                        ),
                        Column(
                          children: [
                            //
                            //
                            if (selectedTab == 0) ...[
                              // MY EVENTS
                              if (state.eventsMine.length > 0)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: EventEmptyMy(),
                                ),
                              //
                              //
                              if (state.eventsMine.length == 0) ...[
                                EventEmptyMy(),
                              ],
                            ],
                            //
                            //
                            if (selectedTab == 1) ...[
                              // GOING
                              if (state.eventsGoing.length > 0)
                                ...state.eventsGoing
                                    .map((event) => Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: EventCardWidget(
                                            event: event,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            onSelect: (EventModel) {
                                              print('selected: ${EventModel}');
                                            },
                                          ),
                                        ))
                                    .toList(),

                              // Expanded(
                              //   child: ListView.builder(
                              //     // scrollDirection: Axis.horizontal,
                              //     physics: NeverScrollableScrollPhysics(),
                              //     itemCount: state.eventsGoing.length,
                              //     itemBuilder: (context, index) {
                              //       print('...state.eventsGoing=${state.eventsGoing}');
                              //       return Container(
                              //         padding: EdgeInsets.only(left: index == 0 ? 13 : 1),
                              //         child: EventCardWidget(
                              //           event: state.eventsGoing[index],
                              //           width: MediaQuery.of(context).size.width * 0.9,
                              //           onSelect: (EventModel) {
                              //             print('selected: ${EventModel}');
                              //           },
                              //         ),
                              //       );
                              //     },
                              //   ),
                              // ),
                              //
                              //
                              if (state.eventsGoing.length == 0) ...[
                                EventEmptyGoing(),
                              ],
                            ],
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
