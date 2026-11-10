import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF000000);
const kPrimaryLightColor = Color(0xFFFFFFFF);
const kSecondaryColor = Color(0xFF6F35A5);
const kSecondaryLightColor = Color(0xFFF1E6FF);
const kSecondaryColor2 = Color(0xFFFFEAC9);
const kRedColor = Color(0xFFD50000);
const kBlueColor = Color.fromARGB(255, 31, 128, 207);


const headingStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

final otpInputDecoration = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(vertical: 16),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: const BorderSide(color: kSecondaryColor),
  );
}