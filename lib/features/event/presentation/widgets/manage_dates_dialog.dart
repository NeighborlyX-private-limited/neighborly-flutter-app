// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_clean_calendar/controllers/clean_calendar_controller.dart';
import 'package:scrollable_clean_calendar/scrollable_clean_calendar.dart';
import 'package:scrollable_clean_calendar/utils/enums.dart';

import '../../../../core/theme/colors.dart';

class ManageDatesDialog extends StatefulWidget {
  final String? startDateStr;
  final String? endDateStr;
  const ManageDatesDialog({
    super.key,
    this.startDateStr,
    this.endDateStr,
  });

  @override
  State<ManageDatesDialog> createState() => _ManageDatesDialogState();
}

class _ManageDatesDialogState extends State<ManageDatesDialog> {
  late CleanCalendarController calendarController;
  late DateTime? startDate;
  late DateTime? endDate;

  void handleReturn() {
    String? startDateFormated;
    String? endDateFormated;

    if (startDate != null && endDate != null) {
      startDateFormated = DateFormat('dd/MM/yyyy').format(startDate!);
      endDateFormated = DateFormat('dd/MM/yyyy').format(endDate!);
    }

    print('startDateFormated: $startDateFormated');
    print('endDateFormated: $endDateFormated');
    print('startDateRaw: $startDate');
    print('endDateRaw: $endDate');
    Navigator.pop(context, {
      'startDate': startDateFormated,
      'endDate': endDateFormated,
      'startDateRaw': startDate,
      'endDateRaw': endDate,
    });
  }

  @override
  void initState() {
    super.initState();
    startDate = null;
    endDate = null;

    print('... INIT MANAGE DATES DIALOG ');
    print('...widget.startDateStr=${widget.startDateStr}');
    print('...widget.endDateStr=${widget.endDateStr}');

    if ((widget.startDateStr != null && widget.startDateStr != '') &&
        (widget.endDateStr != null && widget.endDateStr != '')) {
      startDate = DateTime.parse(widget
          .startDateStr!); // DateFormat('dd/MM/yyyy').parse(widget.startDateStr!);
      endDate = DateTime.parse(widget
          .endDateStr!); //DateFormat('dd/MM/yyyy').parse(widget.endDateStr!);
    }

    calendarController = CleanCalendarController(
      minDate: DateTime.now(),
      maxDate: DateTime.now().add(const Duration(days: 365)),
      onRangeSelected: (firstDate, secondDate) {
        print('StartDate: $firstDate');
        print('endDate: $secondDate');
        setState(() {
          startDate = firstDate;
          endDate = secondDate;
        });
      },
      onDayTapped: (date) {
        // print(date);
      },
      // readOnly: true,
      onPreviousMinDateTapped: (date) {},
      onAfterMaxDateTapped: (date) {},
      weekdayStart: DateTime.sunday,
      // initialFocusDate: DateTime(2023, 5),
      initialDateSelected: startDate,
      endDateSelected: endDate,
    );
  }

  @override
  void dispose() async {
    super.dispose();
    calendarController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        handleReturn();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                handleReturn();
              },
              icon: Icon(
                Icons.close,
                color: Colors.black,
              )),
          title: Text(
            'Select the date',
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: ScrollableCleanCalendar(
            // locale: 'PT-br',
            calendarController: calendarController,
            layout: Layout.BEAUTY,
            calendarCrossAxisSpacing: 0,
            daySelectedBackgroundColor: AppColors.primaryColor,
            daySelectedBackgroundColorBetween:
                AppColors.primaryColor.withAlpha(130),
          ),

          //  RangePickerPage(),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 10.0, left: 20, right: 20),
          child: Container(
            // height: 50,
            // color: Colors.amber,

            child: Row(
              children: [
                //
                //

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      calendarController.clearSelectedDates();
                      setState(() {
                        startDate = null;
                        endDate = null;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            50), // Ajuste o raio conforme necessário
                      ),
                      // padding: EdgeInsets.all(15)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Clear',
                        style: TextStyle(
                            color: Colors.grey, fontSize: 18, height: 0.3),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // handleSave(false);
                      print('startDateSelected: $startDate');
                      print('endDateSelected: $endDate');

                      handleReturn();
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
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Save Selection',
                        style: TextStyle(
                            color: Colors.white, fontSize: 18, height: 0.3),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
