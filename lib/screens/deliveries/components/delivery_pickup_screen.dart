import 'package:flutter/material.dart';
import 'delivery_pickup_body.dart';

class DeliveryPickUpScreen extends StatefulWidget {
  final int routeId;
  const DeliveryPickUpScreen({super.key, required this.routeId});

  @override
  State<DeliveryPickUpScreen> createState() => _DeliveryPickUpScreenState();
}

class _DeliveryPickUpScreenState extends State<DeliveryPickUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DeliveryPickUpBody(routeId: widget.routeId,),
    );
  }
}