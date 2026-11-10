import 'package:flutter/material.dart';
import '../../components/bottom_navigator.dart';
import '../../components/dynamic_widgets.dart';
import 'components/aftersales_body.dart';

class AfterSalesScreen extends StatefulWidget {
  const AfterSalesScreen({super.key});

  @override
  State<AfterSalesScreen> createState() => _AfterSalesScreenState();
}

class _AfterSalesScreenState extends State<AfterSalesScreen> {
  DynamicMaster dynamicMaster = DynamicMaster();
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // appBar: dynamicMaster.applicationbar(context, "Aftersales"),
      body: AftersalesBody(),
      bottomNavigationBar: BottomNavigator(currentIndex: 3,),
    );
  }
}