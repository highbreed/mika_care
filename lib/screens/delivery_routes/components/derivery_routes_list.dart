import 'dart:convert';

import 'package:flutter/material.dart';
import '../../../components/dynamic_widgets.dart';
import '../../../modals/route_modal.dart';
import '../../../providers/user_provider.dart';
import 'delivery_route_card.dart';
import '../../../services/api_services.dart';
import 'package:provider/provider.dart';

class DeliveryRoutesList extends StatefulWidget {
  const DeliveryRoutesList({super.key});

  @override
  State<DeliveryRoutesList> createState() => _DeliveryRoutesListState();
}

class _DeliveryRoutesListState extends State<DeliveryRoutesList> {
  UserProvider session = UserProvider();
  ApiService apiService = ApiService();
  DynamicMaster dynamicMaster = DynamicMaster();
    // Get the current date
  DateTime currentDate = DateTime.now();

  List<RouteModal> routeList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      session = Provider.of<UserProvider>(context, listen: false);
    });
    _fetchData();
  }
  
  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {

      final response = await apiService.filterDeliveryRoutes({"status": "pending","token": context.read<UserProvider>().user!.token, "driverId" : context.read<UserProvider>().user!.userId});

      if (response["status"] == "success" && response["data_obj"].length >= 1) {
        print(response["data_obj"]);
        routeList = response["data_obj"].map<RouteModal>((data) => routeModalFromJson(jsonEncode(data))).toList();
      } else {
        routeList = [];
      }
    } catch (error) {
      dynamicMaster.displayError(context, "Error", error.toString());
      routeList = [];
    }

    isLoading = false;

    // Trigger a rebuild of the widget tree
    if (mounted) {
      setState(() {});
    }
  }
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      width: double.infinity,
      child: RefreshIndicator(
        onRefresh: _fetchData,
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.75,
              child: isLoading ? 
              const Center(
                child: CircularProgressIndicator(),
              ) : 
              routeList.isNotEmpty ? 
              ListView.builder(
                itemCount: routeList.length,
                itemBuilder: (BuildContext context, int index) {
                  return DeliveryRouteCard(routeObject: routeList[index]);
                },
              ) : 
              const Center(
                child: Text("No routes found."),
              ),
            ),
          ],
        ),
      )
    );
  }
}