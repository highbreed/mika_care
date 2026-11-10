// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../components/dynamic_widgets.dart';
import '../../../constants/main_constants.dart';
import '../../../modals/user_modal.dart';
import '../../../providers/user_provider.dart';
import '../../../services/api_services.dart';
import 'package:provider/provider.dart';

class OtpForm extends StatefulWidget {
  final String userId;
  const OtpForm({super.key, required this.userId});

  @override
  State<OtpForm> createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  late StreamSubscription<String> tokenStreamSubscription;


  DynamicMaster dynamicMaster = DynamicMaster();
  ApiService apiService = ApiService();
  FocusNode? pin2FocusNode;
  FocusNode? pin3FocusNode;
  FocusNode? pin4FocusNode;

  TextEditingController pin1Controller = TextEditingController();
  TextEditingController pin2Controller = TextEditingController();
  TextEditingController pin3Controller = TextEditingController();
  TextEditingController pin4Controller = TextEditingController();


  @override
  void initState() {
    super.initState();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    pin2FocusNode!.dispose();
    pin3FocusNode!.dispose();
    pin4FocusNode!.dispose();
  }

  void nextField(String value, FocusNode? focusNode) {
    if (value.length == 1) {
      focusNode!.requestFocus();
    }
  }

  
  Future<void> updateFPMToken(String userToken) async {

    String? token = await messaging.getToken();

    if(token != null){

      await apiService.submitFPMToken(userToken, token);
      
    }
  }

  Future<void> submitOtpCode() async {

    if(pin1Controller.text.isEmpty || pin2Controller.text.isEmpty || pin3Controller.text.isEmpty || pin4Controller.text.isEmpty){
      dynamicMaster.displayError(context, 'Error', 'Invalid OTP Code, please try again.');
      return;
    }else{
      dynamicMaster.displayLoadingModal(context);

      String otpCode = pin1Controller.text + pin2Controller.text + pin3Controller.text + pin4Controller.text;

      var response = await apiService.submitOtpVerification(widget.userId, otpCode);


      if(response.isNotEmpty && response.containsKey("status") && response["status"] == "success"){
        User userObj = userFromJson(jsonEncode(response["data_obj"]));

        await updateFPMToken(response["data_obj"]["token"]);
        
        Navigator.of(context).pop();

        Provider.of<UserProvider>(context, listen: false).login(userObj);

        Navigator.of(context).pushReplacementNamed('/home');

      }else{
        Navigator.of(context).pop();
        dynamicMaster.displayError(context, 'Error', response["message"]);
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Form(
      child: Column(
        children: [
          SizedBox(height: size.height * 0.03,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: size.width * 0.15,
                child: TextFormField(
                  autofocus: true,
                  obscureText: true,
                  style: const TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(1),
                    FilteringTextInputFormatter.digitsOnly                    
                  ],
                  controller: pin1Controller,
                  onChanged: (value) {
                    nextField(value, pin2FocusNode);
                  },
                ),
              ),
              SizedBox(
                width: size.width * 0.15,
                child: TextFormField(
                  focusNode: pin2FocusNode,
                  autofocus: true,
                  obscureText: true,
                  style: const TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(1),
                    FilteringTextInputFormatter.digitsOnly                    
                  ],
                  controller: pin2Controller,
                  onChanged: (value) {
                    nextField(value, pin3FocusNode);
                  },
                ),
              ),
              SizedBox(
                width: size.width * 0.15,
                child: TextFormField(
                  focusNode: pin3FocusNode,
                  autofocus: true,
                  obscureText: true,
                  style: const TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(1),
                    FilteringTextInputFormatter.digitsOnly                    
                  ],
                  controller: pin3Controller,
                  onChanged: (value) {
                    nextField(value, pin4FocusNode);
                  },
                ),
              ),
              SizedBox(
                width: size.width * 0.15,
                child: TextFormField(
                  focusNode: pin4FocusNode,
                  autofocus: true,
                  obscureText: true,
                  style: const TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(1),
                    FilteringTextInputFormatter.digitsOnly                    
                  ],
                  controller: pin4Controller,
                  onChanged: (value) {
                    if (value.length == 1) {
                      pin4FocusNode!.unfocus();
                      // Then you need to check is the code is correct or not
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.03,),
          SizedBox(
            width: size.width * 0.8,
            child: ElevatedButton(
              onPressed: () {
                submitOtpCode();
              },
              style: ElevatedButton.styleFrom(
                // primary: kSecondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)
                ),
                padding: const EdgeInsets.symmetric(vertical: 16)
              ),
              child: const Text("Continue"),
            ),
          )
        ],
      ),
    );
  }
}