import 'package:flutter/material.dart';
import '../../../components/dynamic_widgets.dart';
import '../../../constants/main_constants.dart';
import 'components/otp_form.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String userId;
  const OtpScreen({super.key, required this.phoneNumber, required this.userId});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  DynamicMaster dynamicMaster = DynamicMaster();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: dynamicMaster.applicationbar(context, "OTP Verification"),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 16),
                const Text(
                  "OTP Verification",
                  style: headingStyle,
                ),
                Text("We sent your code to  ${widget.phoneNumber}"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("This code will expired in "),
                    TweenAnimationBuilder(
                      tween: Tween(begin: 60.0, end: 0.0),
                      duration: const Duration(seconds: 60),
                      builder: (_, dynamic value, child) => Text(
                        "00:${value.toInt()}",
                        style: const TextStyle(color: kPrimaryColor),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.03,),
                OtpForm(userId: widget.userId,),
                SizedBox(height: size.height * 0.05,),
                GestureDetector(
                  onTap: () {
                    // OTP code resend
                  },
                  child: const Text(
                    "Resend OTP Code",
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                )
              ],
            ),
          )
        ),
      )
    );
  }
}