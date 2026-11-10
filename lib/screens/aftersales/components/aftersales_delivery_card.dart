import 'package:flutter/material.dart';
import '../../../modals/aftersale_product_pickup_modal.dart';

class AfterSalesDeliveryCard extends StatefulWidget {
  final AfterSalePickUpProductModal afterSalePickUpProductModal;
  const AfterSalesDeliveryCard({super.key, required this.afterSalePickUpProductModal});

  @override
  State<AfterSalesDeliveryCard> createState() => _AfterSalesDeliveryCardState();
}

class _AfterSalesDeliveryCardState extends State<AfterSalesDeliveryCard> {
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
                image: widget.afterSalePickUpProductModal.productImage != '' ? NetworkImage(widget.afterSalePickUpProductModal.productImage) : const AssetImage('assets/images/empty_image_placeholder.png') as ImageProvider,
              )
            ),
          ),
          Container(
            margin: EdgeInsets.only( top: size.height * 0.4),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                SizedBox(height: size.height * 0.01),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Order Qty: 1", 
                      style: TextStyle(
                        color: Colors.black, 
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                      ),
                    ),
                    Text(
                      "Delivery Qty: 1", 
                      style: TextStyle(
                        color: Colors.black, 
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Model NO: ${widget.afterSalePickUpProductModal.productModelNo}", 
                      style: const TextStyle(
                        color: Colors.black, 
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Complaint NO: ${widget.afterSalePickUpProductModal.complaintNo}", 
                      style: const TextStyle(
                        color: Colors.black, 
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Customer Name: ${widget.afterSalePickUpProductModal.customerName}", 
                      style: const TextStyle(
                        color: Colors.black, 
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.01),
              ],
            ),
          )
        ],
      ),
    );
  }
}