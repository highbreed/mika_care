import 'package:flutter/material.dart';
import 'components/delivery_dropoff_body.dart';

class DeliveryDropOff extends StatefulWidget {
  final int deliveryId;
  const DeliveryDropOff({super.key, required this.deliveryId});

  @override
  State<DeliveryDropOff> createState() => _DeliveryDropOffState();
}

class _DeliveryDropOffState extends State<DeliveryDropOff> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DeliveryDropOffBody(deliveryId: widget.deliveryId,),
    );
  }
}