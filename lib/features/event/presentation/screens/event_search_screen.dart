// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_clean_calendar/controllers/clean_calendar_controller.dart';
import 'package:scrollable_clean_calendar/scrollable_clean_calendar.dart';
import 'package:scrollable_clean_calendar/utils/enums.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/constants/status.dart';
import '../../../../core/theme/colors.dart';
import '../../../posts/presentation/widgets/toggle_button_widget.dart';
import '../bloc/event_search_cubit.dart';
import '../widgets/event_card_widget.dart';
import '../widgets/event_empty_search_local.dart';
import '../widgets/event_empty_search_result.dart';
import '../widgets/event_sheemer.dart';
import '../widgets/manage_dates_dialog.dart';

class EventSearchScreen extends StatefulWidget {
  const EventSearchScreen({super.key});

  @override
  State<EventSearchScreen> createState() => _EventSearchScreenState();
}

class _EventSearchScreenState extends State<EventSearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late EventSearchCubit eventSearchCubit;
  int selectedTab = 0;
  bool isNearBy = false;
  bool isSummary = true;
  String selectedFilter = '';
  late DateTime? selectedDate;

  late CleanCalendarController calendarController;

  late DateTime? startDate;

  final searchTermEC = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    eventSearchCubit = BlocProvider.of<EventSearchCubit>(context);
    eventSearchCubit.init();

    calendarController = CleanCalendarController(
      minDate: DateTime.now(),
      maxDate: DateTime.now().add(const Duration(days: 365)),
      onRangeSelected: (firstDate, secondDate) {
        print('StartDate: ${firstDate}');
        print('endDate: ${secondDate}');
        setState(() {
          startDate = firstDate;
        });
      },
      onDayTapped: (date) {
        print('selectedDate: ${selectedDate}');
        setState(() {
          selectedDate = date;
        });
      },
      // readOnly: true,
      onPreviousMinDateTapped: (date) {},
      onAfterMaxDateTapped: (date) {},
      weekdayStart: DateTime.sunday,
      // initialFocusDate: DateTime(2023, 5),
      // initialDateSelected: startDate,
      // endDateSelected: endDate,
    );
  }

  @override
  void dispose() {
    super.dispose();
    searchTermEC.dispose();
    calendarController.dispose();
  }

  Future<dynamic> searchFilterSheet(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: selectedFilter == 'date' ? 850 : 440,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              )),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (selectedFilter == 'date') ...[
                Container(
                  height: 570,
                  color: Colors.green,
                  child: ScrollableCleanCalendar(
                    // locale: 'PT-br',
                    calendarController: calendarController,
                    layout: Layout.BEAUTY,
                    calendarCrossAxisSpacing: 0,
                    daySelectedBackgroundColor: AppColors.primaryColor,
                    // daySelectedBackgroundColorBetween: AppColors.grayBlueLigth.withAlpha(130),
                  ),
                ),
              ],

              if (selectedFilter == 'category') ...[
                Center(
                  child: Text(
                    'Category',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  height: 350,
                  // color: Colors.green,
                  margin: EdgeInsets.only(top: 10),
                  // color: Colors.green,
                  child: ListView.separated(
                    // scrollDirection: Axis.horizontal,
                    itemCount: kEventCategories.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          eventSearchCubit
                              .onUpdateCategory(kEventCategories[index]);
                          Navigator.pop(context);
                        },
                        child: Container(
                          // padding: EdgeInsets.only(left: index == 0 ? 13 : 1),
                          // color: Colors.grey,
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            kEventCategories[index],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                          color: Colors.grey[
                              300]); // Aqui você pode personalizar o divisor
                    },
                  ),
                ),
              ],

              if (selectedFilter == 'location') ...[
                Center(
                  child: Text(
                    'Location',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  height: 350,
                  // color: Colors.green,
                  margin: EdgeInsets.only(top: 10),
                  // color: Colors.green,
                  child: ListView.separated(
                    // scrollDirection: Axis.horizontal,
                    itemCount: kLocationList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          eventSearchCubit
                              .onUpdateLocation(kLocationList[index]);
                          Navigator.pop(context);
                        },
                        child: Container(
                          // padding: EdgeInsets.only(left: index == 0 ? 13 : 1),
                          // color: Colors.grey,
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            kLocationList[index],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                          color: Colors.grey[
                              300]); // Aqui você pode personalizar o divisor
                    },
                  ),
                ),
              ],
              // Text(
              //   'Thanks for letting us know',
              //   style: onboardingHeading2Style,
              // ),
              // Text(
              //   textAlign: TextAlign.center,
              //   'We appreciate your help in keeping our community safe and respectful. Our team will review the content shortly.',
              //   style: blackonboardingBody1Style,
              // ),
            ],
          ),
        );
      },
    );
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

    // eventSearchCubit.updateNearBy(!value);
  }

  String simplifyISOtimeString(String dateStart, String dateEnd) {
    DateTime dateTimeStart = DateTime.parse(dateStart);
    DateTime dateTimeEnd = DateTime.parse(dateEnd);

    // Formata a data no formato desejado (dd/MM)
    String formattedDateStart = DateFormat('dd/MM').format(dateTimeStart);
    String formattedDateEnd = DateFormat('dd/MM').format(dateTimeEnd);

    return '${formattedDateStart} - ${formattedDateEnd}';
  }

  Widget searchElement(
      {required String noSelectedText,
      required String selectedValue,
      required VoidCallback onTap,
      required VoidCallback onClear}) {
    return InkWell(
      onTap: selectedValue != '' ? onClear : onTap,
      child: Container(
        height: 32,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Colors.grey.withAlpha(100)),
          color: selectedValue != '' ? AppColors.primaryColor : Colors.white,
        ),
        padding: EdgeInsets.fromLTRB(10, 5, 8, 5),
        child: Row(
          children: [
            Text(
              selectedValue != '' ? selectedValue : noSelectedText,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: selectedValue != '' ? Colors.white : Colors.black38,
              ),
            ),
            const SizedBox(
              width: 2,
            ),
            Icon(
              selectedValue != ''
                  ? Icons.close
                  : Icons.keyboard_arrow_down_outlined,
              color: selectedValue != '' ? Colors.white : Colors.black38,
              size: selectedValue != '' ? 15 : 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget searchArea(
    BuildContext context, {
    required String dateFilterStart,
    required String dateFilterEnd,
    required String filterCategory,
    required String filterLocation,
    required VoidCallback onCleanDate,
    required VoidCallback onCleanCategory,
    required VoidCallback onCleanLocation,
  }) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: searchTermEC,
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              textAlignVertical: TextAlignVertical.center,
              onFieldSubmitted: (value) {
                print('submited: ' + searchTermEC.text.trim());
                eventSearchCubit.onPressSearch(searchTermEC.text.trim());
              },
              onChanged: (value) {
                // if (value.length > 3) {
                //   chatMainCubit.filterRoomList(value);
                // } else {
                //   chatMainCubit.cleanSearchFilter();
                // }
              },
              decoration: InputDecoration(
                filled: true,
                // fillColor: widget.isDarkmode! ? Colors.grey[800] : Colors.grey[200],
                fillColor: AppColors.lightBackgroundColor,
                hintText: 'Search', // 'Buscar',
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 18, vertical: 3), // Inside box padding
                // hintStyle: TextStyle(color: widget.isDarkmode! ? Colors.white.withOpacity(0.4) : Colors.black26),
                hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.6),
                    fontSize: 18,
                    fontWeight: FontWeight.w400),
                border: OutlineInputBorder(
                  gapPadding: 0,
                  borderSide: BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
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
            ),
          ),
          Divider(height: 2, color: Colors.grey[300]),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                searchElement(
                  noSelectedText: 'Date',
                  selectedValue: dateFilterStart != ''
                      ? simplifyISOtimeString(dateFilterStart, dateFilterEnd)
                      : '',
                  onTap: () async {
                    // setState(() {
                    //   selectedFilter = 'date';
                    //   searchFilterSheet(context);
                    // });
                    print('DO SOMETHING');
                    var response = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ManageDatesDialog(
                                endDateStr: dateFilterStart == ''
                                    ? DateTime.now()
                                        .toIso8601String()
                                        .split('T')[0]
                                    : dateFilterStart,
                                startDateStr: dateFilterEnd == ''
                                    ? DateTime.now()
                                        .toIso8601String()
                                        .split('T')[0]
                                    : dateFilterEnd,
                              )),
                    ); //

                    if (response == null) return;

                    print('...onPressOpenDatesSelection response=${response}');

                    eventSearchCubit.onUpdateDate(
                        response['startDateRaw'].toString(),
                        response['endDateRaw'].toString());
                  },
                  onClear: onCleanDate,
                ),
                const SizedBox(width: 8),
                //
                //
                searchElement(
                  noSelectedText: 'Category',
                  selectedValue: filterCategory,
                  onTap: () {
                    setState(() {
                      selectedFilter = 'category';
                      searchFilterSheet(context);
                    });
                  },
                  onClear: onCleanCategory,
                ),
                const SizedBox(width: 8),
                //
                //
                searchElement(
                  noSelectedText: 'Location',
                  selectedValue: filterLocation,
                  onTap: () {
                    setState(() {
                      selectedFilter = 'location';
                      searchFilterSheet(context);
                    });
                  },
                  onClear: onCleanLocation,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.close,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
        body: BlocConsumer<EventSearchCubit, EventSearchState>(
          bloc: eventSearchCubit,
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
            return BlocBuilder<EventSearchCubit, EventSearchState>(
              bloc: eventSearchCubit,
              builder: (context, state) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      //
                      // SEARCH area
                      searchArea(
                        context,
                        dateFilterStart: state.dateFilterStart,
                        dateFilterEnd: state.dateFilterEnd,
                        filterCategory: state.categoryFilter,
                        filterLocation: state.locationFilter,
                        onCleanDate: () {
                          eventSearchCubit.onUpdateDate('', '');
                        },
                        onCleanCategory: () {
                          eventSearchCubit.onUpdateCategory('');
                        },
                        onCleanLocation: () {
                          eventSearchCubit.onUpdateLocation('');
                        },
                      ),
                      const SizedBox(height: 5),
                      //
                      //
                      //
                      // RESULT area
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              //
                              //
                              if (state.status == Status.loading)
                                EventMainSheemer(),

                              if (state.status != Status.loading &&
                                  state.eventsLocal.length == 0) ...[
                                if (searchTermEC.text != '') EventEmptyResult(),

                                if (searchTermEC.text == '')
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 50.0),
                                    child: EventEmptySearchLocal(),
                                  ),
                                //
                                //
                              ],
                              if (state.status != Status.loading &&
                                  state.eventsLocal.length > 0) ...[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        isSummary
                                            ? 'Local Events'
                                            : 'All Local Events',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ),

                                ...state.eventsLocal
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

                                // Container(
                                //   height: 300,
                                //   margin: EdgeInsets.only(top: 10),
                                //   // color: Colors.green,
                                //   child: ListView.builder(
                                //     // scrollDirection: Axis.horizontal,
                                //     itemCount: state.eventsLocal.length,
                                //     itemBuilder: (context, index) {
                                //       return Container(
                                //         padding: EdgeInsets.only(left: index == 0 ? 13 : 1),
                                //         child: EventCardWidget(
                                //           event: state.eventsLocal[index],
                                //           width: MediaQuery.of(context).size.width * 0.9,
                                //           onSelect: (EventModel) {
                                //             print('selected: ${EventModel}');
                                //           },
                                //         ),
                                //       );
                                //     },
                                //   ),
                                // ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      //
                      //
                    ],
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
