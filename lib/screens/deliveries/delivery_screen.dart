import 'package:flutter/material.dart';
import '../../../components/bottom_navigator.dart';
import 'components/delivery_body.dart';

class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({super.key});

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DeliveryBody(),
      bottomNavigationBar: BottomNavigator(currentIndex: 1,),
    );
  }
}