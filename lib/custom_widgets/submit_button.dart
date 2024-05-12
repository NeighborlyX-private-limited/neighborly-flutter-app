import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String title;
  final Icon? icon;
  final Color? bgColor;
  final TextStyle? textStyle;

  const SubmitButton({
    super.key,
    required this.title,
    this.icon,
    this.bgColor = Colors.white,
    this.textStyle,
    required this.onPressed
    });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Container(
        height: 48,
        width: double.maxFinite,
        decoration: BoxDecoration(  
           borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.25),
              offset: const Offset(0, 0),
              blurRadius: 2,
              spreadRadius: 1,
            ),
          ],
        ),
        child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
                side: BorderSide.none,
              ),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF000000)),
          ),
          onPressed: onPressed,
          child:icon!=null ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            icon!,
            const SizedBox(
              width: 11,
            ),
              Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
              )
            ],
          )
          :Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
          ),
        ),
    )
    );
  }
}
