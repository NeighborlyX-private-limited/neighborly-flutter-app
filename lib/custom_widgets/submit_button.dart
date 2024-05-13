import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String title;
  final String? iconImagePath;
  final Color? bgColor;
  final TextStyle? textStyle;

  const SubmitButton({
    Key? key,
    required this.title,
    this.iconImagePath,
    this.bgColor = Colors.white,
    this.textStyle,
    required this.onPressed
    }) :super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
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
          color: bgColor,
        ),
        child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
                side: BorderSide.none,
              ),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
          ),
          onPressed: onPressed,
          child:iconImagePath!=null 
          ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                iconImagePath!,
                width: 24,
                height: 24,
              ),
            const SizedBox(
              width: 11,
            ),
              Text(
              title,
              style: textStyle,
              // const TextStyle(
              //   fontSize: 18,
              //   color: Colors.white,
              // ),
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
