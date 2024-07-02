import 'package:flutter/material.dart';
import '../theme/colors.dart';

class TextFieldWidget extends StatefulWidget {
  final bool isPassword;
  final String lableText;
  final TextInputType? inputType;
  final TextEditingController controller;
  final void Function(String) onChanged;

  final FocusNode? focusNode;
  final bool border;
  const TextFieldWidget(
      {super.key,
      required this.border,
      this.isPassword = false,
      required this.lableText,
      required this.controller,
      this.focusNode,
      required this.onChanged,
      this.inputType});

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  bool _isObscured = true;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: TextField(
        keyboardType: widget.inputType,
        onChanged: widget.onChanged,
        obscureText: widget.isPassword ? _isObscured : false,
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
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _isObscured ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
