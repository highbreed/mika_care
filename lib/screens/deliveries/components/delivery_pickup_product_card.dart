import 'package:flutter/material.dart';
import '../../../components/dynamic_widgets.dart';
import '../../../modals/delivery_products_modal.dart';

class DeliveryPickUpProductCard extends StatefulWidget {
  final DeliveryProductsModal deliveryModal;
  const DeliveryPickUpProductCard({super.key, required this.deliveryModal});

  @override
  State<DeliveryPickUpProductCard> createState() =>
      _DeliveryPickUpProductCardState();
}

class _DeliveryPickUpProductCardState extends State<DeliveryPickUpProductCard> {
  DynamicMaster dynamicMaster = DynamicMaster();

  Future<String> fetchItemImage() async {
    // Simulate a delay to represent the time it takes to fetch the image
    await Future.delayed(const Duration(seconds: 2));

    // Replace this with your actual logic to fetch the image URL
    // For demonstration purposes, returning a dummy image URL
    return 'https://example.com/your_image.jpg';
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      // height: size.height * 0.3,
      // width: double.infinity,
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
          ),
        ],
      ),
      child: Stack(
        children: [
          SizedBox(height: size.height * 0.03),
          Container(
            height: size.height * 0.3,
            // width: size.width * 0.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                fit: BoxFit.fill,
                image:
                    (widget.deliveryModal.itemImage != null &&
                        widget.deliveryModal.itemImage!.isNotEmpty)
                    ? NetworkImage(widget.deliveryModal.itemImage!)
                    : const AssetImage(
                            'assets/images/empty_image_placeholder.png',
                          )
                          as ImageProvider,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: size.height * 0.3),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                SizedBox(height: size.height * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Order NO: ${widget.deliveryModal.invoiceNo}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Quantity: ${widget.deliveryModal.deliveryQuantity}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.01),
                Text(
                  "Model: ${widget.deliveryModal.modelNo}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Text(
                  "Item Group: ${widget.deliveryModal.itemGroup ?? 'N/A'}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Text(
                  "Customer Name: ${widget.deliveryModal.customerName}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: size.height * 0.01),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: const BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(
                    10,
                  ), // Match the container's border radius
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Text(
                "Pending: ${widget.deliveryModal.deliveryQuantity - widget.deliveryModal.serialNumbers.length}",
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: dynamicMaster.displayBadge(
              widget.deliveryModal.isSkipped
                  ? Colors.red
                  : widget.deliveryModal.serialNumbers.isEmpty
                  ? Colors.amber
                  : Colors.green,
              widget.deliveryModal.isSkipped
                  ? "Skipped"
                  : widget.deliveryModal.serialNumbers.isEmpty
                  ? "Pending: ${widget.deliveryModal.deliveryQuantity}"
                  : "Picked: ${widget.deliveryModal.serialNumbers.length}",
            ),
          ),
        ],
      ),
    );
  }
}
