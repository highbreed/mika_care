import 'package:flutter/material.dart';
import '../../../components/dynamic_widgets.dart';
import '../../../modals/delivery_details_modal.dart';

class DeliveryDropOffProductCard extends StatefulWidget {
  final DeliveryItem deliveryItem;
  const DeliveryDropOffProductCard({super.key, required this.deliveryItem});

  @override
  State<DeliveryDropOffProductCard> createState() => _DeliveryDropOffProductCardState();
}

class _DeliveryDropOffProductCardState extends State<DeliveryDropOffProductCard> {
  DynamicMaster dynamicMaster = DynamicMaster();
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
      child: Stack(
        children: [
          SizedBox(height: size.height * 0.03),
          Container(
            height: size.height * 0.4,
            // width: size.width * 0.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image:  DecorationImage(
                fit: BoxFit.fill,
                image: widget.deliveryItem.itemImage != '' ? NetworkImage(widget.deliveryItem.itemImage) : const AssetImage('assets/images/empty_image_placeholder.png') as ImageProvider,
              )
            ),
          ),
          Container(
            margin: EdgeInsets.only( top: size.height * 0.4),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                SizedBox(height: size.height * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Order Qty: ${widget.deliveryItem.deliveryQuantity}", 
                      style: const TextStyle(
                        color: Colors.black, 
                        fontSize: 16, 
                        fontWeight: FontWeight.bold
                      )
                    ),
                    Text(
                      "Loaded Qty: ${widget.deliveryItem.loadedQty}", 
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
                  "Model: ${widget.deliveryItem.modelNo}", 
                  style: const TextStyle(
                    color: Colors.black, 
                    fontSize: 16, 
                    fontWeight: FontWeight.bold
                  )
                ),
                SizedBox(height: size.height * 0.01),
                Text(
                  "Item Group: ${widget.deliveryItem.itemGroup}", 
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
        ],
      ),
    );
  }
}