import 'package:flutter/material.dart';
import '../../../../core/widgets/text_field_widget.dart';

import 'package:flutter/material.dart';
import '../../../../core/widgets/text_field_widget.dart';

class DOBPickerWidget extends StatefulWidget {
  final TextEditingController dateController;
  final TextEditingController monthController;
  final TextEditingController yearController;
  late bool isDayFilled;
  late bool isMonthFilled;
  late bool isYearFilled;

  DOBPickerWidget({
    super.key,
    required this.dateController,
    required this.monthController,
    required this.yearController,
    required this.isDayFilled,
    required this.isMonthFilled,
    required this.isYearFilled,
  });

  @override
  State<DOBPickerWidget> createState() => _DOBPickerWidgetState();
}

class _DOBPickerWidgetState extends State<DOBPickerWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            width: 110,
            decoration: const BoxDecoration(
                border: Border.fromBorderSide(
                  BorderSide(
                    color: Colors.grey,
                  ),
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  bottomLeft: Radius.circular(8.0),
                )),
            child: TextFieldWidget(
              border: false,
              controller: widget.dateController,
              isPassword: false,
              onChanged: (value) {
                setState(() {
                  widget.isDayFilled = widget.dateController.text.isNotEmpty;
                });
              },
              lableText: '  DD', // Corrected syntax
            )),
        Container(
            width: 110,
            decoration: const BoxDecoration(
                border: Border.fromBorderSide(
              BorderSide(
                color: Colors.grey,
              ),
            )),
            child: TextFieldWidget(
              border: false,
              controller: widget.monthController,
              isPassword: false,
              onChanged: (value) {
                setState(() {
                  widget.isMonthFilled = widget.monthController.text.isNotEmpty;
                });
              },
              lableText: '  MM', // Corrected syntax
            )),
        Container(
            width: 110,
            decoration: const BoxDecoration(
                border: Border.fromBorderSide(
                  BorderSide(
                    color: Colors.grey,
                  ),
                ),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                )),
            child: TextFieldWidget(
              border: false,
              controller: widget.yearController,
              isPassword: false,
              onChanged: (value) {
                setState(() {
                  widget.isYearFilled = widget.yearController.text.isNotEmpty;
                });
              },
              lableText: '  YYYY', // Corrected syntax
            )),
      ],
    );
  }
}
