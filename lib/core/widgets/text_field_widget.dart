import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/colors.dart';

class TextFieldWidget extends StatefulWidget {
  final bool isPassword;
  final bool enabled;
  final String lableText;
  final TextInputType? inputType;
  final TextEditingController controller;
  final void Function(String) onChanged;
  final double? height;
  final FocusNode? focusNode;
  final bool border;
  final bool digitsOnly;
  final int? maxLength;

  const TextFieldWidget({
    super.key,
    required this.border,
    this.isPassword = false,
    required this.lableText,
    required this.controller,
    this.focusNode,
    required this.onChanged,
    this.inputType,
    this.height,
    this.digitsOnly = false,
    this.enabled = true,
    this.maxLength,
  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height ?? 60,
      child: TextField(
        enabled: widget.enabled,
        textCapitalization: TextCapitalization.sentences,
        keyboardType: widget.inputType,
        onChanged: widget.onChanged,
        obscureText: widget.isPassword ? _isObscured : false,
        controller: widget.controller,
        focusNode: widget.focusNode,
        inputFormatters:
            widget.digitsOnly ? [FilteringTextInputFormatter.digitsOnly] : null,
        maxLength: widget.maxLength,
        decoration: InputDecoration(
          counterText: '',
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
