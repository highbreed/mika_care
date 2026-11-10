import 'package:flutter/material.dart';
import '../../../components/bottom_navigator.dart';
import 'components/delivery_routes_screen_body.dart';

class DeliveryRouteScreen extends StatelessWidget {
  const DeliveryRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DeliveryRouteScreenBody(),
      bottomNavigationBar: BottomNavigator(currentIndex: 1,),
    );
  }
}