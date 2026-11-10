import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../components/force_update_dialog.dart';
import '../../../components/rounded_buttons.dart';
import '../../../constants/main_constants.dart';
import '../../../services/api_services.dart';
import 'backgound.dart';

class WelcomeScreenBody extends StatefulWidget {
  const WelcomeScreenBody({super.key});

  @override
  State<WelcomeScreenBody> createState() => _WelcomeScreenBodyState();
}

class _WelcomeScreenBodyState extends State<WelcomeScreenBody> {
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _checkVersion();
  }

  Future<void> _checkVersion() async {
    final info = await PackageInfo.fromPlatform();
    final response = await _apiService.checkAppVersion(info.version);

    if (response["status"] == "update_required" && mounted) {
      ForceUpdateDialog.show(
        context,
        response["message"] ??
            "A new version is available. Please update to continue.",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WelcomeScreenBackground(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              "MIKA CARE",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/chat.svg",
              height: size.height * 0.45,
            ),
            SizedBox(height: size.height * 0.05),
            RoundedButton(
              btnColor: kPrimaryColor,
              btnText: 'LOGIN',
              press: () {
                Navigator.of(context).pushNamed('/login');
              },
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
