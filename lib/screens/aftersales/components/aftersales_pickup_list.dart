// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../components/dynamic_widgets.dart';
import '../../../constants/main_constants.dart';
import '../../../modals/aftersale_product_pickup_modal.dart';
import '../../../modals/complaint_modal.dart';
import '../../../providers/user_provider.dart';
import '../../../services/api_services.dart';
import 'package:provider/provider.dart';

class AftersalesPickupList extends StatefulWidget {
  const AftersalesPickupList({super.key});

  @override
  State<AftersalesPickupList> createState() => _AftersalesPickupListState();
}

class _AftersalesPickupListState extends State<AftersalesPickupList> {
  UserProvider session = UserProvider();
  ApiService apiService = ApiService();
  DynamicMaster dynamicMaster = DynamicMaster();

  
  DateTime currentDate = DateTime.now();
  bool isLoading = false;

  bool complaintNoHasError = false;
  TextEditingController complaintNoInputController = TextEditingController();

  List<AfterSalePickUpProductModal> productDeliveryList = [];
  
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
      productDeliveryList = [];
    });
    try {
      String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);
      Map<String, dynamic> queryParameters = {
        "token": context.read<UserProvider>().user!.token,
        "driverId": context.read<UserProvider>().user!.userId,
        "dateRange_filter_from": formattedDate,
        "dateRange_filter_to": formattedDate,
        "status" : "pending"
      };
      final response = await apiService.filterAfterSaleProductPickUp(queryParameters);

      if (response["status"] == "success" && response["data_obj"].length >= 1) {
        for(var product in response["data_obj"]){
          AfterSalePickUpProductModal productModal = afterSalePickUpProductModalFromJson(jsonEncode(product));
          productDeliveryList.add(productModal);
        }

      } else {
        productDeliveryList = [];
      }
    } catch (error) {
      dynamicMaster.displayError(context, "Error", error.toString());
      productDeliveryList = [];
    }

    isLoading = false;

    // Trigger a rebuild of the widget tree
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> aftersalePickUpModal() async {
    complaintNoInputController.clear();
    Size size = MediaQuery.of(context).size;
    IconButton closeButtonWidget = IconButton(onPressed: (){Navigator.of(context).pop();},icon: const Icon(Icons.clear,size: 30,));

    return showDialog(
      context: context, 
      builder: (BuildContext context){
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState){
            return Dialog(
              child: SingleChildScrollView(
                child: SizedBox(
                  height: size.height * 0.4,
                  width: size.width,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            "assets/images/mika.png",
                            height: size.height * 0.05,
                            width: size.width * 0.2,
                          ),
                          closeButtonWidget
                        ],
                      ),
                      const SizedBox(
                        height: 0,
                      ),
                      const Text(
                        "Product Pickup",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      const Text(
                        "Pick up the customer product",
                        style: TextStyle(
                          color: Colors.black,
                          // fontWeight: FontWeight.bold
                        )
                      ),
                      const Divider(
                        height: 10,
                        thickness: 1,
                      ),
                      Container(
                        height: size.height * 0.2,
                        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                        child: Column(
                          children: [
                            SizedBox(height: size.height * 0.01,),
                            Row(
                              children: [
                                const Text("Complaint No:", style: TextStyle(fontWeight: FontWeight.bold),),
                                SizedBox(width: size.width * 0.009,),
                                const Text("*", style: TextStyle(color: kRedColor),),
                              ],
                            ),
                            SizedBox(height: size.height * 0.005,),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: complaintNoHasError ? Colors.red : Colors.grey,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
                                  ),
                                  decoration: const InputDecoration(
                                      labelStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold
                                      ),
                                      hintText: "Enter Complaint Number",
                                      border:  InputBorder.none
                                  ),
                                  controller: complaintNoInputController,
                                  onChanged: (value){
                                    if(value.isNotEmpty){
                                      setState(() {
                                        complaintNoHasError = false;
                                      });
                                    }else{
                                      setState(() {
                                        complaintNoHasError = true;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: size.height * 0.02,),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: (){
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                // primary: Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                              ), 
                              child: const Text("Cancel"),
                            ),
                            ElevatedButton(
                              onPressed: (){
                                if(complaintNoInputController.text.isNotEmpty){
                                  Navigator.of(context).pop();
                                  fetchComplaintDetails(complaintNoInputController.text);
                                }else{
                                  setState(() {
                                    complaintNoHasError = true;
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                              ), 
                              child: const Text("Submit"),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ),
              ),
            );
          }
        );
      }
    );
  }

  Future<void> fetchComplaintDetails(String complaintNo) async{

    dynamicMaster.displayLoadingModal(context);

    try {
      final response = await apiService.getComplaintDetails(context.read<UserProvider>().user!.token, complaintNo);

      if (response["status"] == "success" && response["data"].length >= 1 ) {
        ComplaintModal complaintModal = complaintModalFromJson(jsonEncode(response["data"][0]));
        Navigator.of(context).pop();

        if(complaintModal.productStatus == "pending pickup"){
          Navigator.pushNamed(context, "/aftersales_pickup_details", arguments: complaintModal);
        }else{
          dynamicMaster.displayError(context, "Error", "Product is not ready for pickup");
        }
      } else {
        Navigator.of(context).pop();
        dynamicMaster.displayError(context, "Error", response["message"]);
      }
    } catch (error) {
      Navigator.of(context).pop();
      dynamicMaster.displayError(context, "Error", error.toString());
    }

  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      width: size.width,
      child: RefreshIndicator(
        onRefresh: _fetchData,
        child: Stack(
          children: [
            SizedBox(
              height: size.height * 0.84,
              width: size.width,
              child: isLoading ? 
              const Center(child: CircularProgressIndicator(),) : 
              productDeliveryList.isEmpty ?
              const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.warning_amber_rounded, size: 50, color: Colors.red,),
                    SizedBox(height: 10,),
                    Text("No Data Found", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),)
                  ],
                ),
              ) :
              ListView.builder(
                itemCount: productDeliveryList.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: size.height * 0.23,
                    margin: EdgeInsets.symmetric(horizontal: size.width * 0.02, vertical: size.height * 0.01),
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
                        Container(
                          height: size.height * 0.2,
                          width: size.width * 0.4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            image:  DecorationImage(
                              fit: BoxFit.fill,
                              image: productDeliveryList[index].productImage != '' ? NetworkImage(productDeliveryList[index].productImage) : const AssetImage('assets/images/empty_image_placeholder.png') as ImageProvider,
                            )
                          ),
                        ),
                        Positioned(
                          left: size.width * 0.42,
                          child: SizedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: size.height * 0.01),
                                Text(
                                  "Complaint No: ${productDeliveryList[index].complaintNo}", 
                                  style: const TextStyle(
                                    color: Colors.black, 
                                    fontSize: 16, 
                                    fontWeight: FontWeight.bold
                                  )
                                ),
                                SizedBox(height: size.height * 0.01),
                                Row(
                                  children: [
                                    Text(
                                      "Customer Name: ${productDeliveryList[index].customerName}", 
                                      style: const TextStyle(
                                        color: Colors.black, 
                                        fontSize: 16, 
                                        fontWeight: FontWeight.bold
                                      ),
                                      softWrap: true,
                                    ),
                                    Text(
                                      productDeliveryList[index].customerName, 
                                      style: const TextStyle(
                                        color: Colors.black, 
                                        fontSize: 16, 
                                        fontWeight: FontWeight.bold
                                      ),
                                      softWrap: true,
                                    ),
                                  ],
                                ),
                                SizedBox(height: size.height * 0.01),
                                Text(
                                  "Product Name: ${productDeliveryList[index].productName}", 
                                  style: const TextStyle(
                                    color: Colors.black, 
                                    fontSize: 16, 
                                    fontWeight: FontWeight.bold
                                  )
                                ),
                                SizedBox(height: size.height * 0.01),
                                Text(
                                  "Product Model No: ${productDeliveryList[index].productModelNo}", 
                                  style: const TextStyle(
                                    color: Colors.black, 
                                    fontSize: 16, 
                                    fontWeight: FontWeight.bold
                                  )
                                ),
                                SizedBox(height: size.height * 0.01),
                                Text(
                                  "Product Status: ${productDeliveryList[index].productStatus}", 
                                  style: const TextStyle(
                                    color: Colors.black, 
                                    fontSize: 16, 
                                    fontWeight: FontWeight.bold
                                  )
                                ),
                                SizedBox(height: size.height * 0.01),
                                Text(
                                  "Serial No: ${productDeliveryList[index].serialNo}", 
                                  style: const TextStyle(
                                    color: Colors.black, 
                                    fontSize: 16, 
                                    fontWeight: FontWeight.bold
                                  )
                                ),
                                SizedBox(height: size.height * 0.01),
                              ],
                            ),
                          )
                        )
                      ],
                    ),
                    
                  );
                },
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: FloatingActionButton(
                onPressed: () {
                  aftersalePickUpModal();
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => AddDelivery()));
                },
                backgroundColor: kPrimaryColor,
                child: const Icon(Icons.add),
              )
            ),
          ],
        ),
      ),
    );
  }
}