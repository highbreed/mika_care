import 'package:flutter/material.dart';
import 'aftersales_delivery_body.dart';

class AfterSalesDeliveryScreen extends StatefulWidget {
  const AfterSalesDeliveryScreen({super.key});

  @override
  State<AfterSalesDeliveryScreen> createState() => _AfterSalesDeliveryScreenState();
}

class _AfterSalesDeliveryScreenState extends State<AfterSalesDeliveryScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AfterSaleDeliveryBody(),
    );
  }
}