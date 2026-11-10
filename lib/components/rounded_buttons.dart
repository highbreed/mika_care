import 'package:flutter/material.dart';


class RoundedButton extends StatelessWidget {
  final String btnText;
  final void Function() press;
  final Color btnColor, textColor;
  const RoundedButton({super.key, required this.btnText, required this.press, required this.btnColor, required this.textColor});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialButton(
      minWidth: size.width * 0.8,
      height: size.height * 0.06,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
      color: btnColor,
      onPressed: press,
      child: Text(btnText, style: TextStyle(color: textColor),)
    );
  }
}