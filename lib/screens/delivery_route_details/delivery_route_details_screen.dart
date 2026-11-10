import 'package:flutter/material.dart';
import '../../../components/bottom_navigator.dart';
import '../../../components/dynamic_widgets.dart';
import 'components/delivery_route_details_body.dart';

class DeliveryRouteDetailsScreen extends StatefulWidget {
  final int routeId;
  const DeliveryRouteDetailsScreen({super.key, required this.routeId});

  @override
  State<DeliveryRouteDetailsScreen> createState() => _DeliveryRouteDetailsScreenState();
}

class _DeliveryRouteDetailsScreenState extends State<DeliveryRouteDetailsScreen> {
  DynamicMaster dynamicMaster = DynamicMaster();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: dynamicMaster.applicationbar(context, "Route Details"),
      body: DeliveryRouteDetailsScreenBody(routeId: widget.routeId,),
      bottomNavigationBar: const BottomNavigator(currentIndex: 1,),
    );
  }
}