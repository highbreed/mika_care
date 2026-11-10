import 'package:flutter/material.dart';
import '../../../modals/complaint_modal.dart';
import 'aftersales_pickup_body.dart';

class AfterSalesPickupDetails extends StatefulWidget {
  final ComplaintModal complaintModal;
  const AfterSalesPickupDetails({super.key, required this.complaintModal});

  @override
  State<AfterSalesPickupDetails> createState() => _AfterSalesPickupDetailsState();
}

class _AfterSalesPickupDetailsState extends State<AfterSalesPickupDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AfterSalesPickUpBody(complaintModal: widget.complaintModal,),
    );
  }
}