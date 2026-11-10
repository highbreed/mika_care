// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../../../components/dynamic_widgets.dart';
import '../../../components/rounded_buttons.dart';
import '../../../constants/main_constants.dart';
import '../../../modals/aftersale_product_pickup_modal.dart';
import '../../../modals/warehouse_modal.dart';
import '../../../providers/user_provider.dart';
import 'aftersales_delivery_card.dart';
import '../../../services/api_services.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AfterSaleDeliveryBody extends StatefulWidget {
  const AfterSaleDeliveryBody({super.key});

  @override
  State<AfterSaleDeliveryBody> createState() => _AfterSaleDeliveryBodyState();
}

class _AfterSaleDeliveryBodyState extends State<AfterSaleDeliveryBody> {
  final PageController _pageController = PageController();
  ApiService apiService = ApiService();
  DynamicMaster dynamicMaster = DynamicMaster();
  UserProvider userProvider = UserProvider();

  bool isLoading = false;
  List<AfterSalePickUpProductModal> productDeliveryList = [];
  List<Map<String, dynamic>> deliveryItemsScanned = [];
  DateTime currentDate = DateTime.now();

  String btmBtnText = "Scan Product";
  bool isLastPage = false;
  int totalProducts = 0;
  int totalProductsPicked = 0;

  
  TextEditingController selectedWarehouseInputController = TextEditingController();
  bool warehouseHasError = false;
  
  List<WarehouseModal> warehouseDropDownItems = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      userProvider = Provider.of<UserProvider>(context, listen: false);
    });
    _fetchData();
  }


  Future<void> confirmSubmission() async{
    selectedWarehouseInputController.clear();
    Size size = MediaQuery.of(context).size;
    
    IconButton closeButtonWidget = IconButton(
      onPressed: (){
        Navigator.of(context).pop();
      },
      icon: const Icon(
        Icons.clear,
        size: 30,
        // color: ,
      )
    );

    return showDialog(
      context: context, 
      builder: (BuildContext context ){
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState){
            return Dialog(
              child: Container(
                height: size.height * 0.5,
                width: size.width,
                padding: EdgeInsets.only(top: size.height * 0.03, left: size.width * 0.03, right: size.width * 0.03),
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
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: "Confirm Submission",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            )
                          )
                        ]
                      )
                    ),
                    const Divider(
                      height: 10,
                      thickness: 1,
                    ),
                    SizedBox(
                      height: size.height * 0.3,
                      child: Column(
                        children: [
                          SizedBox(height: size.height * 0.01,),
                          const Text(
                            "Are you sure you want to submit?",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                            )
                          ),
                          SizedBox(height: size.height * 0.01,),
                          const Text(
                            "Kindly confirm that you have scanned all serial numbers for all products",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                            )
                          ),
                          SizedBox(height: size.height * 0.01,),                          
                          Text(
                            "Total Products: ${productDeliveryList.length}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                            )
                          ),
                          SizedBox(height: size.height * 0.01,),
                          Text(
                            "Products Picked: $totalProductsPicked",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                            )
                          ),
                          SizedBox(height: size.height * 0.01,),
                          const Text(
                            "This action cannot be undone",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 13,
                            )
                          ),
                          SizedBox(height: size.height * 0.01,),
                          
                          Row(
                            children: [
                              const Text("Warehouse:", style: TextStyle(fontWeight: FontWeight.bold),),
                              SizedBox(width: size.width * 0.009,),
                              const Text("*", style: TextStyle(color: kRedColor),),
                            ],
                          ),
                          SizedBox(height: size.height * 0.005,),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: warehouseHasError ? Colors.red : Colors.grey,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: DropdownButton<String>(
                              items: warehouseDropDownItems.map((item) {
                                return DropdownMenuItem<String>(
                                  value: item.code,
                                  child: Text(item.name),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if(value!.isNotEmpty){
                                  setState(() {
                                    warehouseHasError = false;
                                    selectedWarehouseInputController.text = value;
                                  });
                                }else{
                                  warehouseHasError = true;
                                  selectedWarehouseInputController.clear();
                                }
                              },
                              value: selectedWarehouseInputController.text.isEmpty ? null : selectedWarehouseInputController.text,
                              isExpanded: true,
                              hint: const Text('Select Status of Warranty', style: TextStyle(color: kPrimaryColor),),
                              style: const TextStyle( //te
                                  color: Colors.black, //Font color
                                  fontSize: 15 //font size on dropdown button
                              ),
                              padding: const EdgeInsets.only(left: 9.0, right: 9.0),
                              underline: Container()
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            // primary: kRedColor,
                          ),
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: (){
                            if(selectedWarehouseInputController.text.isEmpty){
                              setState(() {
                                warehouseHasError = true;
                              });
                              // dynamicMaster.displayError(context, "Error", "Kindly select a warehouse");
                              return;
                            }else{
                              setState(() {
                                warehouseHasError = false;
                              });
                              Navigator.of(context).pop();
                              submitProducts();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            // primary: kBlueColor,
                          ),
                          child: const Text("Submit"),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      }
    );
  }

  Future<void> submitProducts() async{
    dynamicMaster.displayLoadingModal(context);


    if(deliveryItemsScanned.isNotEmpty){
      try {

        var response = await apiService.submitAfterSalesProductDropOff(
          {
            "token": context.read<UserProvider>().user!.token,
            "driverId": context.read<UserProvider>().user!.userId,
            "deliveryItems": deliveryItemsScanned,
            "warehouse": selectedWarehouseInputController.text,
          }
        );

        if (response["status"] == "success") {
          Navigator.of(context).pop();
          dynamicMaster.displaySuccessMessage(context, response["message"]);

          // Delay for 2 seconds
          await Future.delayed(const Duration(seconds: 2));

          Navigator.of(context).pushReplacementNamed('/aftersales_screen');
        } else {
          Navigator.of(context).pop();
          dynamicMaster.displayError(context, "Error", response["message"]);
        }
      } catch (error) {
        Navigator.of(context).pop();
        dynamicMaster.displayError(context, "Error", error.toString());
      }
    }else{
      Navigator.of(context).pop();
      dynamicMaster.displayError(context, "Error", "Kindly scan serial numbers before submitting");
    }
  }
  
  Future<void> nextPage() async{
    await _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    int currentPageIndex = _pageController.page?.round() ?? 0;

    if(currentPageIndex == productDeliveryList.length - 1){
      setState(() {
        isLastPage = true;
      });
    }else{
      setState(() {
        isLastPage = false;
      });
    }
    refreshScreen();
  }

  Future<void> refreshScreen() async{
    int currentPageIndex = _pageController.page?.round() ?? 0;

    int mintotalProductsPicked = 0;
    int currentProductPickedSerialNo = 0;

    if(deliveryItemsScanned.isNotEmpty){
      for (var product in deliveryItemsScanned) {
        if(product.containsKey(productDeliveryList[currentPageIndex].complaintNo)){
          currentProductPickedSerialNo += 1;
          // for (var serialNumber in product.values) {
          //   currentProductPickedSerialNo += 1;
          // }
        }
        mintotalProductsPicked += 1;
        // for (var serialNumber in product.values) {
        //   mintotalProductsPicked += 1;
        // }
      }
    }

    if(isLastPage && currentProductPickedSerialNo ==  1){
      btmBtnText = "Finish";
    }else{
      btmBtnText = "Scan Product";
    }
    setState(() {
      totalProductsPicked = mintotalProductsPicked;
      btmBtnText = btmBtnText;
    });
  }
  
  Future<void> scanProduct(AfterSalePickUpProductModal product) async {
    Size size = MediaQuery.of(context).size;

    // if(isLastPage && product.isSkipped == true || isLastPage && btmBtnText == "Finish"){
    //   deliveryComplete();
    //   return;
    // }else{
      IconButton closeButtonWidget = IconButton(
        onPressed: (){
          Navigator.of(context).pop();
        },
        icon: const Icon(
          Icons.clear,
          size: 30,
          // color: ,
        )
      );
      return showDialog(
        context: context, 
        builder: (BuildContext context ){
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState){
              return Dialog(
                child: SizedBox(
                  height: size.height * 0.53,
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
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: "Deliver Products",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                              )
                            )
                          ]
                        )
                      ),
                      Text(
                        product.productModelNo,
                        style: const TextStyle(
                          color: Colors.black,
                          // fontSize: 20,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      const Divider(
                        height: 10,
                        thickness: 1,
                      ),
                      Container(
                        width: size.width * 0.8,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                          ),
                          color: kSecondaryColor2,
                          splashColor: Colors.white.withAlpha(100),
                          highlightColor: kSecondaryColor2,
                          onPressed: () async{

                            // String scannedSerialNumber = await FlutterBarcodeScanner.scanBarcode('#ff6666','Cancel',true,ScanMode.BARCODE,);
                            
                            final results = await BarcodeScanner.scan();

                            String scannedSerialNumber = results.rawContent;

                            if(scannedSerialNumber != "-1"){
                              if(product.serialNo == scannedSerialNumber){
                                if(deliveryItemsScanned.isEmpty){
                                  List<String> minSerialNumber = [];
                                  minSerialNumber.add(scannedSerialNumber);
                                  setState(() {
                                    deliveryItemsScanned.add({product.complaintNo : minSerialNumber});
                                  });
                                  // deliveryItemsScanned.add({product.itemCode : minSerialNumber});

                                  Fluttertoast.showToast(
                                    msg: "Success",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.TOP_RIGHT,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                  return;
                                }else{
                                  print("product: ${deliveryItemsScanned.toString()}");
                                  int index = deliveryItemsScanned.indexWhere((map) => map.containsKey(product.complaintNo));

                                  print("product id $index");

                                  if (index != -1) {
                                    if(deliveryItemsScanned[index][product.complaintNo]!.contains(scannedSerialNumber) == false){
                                      setState(() {
                                        deliveryItemsScanned[index][product.complaintNo]!.add(scannedSerialNumber);
                                      });
                                      // deliveryItemsScanned[index][product.itemCode]!.add(scannedSerialNumber);
                                    }else{
                                      Fluttertoast.showToast(
                                        msg: "Serial number already scanned",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.TOP_RIGHT,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );
                                      return;
                                    }
                                  }else{
                                    List<String> minSerialNumber = [];
                                    minSerialNumber.add(scannedSerialNumber);
                                    setState(() {
                                      deliveryItemsScanned.add({product.complaintNo : minSerialNumber});
                                    });
                                    // deliveryItemsScanned.add({product.itemCode : minSerialNumber});

                                    Fluttertoast.showToast(
                                      msg: "Success",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.TOP_RIGHT,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                    return;
                                  }
                                }
                              }else{
                                Fluttertoast.showToast(
                                  msg: "Serial number has not been marked for delivery",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.TOP_RIGHT,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                                return;
                              }
                            }else{
                              Fluttertoast.showToast(
                                msg: "Kindly scann a valid serial number or qrcode",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.TOP_RIGHT,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                              return;
                            }
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt),
                              Text("Scan Serial Number"),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: size.height * 0.3,
                            child: ListView.builder(
                              itemCount: 1,
                              itemBuilder: (BuildContext context, int index) {
                                int index2 = deliveryItemsScanned.indexWhere((map) => map.containsKey(product.complaintNo));
                                return Container(
                                  margin: EdgeInsets.only(top: size.height * 0.02),
                                  child: ListTile(
                                    tileColor: index2 == -1 ? Colors.amber : deliveryItemsScanned.isNotEmpty ? deliveryItemsScanned[index2].containsKey(product.complaintNo) ? deliveryItemsScanned[index2][product.complaintNo]!.contains(product.serialNo) ? Colors.green : Colors.amber : Colors.amber : Colors.amber,
                                    // tileColor: Colors.amber,
                                    leading: Text(
                                      "${index + 1}",
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold
                                      )
                                    ),
                                    title: Text(
                                      product.serialNo,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold
                                      )
                                    ),
                                    trailing: IconButton(
                                      onPressed: (){
                                        // setState(() {
                                        //   product.serialNumber.removeAt(index);
                                        // });
                                      }, 
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      )
                                    ),
                                  ),
                                );
                              },
                            )                          
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            color: kBlueColor,
                            splashColor: Colors.white.withAlpha(100),
                            highlightColor: kBlueColor,
                            onPressed: () {
                              int index2 = deliveryItemsScanned.indexWhere((map) => map.containsKey(product.complaintNo));
                              if(deliveryItemsScanned[index2].containsKey(product.complaintNo) && deliveryItemsScanned[index2][product.complaintNo]!.contains(product.serialNo)){
                                refreshScreen();
                                Navigator.of(context).pop();
                                dynamicMaster.displaySuccessMessage(context, "Product saved successfully");
                              }else{
                                dynamicMaster.displayError(context, "Error", "Kindly scan serial numbers before saving");
                              }
                            },
                            child: const Row(
                              children: [
                                Icon(Icons.save_as_outlined, color: Colors.white,),
                                SizedBox(width: 10,),
                                Text(
                                  "Save",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                  )
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      );
    // }
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
      Map<String, dynamic> queryParameters2 = {
        "token": context.read<UserProvider>().user!.token,
        "status": "active",
      };

      var response2 = await apiService.filterWarehouse(queryParameters2);

      if(response2["status"] == "success" && response2["data_obj"].length >= 1){
        for(var warehouse in response2["data_obj"]){
          WarehouseModal warehouseModal = warehouseModalFromJson(jsonEncode(warehouse));
          warehouseDropDownItems.add(warehouseModal);
        }
      }else{
        warehouseDropDownItems = [];
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

  Future<void> previousPage() async{
    await _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    int currentPageIndex = _pageController.page?.round() ?? 0;

    if(currentPageIndex == productDeliveryList.length - 1){
      setState(() {
        isLastPage = true;
      });
    }else{
      setState(() {
        isLastPage = false;
      });
    }
    refreshScreen();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
        gradient:  LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.orange.shade900,
              Colors.orange.shade600,
              Colors.orange.shade600,
              Colors.orange.shade400,
            ]
          )
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: size.height * 0.05,
                          width: size.height * 0.05,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50)
                          ),
                          padding: const EdgeInsets.all(2.5),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_outlined, 
                              // color: Colors.white,
                            ), 
                            onPressed: () { 
                              Navigator.pop(context);
                            },
                            iconSize: 20,
                          )
                        ),
                        const SizedBox(width: 30,),
                        Column(
                          children: [
                            const Text(
                              "AfterSale Dropoff",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            Text(
                              "Dropoff your item here", 
                              style: TextStyle(
                                color: Colors.grey[350], 
                                // fontSize: 20
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: size.height * 0.9,
                width: size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  )
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.7,
                      child: 
                      isLoading ?
                      const Center(
                        child: CircularProgressIndicator(
                          color: kPrimaryColor,
                        ),
                      ) :
                      productDeliveryList.isEmpty ?
                      const Center(
                        child: Text(
                          "No Data Found",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ) :
                      Column(
                        children: [
                          SizedBox(
                            height: size.height * 0.6,
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: productDeliveryList.length,
                              physics: const NeverScrollableScrollPhysics(),
                              onPageChanged: (index) {
                                // setState(() {
                                //   currentQuestionIndex = index;
                                // });
                              },
                              itemBuilder: (context, index) {
                                return AfterSalesDeliveryCard(afterSalePickUpProductModal: productDeliveryList[index],);
                              },
                            ),
                          ),
                          SizedBox(height: size.height * 0.03,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: (){
                                  previousPage();
                                }, 
                                icon: Icon(
                                  Icons.arrow_back_ios_outlined, 
                                  color: Colors.blue[700],
                                )
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: SmoothPageIndicator(
                                    controller: _pageController,
                                    count: productDeliveryList.length,
                                    effect: const WormEffect(),
                                    onDotClicked: (index) {
                                      _pageController.animateToPage(
                                        index,
                                        duration: const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: (){
                                  print(deliveryItemsScanned.toString());
                                  int currentPageIndex = _pageController.page?.round() ?? 0;
                                  if(deliveryItemsScanned.isNotEmpty){
                                    // bool containsKey = deliveryItemsScanned.any((map) => map.containsKey(productDeliveryList[currentPageIndex].complaintNo));
                                    if(deliveryItemsScanned.any((map) => map.containsKey(productDeliveryList[currentPageIndex].complaintNo))){
                                      
                                      Map<String, dynamic> resultMap = deliveryItemsScanned.firstWhere((map) => map.containsKey(productDeliveryList[currentPageIndex].complaintNo), orElse: () => {});

                                      // for (var serialNumber in productDeliveryList[currentPageIndex].serialNumber) {
                                        if(resultMap[productDeliveryList[currentPageIndex].complaintNo].contains(productDeliveryList[currentPageIndex].serialNo) == false){
                                          dynamicMaster.displayError(context, "Error", "Kindly scan all serial numbers before proceeding");
                                          return;
                                        }
                                      // }
                                      nextPage();
                                    }else{
                                      dynamicMaster.displayError(context, "Error", "Kindly scan serial numbers before proceeding");
                                    }
                                  }else{
                                    dynamicMaster.displayError(context, "Error", "Kindly scan serial numbers before proceeding");
                                  }
                                }, 
                                icon: Icon(
                                  Icons.arrow_forward_ios_outlined, 
                                  color: Colors.blue[700],
                                )
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                    Container(
                      height: size.height * 0.2,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xFF002FA7),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20),
                        child: Column(
                          children: [
                            SizedBox(height: size.height * 0.01,),
                            Text(
                              "Total Products: ${productDeliveryList.length}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox(height: size.height * 0.01,),
                            Text(
                              "Products Picked: $totalProductsPicked",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox(height: size.height * 0.01,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: size.width * 0.4,
                                  child: RoundedButton(
                                    btnText: "Skip Product", 
                                    press: (){
                                      // int currentPageIndex = _pageController.page?.round() ?? 0;
                                      // productSkipModal(products[currentPageIndex]);
                                    }, 
                                    btnColor: kPrimaryLightColor, 
                                    textColor: kRedColor
                                  ),
                                ),
                                SizedBox(
                                  width: size.width * 0.4,
                                  child: RoundedButton(
                                    btnText: btmBtnText, 
                                    press: (){
                                      int currentPageIndex = _pageController.page?.round() ?? 0;
                                      if(btmBtnText == "Finish"){
                                        confirmSubmission();
                                      }else{
                                        scanProduct(productDeliveryList[currentPageIndex]);
                                      }
                                    }, 
                                    btnColor: kPrimaryLightColor, 
                                    textColor: kSecondaryColor
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    )

                  ],
                ),

              )

            ],
          ),
        ),
      ),
    );
  }
}