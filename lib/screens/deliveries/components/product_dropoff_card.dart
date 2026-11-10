import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../components/dynamic_widgets.dart';
import '../../../modals/delivery_modal.dart';
import '../../../providers/user_provider.dart';
import '../../../services/api_services.dart';
import 'package:provider/provider.dart';

class ProductDropOffCard extends StatefulWidget {
  final DeliveryModal deliveryModal;
  const ProductDropOffCard({super.key, required this.deliveryModal});

  @override
  State<ProductDropOffCard> createState() => _ProductDropOffCardState();
}

class _ProductDropOffCardState extends State<ProductDropOffCard> {
  ApiService apiService = ApiService();
  DynamicMaster dynamicMaster = DynamicMaster();
  UserProvider session = UserProvider();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      session = Provider.of<UserProvider>(context, listen: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print(widget.deliveryModal.status);
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/delivery_details',
          arguments: widget.deliveryModal.id,
        );
      },
      child: SizedBox(
        height: size.height * 0.25,
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
                  border: Border(
                    bottom: BorderSide(
                      color: widget.deliveryModal.status == "delivered"
                          ? Colors.green
                          : widget.deliveryModal.status == "loaded"
                          ? Colors.orange
                          : Colors.red,
                      width: 3,
                    ),
                  ),
                  // borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withOpacity(0.3),
                      offset: const Offset(-10.0, 10.0),
                      blurRadius: 20.0,
                      spreadRadius: 4.0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(height: size.height * 0.01),
                    Text(
                      "Order ID: ${widget.deliveryModal.invoiceNo}",
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
                    Text(
                      "Customer Phone: ${widget.deliveryModal.customerPhoneNo}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Text(
                      "Order Date: ${DateFormat('dd-MMMM-yyyy').format(DateTime.parse(widget.deliveryModal.createdAt))}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Column(
                      children: [
                        const Text(
                          "Delivery Location: ",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.deliveryModal.deliveryLocation,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: widget.deliveryModal.status == "delivered"
                        ? Colors.green
                        : widget.deliveryModal.status == "loaded"
                        ? Colors.orange
                        : Colors.red,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(
                        10,
                      ), // Match the container's border radius
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: Text(
                    widget.deliveryModal.status,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
