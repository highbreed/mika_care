import 'package:flutter/material.dart';
import '../../../modals/delivery_details_modal.dart';

class DeliveryDetailsProductCard extends StatefulWidget {
  final DeliveryItem deliveryItems;
  const DeliveryDetailsProductCard({super.key, required this.deliveryItems});

  @override
  State<DeliveryDetailsProductCard> createState() => _DeliveryDetailsProductCardState();
}

class _DeliveryDetailsProductCardState extends State<DeliveryDetailsProductCard> {
  
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
                Container(
                  height: size.height * 0.1,
                  width: size.width * 0.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image:  DecorationImage(
                      fit: BoxFit.fill,
                      image: widget.deliveryItems.itemImage != '' ? NetworkImage(widget.deliveryItems.itemImage) : const AssetImage('assets/images/empty_image_placeholder.png') as ImageProvider,
                    )
                  ),
                ),
                SizedBox(width: size.width * 0.03,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size.width * 0.59,
                      child: Text(
                        widget.deliveryItems.modelNo,
                        softWrap: true,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold 
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.01,),
                    Text(
                      widget.deliveryItems.itemGroup,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold 
                      ),
                    ),
                    SizedBox(height: size.height * 0.01,),
                    Text(
                      "Delivery Qty: ${widget.deliveryItems.deliveryQuantity.toString()}",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.green,
                        fontWeight: FontWeight.bold 
                      ),
                    ),
                    SizedBox(height: size.height * 0.01,),
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