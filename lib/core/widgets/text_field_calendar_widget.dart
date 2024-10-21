import 'package:flutter/material.dart';

import '../theme/colors.dart';

class TextFieldCalendarWidget extends StatefulWidget {
  final String lableText;
  final TextInputType? inputType;
  final TextEditingController controller;
  final void Function(String) onChanged;
  final double? height;

  final FocusNode? focusNode;
  final bool border;
  final VoidCallback onTap;

  const TextFieldCalendarWidget({
    super.key,
    required this.lableText,
    this.inputType,
    required this.controller,
    required this.onChanged,
    this.height,
    this.focusNode,
    required this.border,
    required this.onTap,
  });

  @override
  State<TextFieldCalendarWidget> createState() =>
      _TextFieldCalendarWidgetState();
}

class _TextFieldCalendarWidgetState extends State<TextFieldCalendarWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height ?? 60,
      child: GestureDetector(
        onTap: () {
          widget.onTap();
        },
        child: AbsorbPointer(
          child: TextField(
            readOnly: true,
            keyboardType: widget.inputType,
            onChanged: widget.onChanged,
            obscureText: false,
            controller: widget.controller,
            focusNode: widget.focusNode,
            decoration: InputDecoration(
              labelText: widget.lableText,
              border: widget.border
                  ? const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    )
                  : InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                  color: AppColors.primaryColor,
                ),
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.calendar_month),
                onPressed: () {
                  widget.onTap();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
