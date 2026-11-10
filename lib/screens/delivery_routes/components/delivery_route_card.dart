import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../modals/route_modal.dart';

class DeliveryRouteCard extends StatefulWidget {
  final RouteModal routeObject;
  const DeliveryRouteCard({super.key, required this.routeObject});

  @override
  State<DeliveryRouteCard> createState() => _DeliveryRouteCardState();
}

class _DeliveryRouteCardState extends State<DeliveryRouteCard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: (){
        Navigator.pushNamed(
          context, 
          '/delivery_route_details', 
          arguments: widget.routeObject.id
        );
      
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          alignment: Alignment.topRight, // Align the badge to the top right
          children: [
            Container(
              width: double.infinity,
              // height: size.height * 0.15,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(0.3),
                    offset: const Offset(-10.0, 10.0),
                    blurRadius: 20.0,
                    spreadRadius: 4.0,
                  )
                ],
              ),
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.01),
                  Text(
                    "Route Name: ${widget.routeObject.routeName}", 
                    style: const TextStyle(
                      color: Colors.black, 
                      fontSize: 16, 
                      fontWeight: FontWeight.bold
                    )
                  ),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Route Date: ${DateFormat('dd-MMMM-yyyy').format(widget.routeObject.routeDate)}", 
                        style: const TextStyle(
                          color: Colors.black, 
                          fontSize: 16, 
                          fontWeight: FontWeight.bold
                        )
                      ),
                      Text(
                        "Vehicle : ${widget.routeObject.plateNumber}", 
                        style: const TextStyle(
                          color: Colors.black, 
                          fontSize: 16, 
                          fontWeight: FontWeight.bold
                        )
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Total Deliveries : ${widget.routeObject.totalDeliveries}", 
                        style: const TextStyle(
                          color: Colors.black, 
                          fontSize: 16, 
                          fontWeight: FontWeight.bold
                        )
                      ),
                      Text(
                        "Delivered : ${widget.routeObject.delivered}", 
                        style: const TextStyle(
                          color: Colors.black, 
                          fontSize: 16, 
                          fontWeight: FontWeight.bold
                        )
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  Text(
                    "Pending  : ${widget.routeObject.totalDeliveries! - widget.routeObject.delivered}", 
                    style: const TextStyle(
                      color: Colors.black, 
                      fontSize: 16, 
                      fontWeight: FontWeight.bold
                    )
                  ),
                  SizedBox(height: size.height * 0.01),
                ],
              ),
            ),
            // Badge Widget
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color:widget.routeObject.status == "pending" ? Colors.red :  Colors.green,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10), // Match the container's border radius
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: Text(
                  widget.routeObject.status,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}