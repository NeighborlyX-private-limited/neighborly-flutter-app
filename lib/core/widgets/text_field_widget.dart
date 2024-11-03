// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart'; // Import for input formatter
// import '../theme/colors.dart';

// class TextFieldWidget extends StatefulWidget {
//   final bool isPassword;
//   final String lableText;
//   final TextInputType? inputType;
//   final TextEditingController controller;
//   final void Function(String) onChanged;
//   final double? height;
//   final FocusNode? focusNode;
//   final bool border;
//   final bool digitsOnly;

//   const TextFieldWidget({
//     super.key,
//     required this.border,
//     this.isPassword = false,
//     required this.lableText,
//     required this.controller,
//     this.focusNode,
//     required this.onChanged,
//     this.inputType,
//     this.height,
//     this.digitsOnly = false,
//   });

//   @override
//   State<TextFieldWidget> createState() => _TextFieldWidgetState();
// }

// class _TextFieldWidgetState extends State<TextFieldWidget> {
//   bool _isObscured = true;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: widget.height ?? 60,
//       child: TextField(
//         textCapitalization: TextCapitalization.sentences,
//         keyboardType: widget.inputType,
//         onChanged: widget.onChanged,
//         obscureText: widget.isPassword ? _isObscured : false,
//         controller: widget.controller,
//         focusNode: widget.focusNode,
//         inputFormatters:
//             widget.digitsOnly ? [FilteringTextInputFormatter.digitsOnly] : null,
//         decoration: InputDecoration(
//           labelText: widget.lableText,
//           border: widget.border
//               ? const OutlineInputBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                 )
//               : InputBorder.none,
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10.0),
//             borderSide: const BorderSide(
//               color: AppColors.primaryColor,
//             ),
//           ),
//           suffixIcon: widget.isPassword
//               ? IconButton(
//                   icon: Icon(
//                     _isObscured ? Icons.visibility_off : Icons.visibility,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       _isObscured = !_isObscured;
//                     });
//                   },
//                 )
//               : null,
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for input formatter
import '../theme/colors.dart';

class TextFieldWidget extends StatefulWidget {
  final bool isPassword;
  final String lableText;
  final TextInputType? inputType;
  final TextEditingController controller;
  final void Function(String) onChanged;
  final double? height;
  final FocusNode? focusNode;
  final bool border;
  final bool digitsOnly;
  final int? maxLength; // Add maxLength as an optional parameter

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
    this.maxLength, // Initialize maxLength
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
        textCapitalization: TextCapitalization.sentences,
        keyboardType: widget.inputType,
        onChanged: widget.onChanged,
        obscureText: widget.isPassword ? _isObscured : false,
        controller: widget.controller,
        focusNode: widget.focusNode,
        inputFormatters:
            widget.digitsOnly ? [FilteringTextInputFormatter.digitsOnly] : null,
        maxLength: widget.maxLength, // Set maxLength if provided
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
