import 'package:flutter/material.dart';
import '../../../components/dynamic_widgets.dart';
import '../../../modals/route_details_modal.dart';

class DeliveryRouteDetailsInvoiceCard extends StatefulWidget {
  final DeliveryOrder deliveryItems;
  const DeliveryRouteDetailsInvoiceCard({super.key, required this.deliveryItems});

  @override
  State<DeliveryRouteDetailsInvoiceCard> createState() => _DeliveryRouteDetailsInvoiceCardState();
}

class _DeliveryRouteDetailsInvoiceCardState extends State<DeliveryRouteDetailsInvoiceCard> {
  DynamicMaster dynamicMaster = DynamicMaster();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      // height: size.height * 0.15,
      width: double.infinity,
      margin: EdgeInsets.only(top: size.height * 0.02, left: size.width * 0.03, right: size.width * 0.03),
      child: Stack(
        children: [
          Container(
            // height: size.height * 0.15,
            width: double.infinity,
            padding: EdgeInsets.all(size.width * 0.03),
            decoration:  BoxDecoration(
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
            child: Row(
              children: [
                SizedBox(width: size.width * 0.03,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size.width * 0.59,
                      child: Text(
                        "Invoice No: ${widget.deliveryItems.invoiceNumber}",
                        softWrap: true,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold 
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.01,),
                    Row(
                      children: [
                        const Text(
                          "Customer Name: ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold 
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.45,
                          child: Text(
                            widget.deliveryItems.customerName,
                            softWrap: true,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold 
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.01,),
                    Text(
                      "Customer Phone: ${widget.deliveryItems.customerPhoneNo}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold 
                      ),
                    ),
                    SizedBox(height: size.height * 0.01,),
                    Text(
                      "Loading Sequency: ${widget.deliveryItems.loadingSequency}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold 
                      ),
                    ),
                    SizedBox(height: size.height * 0.01,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Status: ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold 
                          ),
                        ),
                        SizedBox(width: size.width * 0.3,),
                        dynamicMaster.showBadge(widget.deliveryItems.invoiceStatus, widget.deliveryItems.invoiceStatus == "pending" || widget.deliveryItems.invoiceStatus == "cancelled" ? Colors.red : widget.deliveryItems.invoiceStatus == "loaded" ? Colors.yellowAccent :  Colors.green)
                      ],
                    ),
                    SizedBox(height: size.height * 0.01,),
                    Row(
                      children: [
                        const Text(
                          "Delivery Location: ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold 
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.4,
                          child: Text(
                            widget.deliveryItems.deliveryLocation,
                            softWrap: true,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold 
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      )
    );
  }
}