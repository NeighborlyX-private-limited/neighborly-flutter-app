import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
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
  late FocusNode dayFocusNode;
  late FocusNode monthFocusNode;
  late FocusNode yearFocusNode;

  @override
  void initState() {
    super.initState();
    dayFocusNode = FocusNode();
    monthFocusNode = FocusNode();
    yearFocusNode = FocusNode();
  }

  @override
  void dispose() {
    dayFocusNode.dispose();
    monthFocusNode.dispose();
    yearFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTextField(
          context,
          controller: widget.dateController,
          focusNode: dayFocusNode,
          nextFocusNode: monthFocusNode,
          labelText: 'DD',
          maxLength: 2,
          validationPattern: r'^(0[1-9]|[12][0-9]|3[01])$', // Valid day
        ),
        _buildTextField(
          context,
          controller: widget.monthController,
          focusNode: monthFocusNode,
          nextFocusNode: yearFocusNode,
          labelText: 'MM',
          maxLength: 2,
          validationPattern: r'^(0[1-9]|1[0-2])$', // Valid month
        ),
        _buildTextField(
          context,
          controller: widget.yearController,
          focusNode: yearFocusNode,
          nextFocusNode: null,
          labelText: 'YYYY',
          maxLength: 4,
          validationPattern: r'^\d{4}$', // Valid year
        ),
      ],
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    required FocusNode focusNode,
    required FocusNode? nextFocusNode,
    required String labelText,
    required int maxLength,
    required String validationPattern,
  }) {
    return Container(
      width: 100,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        maxLength: maxLength,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(maxLength),
        ],
        decoration: InputDecoration(
          counterText: '',
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onChanged: (value) {
          if (RegExp(validationPattern).hasMatch(value)) {
            if (nextFocusNode != null) {
              nextFocusNode.requestFocus();
            } else {
              focusNode.unfocus();
            }
          }
          setState(() {
            widget.isDayFilled = widget.dateController.text.isNotEmpty;
            widget.isMonthFilled = widget.monthController.text.isNotEmpty;
            widget.isYearFilled = widget.yearController.text.isNotEmpty;
          });
        },
      ),
    );
  }
}
