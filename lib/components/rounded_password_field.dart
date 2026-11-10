// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'text_field_container.dart';
import '../constants/main_constants.dart';

class RoundedPasswordField extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  const RoundedPasswordField({super.key, this.onChanged, this.controller});

  @override
  _RoundedPasswordFieldState createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        obscureText: _obscureText,
        decoration: InputDecoration(
          hintText: "Password",
          icon: Icon(Icons.lock, color: kSecondaryColor),
          suffixIcon: GestureDetector(
            onTap: _togglePasswordVisibility,
            child: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              color: kSecondaryColor,
            ),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
