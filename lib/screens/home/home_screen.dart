import 'package:flutter/material.dart';
import '../../components/bottom_navigator.dart';
import '../../components/dynamic_widgets.dart';
import 'components/home_body.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DynamicMaster dynamicMaster = DynamicMaster();


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // appBar: dynamicMaster.applicationbar(context, "Home Screen"),
      body:  HomeScreenBody(),
      bottomNavigationBar: BottomNavigator(currentIndex: 0,),
    );
  }
}