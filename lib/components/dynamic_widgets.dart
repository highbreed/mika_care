// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:badges/badges.dart' as badges;
import '../constants/main_constants.dart';
// import 'package:mika_care/providers/user_provider.dart';
// import 'package:provider/provider.dart';

class DynamicMaster {
  
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
  
  Future<dynamic> displayError(BuildContext context, String errorHeader, String message) {
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          content: SizedBox(
            height: 250,
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(
                  // height: 50,
                  child: Lottie.asset(
                      "assets/animations/failed.zip"
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(errorHeader, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                const SizedBox(
                  height: 10,
                ),
                Text(message)
              ],
            ),
          ),
        );
      }
    );
  }

  Future<dynamic> displaySuccessModal(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context){
        return  Center(
          child: Lottie.asset(
              "assets/animations/success.zip"
          ),
        );
      }
    );
  }

  Future<dynamic> displayLoadingModal(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          content: SizedBox(
            height: 200,
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(
                  height: 120,
                  child: Lottie.asset(
                      "assets/animations/loading.json"
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text("Please wait...", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              ],
            ),
          ),
        );
      }
    );
  }

  AppBar applicationbar(BuildContext context, String title) {
    // final session = Provider.of<UserProvider>(context, listen: false);

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Center(child: Text(title, style: const TextStyle(color: kPrimaryColor),)),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: kPrimaryColor,),
        onPressed: (){
          // _scaffoldKey.currentState!.openDrawer();
        },
      )
    );
  }

  badges.Badge showBadge(String status, Color badgeColor) {
    return badges.Badge(
      badgeContent: Text(
        status,
      ),
      badgeStyle: badges.BadgeStyle(
          badgeColor: badgeColor,
          shape: badges.BadgeShape.square,
          borderRadius: const BorderRadius.all(
              Radius.circular(20)
          )
      ),
    );
  }

  Future<dynamic> displaySuccessMessage(BuildContext context, String message) {
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          content: SizedBox(
            height: 200,
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(
                  height: 120,
                  child: Lottie.asset(
                      "assets/animations/success.zip"
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text("Success", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                const SizedBox(
                  height: 10,
                ),
                Text(message)
              ],
            ),
          ),
        );
      }
    );
  }

  Future<dynamic> displayToast(BuildContext context, String message, Color backgroundColor, Color textColor) {
    return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP_RIGHT,
      timeInSecForIosWeb: 1,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: 16.0,
    );
  }

  String obscurePhoneNumber(String phoneNumber) {
    // Ensure the phone number is long enough
    
    phoneNumber = phoneNumber.trim();

    // Get the first two and the last digits
    String firstTwoDigits = phoneNumber.substring(0, 4);
    String lastDigit = phoneNumber.substring(phoneNumber.length - 1);

    // Create a string of asterisks of the appropriate length
    String obscuredPart = '*' * (phoneNumber.length - 5);

    // Combine the parts
    return firstTwoDigits + obscuredPart + lastDigit;
  }
  
  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  Container displayBadge(Color color, String statusText) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10), // Match the container's border radius
          bottomLeft: Radius.circular(10),
        ),
      ),
      child: Text(
        statusText,
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  String removeLastLetter(String str) {
    if (str.isNotEmpty) {
      return str.substring(0, str.length - 1);
    }
    return str; // Return the original string if it's empty
  }

}