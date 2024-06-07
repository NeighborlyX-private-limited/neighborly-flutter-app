import 'package:flutter/material.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';

class TextFieldWidget extends StatefulWidget {
  final bool isPassword;
  final String lableText;
  final TextInputType? inputType;
  final TextEditingController controller;
  final void Function(String) onChanged;
  const TextFieldWidget(
      {super.key,
      this.isPassword = false,
      required this.lableText,
      required this.controller,
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
      height: 48,
      child: TextField(
        keyboardType: widget.inputType,
        onChanged: widget.onChanged,
        obscureText: widget.isPassword ? _isObscured : false,
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: widget.lableText,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
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
