import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import '../../../components/dynamic_widgets.dart';
import '../../../modals/delivery_modal.dart';
import '../../../providers/user_provider.dart';
import 'product_dropoff_card.dart';
import '../../../services/api_services.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

class DeliveryList extends StatefulWidget {
  const DeliveryList({super.key});

  @override
  State<DeliveryList> createState() => _DeliveryListState();
}

class _DeliveryListState extends State<DeliveryList> {
  UserProvider session = UserProvider();
  ApiService apiService = ApiService();
  DynamicMaster dynamicMaster = DynamicMaster();

  DateTime currentDate = DateTime.now();

  List<DeliveryModal> deliveryList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      session = Provider.of<UserProvider>(context, listen: false);
    });
    _fetchData();
  }

  // Method to fetch data
  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
      deliveryList.clear(); // Clear existing data before fetching
    });
    try {
      // String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);
      final response = await apiService.filterDeliveries({
        'loadingSequencyDESC': true,
        "token": context.read<UserProvider>().user!.token,
        // "dateRange_filter_from": formattedDate,
        // "dateRange_filter_to": formattedDate,
      });

      if (response["status"] == "success" && response["data_obj"].length >= 1) {
        for (var product in response["data_obj"]) {
          if (product["status"] == "loaded" ||
              product["status"] == "delivered") {
            deliveryList.add(deliveryModalFromJson(jsonEncode(product)));
          }
        }
      } else {
        deliveryList = [];
      }
    } catch (error) {
      dynamicMaster.displayError(context, "Error", error.toString());
      deliveryList = [];
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
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : deliveryList.isNotEmpty
                  ? ListView.builder(
                      itemCount: deliveryList.length,
                      itemBuilder: (BuildContext context, int index) {
                        // Determine colors based on delivery status
                        Color indicatorColor =
                            deliveryList[index].status == "delivered"
                            ? Colors.green
                            : Colors.orange;
                        Color iconColor = Colors.white;
                        Color lineColor =
                            deliveryList[index].status == "delivered"
                            ? Colors.green.shade300
                            : Colors.orange.shade300;

                        return SizedBox(
                          height: size.height * 0.3,
                          child: TimelineTile(
                            alignment: TimelineAlign.manual,
                            lineXY: 0.1,
                            isFirst: index == 0,
                            isLast: index == deliveryList.length - 1,
                            indicatorStyle: IndicatorStyle(
                              width: 20,
                              height: 50,
                              color: indicatorColor,
                              padding: const EdgeInsets.all(6),
                              iconStyle: IconStyle(
                                color: iconColor,
                                iconData: Icons.check,
                              ),
                            ),
                            beforeLineStyle: LineStyle(
                              color: lineColor,
                              thickness: 2,
                            ),
                            endChild: ProductDropOffCard(
                              deliveryModal: deliveryList[index],
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(child: Text("No deliveries found.")),
            ),
          ],
        ),
      ),
    );
  }
}
