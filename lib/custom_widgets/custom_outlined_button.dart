import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String title;
  final Icon? icon;
  final Color? bgColor;
  final TextStyle? textStyle;

  const CustomButton({
    super.key,
    required this.title,
    this.icon,
    this.bgColor = Colors.white,
    this.textStyle,
    required this.onPressed
    });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (){
        onPressed!();
      }, 
      child: icon!= null ? Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon!,
          SizedBox(
            width: 10,
          ),
          Text(title, style: textStyle,)
        ],
        )
        : Text(
          title,
          style: textStyle,),
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50),)
        ),
      ),
    );
  }
}
