import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../components/dynamic_widgets.dart';
import '../../../components/rounded_buttons.dart';
import '../../../constants/main_constants.dart';
import '../../../modals/delivery_modal.dart';
import '../../../providers/user_provider.dart';
import 'delivery_card.dart';
import '../../../services/api_services.dart';
import 'package:provider/provider.dart';

class DeliveryPickUpList extends StatefulWidget {
  const DeliveryPickUpList({super.key});

  @override
  State<DeliveryPickUpList> createState() => _DeliveryPickUpListState();
}

class _DeliveryPickUpListState extends State<DeliveryPickUpList> {
  UserProvider session = UserProvider();
  ApiService apiService = ApiService();
  DynamicMaster dynamicMaster = DynamicMaster();
    // Get the current date
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

// Container(
//           height: 20.0, // Adjust the height of each step as needed
//           width: 10.0,  // Adjust the width of each step as needed
//           margin: EdgeInsets.symmetric(vertical: 4.0),
//           decoration: BoxDecoration(
//             color: index < currentStep ? Colors.blue : Colors.grey,
//             borderRadius: BorderRadius.circular(5.0),
//           ),
//         )
  // Method to fetch data
  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);
      final response = await apiService.filterDeliveries({'loadingSequencyASC': true, "status": "pending","token": context.read<UserProvider>().user!.token,"dateRange_filter_from": formattedDate,"dateRange_filter_to": formattedDate,});

      if (response["status"] == "success" && response["data_obj"].length >= 1) {
        deliveryList = response["data_obj"].map<DeliveryModal>((data) => deliveryModalFromJson(jsonEncode(data))).toList();
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
            SizedBox(
              height: size.height * 0.75,
              child: isLoading ? 
              const Center(
                child: CircularProgressIndicator(),
              ) : 
              deliveryList.isNotEmpty ? 
              ListView.builder(
                itemCount: deliveryList.length,
                itemBuilder: (BuildContext context, int index) {
                  return DeliveryCard(deliveryModal: deliveryList[index]);
                },
              ) : 
              const Center(
                child: Text("No deliveries found."),
              ),
            ),
            SizedBox(height: size.height * 0.01),
            deliveryList.isNotEmpty ?
            RoundedButton(
              btnText: "Load Deliveries", 
              press: (){
                Navigator.pushNamed(context, "/delivery_pickup");
              }, 
              btnColor: kSecondaryColor, 
              textColor: kPrimaryLightColor
            ) :
            const SizedBox(),
          ],
        ),
      )
    );
  }
}