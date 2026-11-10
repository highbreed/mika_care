// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../../../components/dynamic_widgets.dart';
import '../../../components/force_update_dialog.dart';
import '../../../components/rounded_buttons.dart';
import '../../../components/rounded_input_field.dart';
import '../../../components/rounded_password_field.dart';
import '../../../constants/main_constants.dart';
import '../../../modals/user_modal.dart';
import '../../../providers/user_provider.dart';
import '../../../screens/login/components/backgound.dart';
import '../../../services/api_services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class LoginScreenBody extends StatefulWidget {
  const LoginScreenBody({super.key});

  @override
  State<LoginScreenBody> createState() => _LoginScreenBodyState();
}

class _LoginScreenBodyState extends State<LoginScreenBody> {
  TextEditingController usernameFieldController = TextEditingController();
  TextEditingController passwordFieldController = TextEditingController();
  ApiService apiService = ApiService();
  DynamicMaster dynamicMaster = DynamicMaster();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  String appVersion = "";

  @override
  void initState() {
    super.initState();
    checkForUpdate();
  }

  Future<void> checkForUpdate() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = info.version;
    });
  }

  Future<void> updateFPMToken(String userToken) async {
    String? token = await messaging.getToken();
    if (token != null) {
      await apiService.submitFPMToken(userToken, token);
    }
  }

  Future<void> submitLoginData(String username, String password) async {
    dynamicMaster.displayLoadingModal(context);

    var response = await apiService.login(username, password, appVersion);

    if (response["status"] == "update_required") {
      Navigator.of(context).pop();
      ForceUpdateDialog.show(
        context,
        response["message"] ??
            "A new version is available. Please update to continue.",
      );
    } else if (response["status"] == "success" &&
        response["data_obj"] != null) {
      User userObj = userFromJson(jsonEncode(response["data_obj"]));

      await updateFPMToken(response["data_obj"]["token"]);

      Navigator.of(context).pop();

      Provider.of<UserProvider>(context, listen: false).login(userObj);

      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      Navigator.of(context).pop();
      dynamicMaster.displayError(context, "Login Failed", response["message"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return LoginScreenBackground(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("LOGIN", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: size.height * 0.01),
          Image.asset("assets/images/mika.png", width: size.width * 0.2),
          SizedBox(height: size.height * 0.03),
          RoundedInputField(
            hintText: 'Username',
            icon: Icons.person,
            controller: usernameFieldController,
          ),
          RoundedPasswordField(controller: passwordFieldController),
          SizedBox(height: size.height * 0.03),
          RoundedButton(
            btnText: "LOGIN",
            press: () {
              submitLoginData(
                usernameFieldController.text,
                passwordFieldController.text,
              );
              // if(usernameFieldController.text != '' && passwordFieldController.text != ''){

              //   dynamicMaster.displayLoadingModal(context);

              //   Map<String, dynamic> loginResults = await userLogin(usernameFieldController.text, passwordFieldController.text);

              //   Navigator.of(context).pop();

              //   if(loginResults["status"] == "success"){
              //     User user = User(username: loginResults["username"], email: loginResults["email"], token: loginResults["token"], firstName: loginResults["firstName"], lastName: loginResults["lastName"], fullName: loginResults["fullName"], role: loginResults["role"]);

              //     if(loginResults["user_reset_password"] == true){
              //       Navigator.pushReplacement(
              //         context, MaterialPageRoute(
              //           builder: (context) {
              //             return PasswordResetScreen(userObj: user,);
              //           }
              //         )
              //       );
              //     }else{
              //       Provider.of<UserProvider>(context, listen: false).login(user);

              //       Navigator.pushReplacement(
              //         context, MaterialPageRoute(
              //           builder: (context) {
              //             return HomePage(isFromLogingIn: true,);
              //           }
              //         )
              //       );
              //     }
              //   }else{
              //     dynamicMaster.displayError(context, "Login Failed", loginResults["message"]);

              //   }

              // }else{
              //   dynamicMaster.displayError(context, "Input: error", "Username and Password are required.");
              // }
            },
            btnColor: kPrimaryColor,
            textColor: Colors.white,
          ),
          SizedBox(height: size.height * 0.015),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('/forgot_password');
            },
            child: const Text(
              "Forgot Password?",
              style: TextStyle(
                color: kSecondaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(height: size.height * 0.02),
          Text("Version: $appVersion"),
        ],
      ),
    );
  }
}
