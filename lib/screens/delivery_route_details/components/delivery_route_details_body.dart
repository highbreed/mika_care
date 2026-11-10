import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../components/dynamic_widgets.dart';
import '../../../constants/main_constants.dart';
import '../../../modals/route_details_modal.dart';
import '../../../providers/user_provider.dart';
import 'delivery_route_details_invoice_card.dart';
import '../../../services/api_services.dart';
import 'package:provider/provider.dart';

class DeliveryRouteDetailsScreenBody extends StatefulWidget {
  final int routeId;
  const DeliveryRouteDetailsScreenBody({super.key, required this.routeId});

  @override
  State<DeliveryRouteDetailsScreenBody> createState() => _DeliveryRouteDetailsScreenBodyState();
}

class _DeliveryRouteDetailsScreenBodyState extends State<DeliveryRouteDetailsScreenBody> {
  DynamicMaster dynamicMaster = DynamicMaster();
  ApiService apiService = ApiService();
  UserProvider session = UserProvider();

  bool isLoading = false;

  RouteDetailsModal? routeDetails;

  List<Map<String, List<String>>> deliveryItemsScanned = [];

  @override
  void initState() {
    // TODO: implement initState
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
      var response = await apiService.getDeliveryRouteDetails(session.user!.token,  widget.routeId.toString());

      if (response["status"] == "success" && response["data_obj"] != null) {
        routeDetails = routeDetailsModalFromJson(jsonEncode(response["data_obj"]));
      }
    } catch (error) {
      dynamicMaster.displayError(context, "Error", error.toString());
    }
    isLoading = false;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: double.infinity,
      padding: EdgeInsets.only(left: size.width * 0.03, right: size.width * 0.03),
      child: isLoading ?
      const Center(
        child: CircularProgressIndicator(),
      ) :
      routeDetails == null ?
      const Center(
        child: Text("No data found"),
      ) :
      Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: size.height * 0.02,),
                Container(
                  // height: size.height * 0.22,
                  width: double.infinity,
                  padding: EdgeInsets.all(size.width * 0.03),
                  margin: EdgeInsets.only(left: size.width * 0.03, right: size.width * 0.03),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12.withOpacity(0.3),
                        offset: const Offset(-2.0, 2.0),
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: size.height * 0.01,),
                      Text(
                        "Route Name: ${routeDetails!.routeName}",
                        style: const TextStyle(
                          fontSize: 18,
                          // color: Colors.grey,
                          fontWeight: FontWeight.bold 
                        ),
                      ),
                      SizedBox(height: size.height * 0.01,),
                      Text(
                        "Date: ${DateFormat('dd-MMMM-yyyy').format(routeDetails!.routeDate)}",
                        style: const TextStyle(
                          fontSize: 18,
                          // color: Colors.grey,
                          fontWeight: FontWeight.bold 
                        ),
                      ),
                      SizedBox(height: size.height * 0.01,),
                      Text(
                        "Driver: ${routeDetails!.driverFullName}",
                        style: const TextStyle(
                          fontSize: 18,
                          // color: Colors.grey,
                          fontWeight: FontWeight.bold 
                        ),
                      ),
                      SizedBox(height: size.height * 0.01,),
                      Text(
                        "Vehicle: ${routeDetails!.plateNumber}",
                        style: const TextStyle(
                          fontSize: 18,
                          // color: Colors.grey,
                          fontWeight: FontWeight.bold 
                        ),
                      ),
                      SizedBox(height: size.height * 0.01,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Deliveries: ${routeDetails!.totalDeliveries}",
                            style: const TextStyle(
                              fontSize: 18,
                              // color: Colors.grey,
                              fontWeight: FontWeight.bold 
                            ),
                          ),
                          Text(
                            "Delivered: ${routeDetails!.totalDelivered}",
                            style: const TextStyle(
                              fontSize: 18,
                              // color: Colors.grey,
                              fontWeight: FontWeight.bold 
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.01,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Pending: ${routeDetails!.totalDeliveries - routeDetails!.totalDelivered}",
                            style: const TextStyle(
                              fontSize: 18,
                              // color: Colors.grey,
                              fontWeight: FontWeight.bold 
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color:routeDetails!.status == "pending" ? Colors.red :  Colors.green,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10), // Match the container's border radius
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                            child: Text(
                              routeDetails!.status,
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.02,),
                SizedBox(
                  height: size.height * 0.572,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Total Invoice (s): ",
                            style: TextStyle(
                              fontSize: 18,
                              // color: Colors.grey,
                              fontWeight: FontWeight.bold 
                            ),
                          ),
                          Text(
                            routeDetails!.deliveryOrders.length.toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.green,
                              fontWeight: FontWeight.bold 
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.01,),
                      Expanded(
                        // height:  size.height * 0.5,
                        child: ListView.builder(
                          itemCount: routeDetails!.deliveryOrders.length,
                          itemBuilder: (BuildContext context, int index) {                  
                            return DeliveryRouteDetailsInvoiceCard(deliveryItems: routeDetails!.deliveryOrders[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.01,),
                // RoundedButton(
                //   btnText: "Proceed to delivery", 
                //   press: (){
                //     deliveryComplete();
                //   }, 
                //   btnColor: kSecondaryColor, 
                //   textColor: kPrimaryLightColor
                // ),
                // routeDetails!.status == "loaded" ?
                // GradientSlideToAct(
                //   width: size.width * 0.7,
                //   dragableIconBackgroundColor: Colors.greenAccent,
                //   textStyle: const TextStyle(color: Colors.white,fontSize: 15),
                //   backgroundColor: kPrimaryColor,
                //   text: "Slide to complete delivery",
                //   onSubmit: (){
                //     // print(widget.deliveryId);
                //     // Navigator.of(context).pushNamed("/delivery_dropoff", arguments: widget.deliveryId);
                //   },
                //   gradient:  const LinearGradient(
                //       begin: Alignment.topLeft,
                //       end: Alignment.bottomRight,
                //       colors: [
                //       Color(0Xff11998E ), 
                //         Color(0Xff38EF7D), 
                //       ]
                //   ),
                // )
                // :
                // const SizedBox(),
                // SizedBox(height: size.height * 0.03,),
              ],
            ),
          ),
          Positioned(
            bottom: size.height * 0.02,
            right: size.width * 0.03,
            child: FloatingActionButton(
              onPressed: (){
                Navigator.pushNamed(context, "/delivery_pickup", arguments: widget.routeId);
              },
              backgroundColor: routeDetails!.status == "pending" ? kSecondaryColor : kPrimaryColor,
              tooltip: routeDetails!.status == "pending" ? "Start Loading Items" : "Route to delivery",
              child: Icon( routeDetails!.status == "pending" ?  Icons.hourglass_empty : Icons.local_shipping , color: Colors.white,),
            )
          )
        ],
      ),
    );
  }
}