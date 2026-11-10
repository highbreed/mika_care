import 'package:flutter/material.dart';
import '../../../components/bottom_navigator.dart';
import '../../../components/dynamic_widgets.dart';
import 'components/delivery_details_body.dart';

class DeliveryDetailsScreen extends StatefulWidget {
  final int deliveryId;
  const DeliveryDetailsScreen({super.key, required this.deliveryId});

  @override
  State<DeliveryDetailsScreen> createState() => _DeliveryDetailsScreenState();
}

class _DeliveryDetailsScreenState extends State<DeliveryDetailsScreen> {
  DynamicMaster dynamicMaster = DynamicMaster();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: dynamicMaster.applicationbar(context, "Delivery Details"),
      body: DeliveryDetailsBody(deliveryId: widget.deliveryId,),
      bottomNavigationBar: const BottomNavigator(currentIndex: 1,),
    );
  }
}