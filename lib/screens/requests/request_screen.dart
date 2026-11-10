import 'package:flutter/material.dart';
import '../../components/bottom_navigator.dart';
import 'components/request_body.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: RequestScreenBody(),
      bottomNavigationBar: BottomNavigator(currentIndex: 3,),
    );
  }
}