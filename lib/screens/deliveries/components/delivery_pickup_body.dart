// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../components/dynamic_widgets.dart';
import '../../../components/rounded_buttons.dart';
import '../../../constants/main_constants.dart';
import '../../../modals/delivery_products_modal.dart';
import '../../../providers/user_provider.dart';
import 'delivery_pickup_product_card.dart';
import '../../../services/api_services.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DeliveryPickUpBody extends StatefulWidget {
  final int routeId;
  const DeliveryPickUpBody({super.key, required this.routeId});

  @override
  State<DeliveryPickUpBody> createState() => _DeliveryPickUpBodyState();
}

class _DeliveryPickUpBodyState extends State<DeliveryPickUpBody> {
  UserProvider session = UserProvider();
  ApiService apiService = ApiService();
  DynamicMaster dynamicMaster = DynamicMaster();

  final PageController _pageController = PageController();
  
  bool isLoading = false;
  DateTime currentDate = DateTime.now();

  
  int currentPage = 0;

  List<DeliveryProductsModal> products = [];

  String btmBtnText = "Scan Product";
  bool isLastPage = false;
  int totalProducts = 0;
  int totalProductsPicked = 0;
  
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
    });

    try {
      final response = await apiService.filterDeliveryProducts(
        {
          "withLoadingSequency": true, 
          "status": "pending",
          "token": context.read<UserProvider>().user!.token,
          "routeId": widget.routeId,
          "driverId" : context.read<UserProvider>().user!.userId,
        }
      );

      if (response["status"] == "success" && response["data_obj"].length >= 1) {
        List<DeliveryProductsModal> minProducts = [];

        for (var product in response["data_obj"]) {
          minProducts.add(deliveryProductsModalFromJson(jsonEncode(product)));
        }
        products = minProducts;

        for (var product in products) {
          totalProducts += product.deliveryQuantity;
        }
      } else {
        products = [];
      }
    } catch (error) {
      dynamicMaster.displayError(context, "Error", error.toString());
      products = [];
    }

    isLoading = false;

    // Trigger a rebuild of the widget tree
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> scanProduct(DeliveryProductsModal product) async {
    Size size = MediaQuery.of(context).size;

    if(isLastPage && product.serialNumbers.isNotEmpty || isLastPage && product.isSkipped == true){
      confirmSubmission();
      return;
    }else{
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
                              text: "Pick Up Product",
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
                        product.modelNo,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
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
                              borderRadius: BorderRadius.circular(20)),
                          color: kSecondaryColor2,
                          splashColor: Colors.white.withAlpha(100),
                          highlightColor: kSecondaryColor2,
                          onPressed: () async{

                            print("Serial numbers: ${product.serialNumbers.length}");
                            print("Delivery quantity: ${product.deliveryQuantity}");

                            if(product.deliveryQuantity > product.serialNumbers.length){
                            
                              // String scannedSerialNumber = await FlutterBarcodeScanner.scanBarcode('#ff6666','Cancel',true,ScanMode.BARCODE,);
                              final results = await BarcodeScanner.scan();

                              String scannedSerialNumber = results.rawContent;

                              if(scannedSerialNumber != "-1"){
                                if(product.serialNumbers.contains(scannedSerialNumber)){
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
                                }else{
                                  setState(() {
                                    product.serialNumbers.add(scannedSerialNumber);
                                    product.isSkipped = false;
                                  });
                                  refreshScreen();
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
                              }
                            }else{
                              Fluttertoast.showToast(
                                msg: "All serial numbers scanned",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.TOP_RIGHT,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
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
                            child: product.serialNumbers.isNotEmpty ?
                            ListView.builder(
                              itemCount: product.serialNumbers.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  leading: Text(
                                    "${index + 1}",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
                                    )
                                  ),
                                  title: Text(
                                    product.serialNumbers[index],
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
                                    )
                                  ),
                                  trailing: IconButton(
                                    onPressed: (){
                                      setState(() {
                                        product.serialNumbers.removeAt(index);
                                      });
                                    }, 
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    )
                                  ),
                                );
                              },
                            ) :
                            const Center(
                              child: Text("No serial numbers found. Kindly scan serial numbers."),
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
                              if(product.serialNumbers.isNotEmpty){
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

    }
  }

  Future<void> productSkipModal(DeliveryProductsModal product) async{
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
    bool commentsHasError = false;
    TextEditingController commentsController = TextEditingController();

    if(product.isSkipped){
      commentsController.text = product.comment;
    }

    return showDialog(
      context: context, 
      builder: (BuildContext context ){
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState){
            return Dialog(
              child: SizedBox(
                height: size.height * 0.43,
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
                            text: "Skip product",
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
                      product.modelNo,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      )
                    ),
                    const Divider(
                      height: 10,
                      thickness: 1,
                    ),
                    Container(
                      height: size.height * 0.18,
                      width: size.width * 0.8,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          SizedBox(height: size.height * .03,),
                          Row(
                            children: [
                              const Text("Remarks:", style: TextStyle(fontWeight: FontWeight.bold),),
                              SizedBox(width: size.width * 0.009,),
                              const Text("*", style: TextStyle(color: kRedColor),),
                            ],
                          ),
                          SizedBox(height: size.height * 0.005,),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: commentsHasError ? Colors.red : Colors.grey,
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
                                    hintText: "Enter Reason for skipping product",
                                    border:  InputBorder.none
                                ),
                                controller: commentsController,
                                onChanged: (value){
                                  if(value.isNotEmpty){
                                    setState(() {
                                      commentsHasError = false;
                                    });
                                  }else{
                                    setState(() {
                                      commentsHasError = true;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      )
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
                              // primary: kRedColor,
                            ), 
                            child: const Text("Cancel"),
                          ),
                          ElevatedButton(
                            onPressed: (){
                              if(commentsController.text.isNotEmpty){
                                setState(() {
                                  product.isSkipped = true;
                                  product.comment = commentsController.text;
                                });
                                
                                Navigator.of(context).pop();
                                dynamicMaster.displaySuccessMessage(context, "Product skipped successfully");
                                nextPage();
                                
                                refreshScreen();
                              }else{
                                setState(() {
                                  commentsHasError = true;
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              // primary: kBlueColor,
                            ), 
                            child: const Text("Save"),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    );
    

  }

  Future<void> refreshScreen() async{
    int mintotalProductsPicked = 0;
    for (var product in products) {
      print("Products picked: ${product.serialNumbers.length}");
      mintotalProductsPicked += product.serialNumbers.length;
    }
    print("Products picked 2: $mintotalProductsPicked");
    totalProductsPicked = mintotalProductsPicked;
    print("Products picked 3: $totalProductsPicked");
    int currentPageIndex = _pageController.page?.round() ?? 0;

    if(isLastPage && products[currentPageIndex].serialNumbers.isNotEmpty || isLastPage && products[currentPageIndex].isSkipped == true){
      btmBtnText = "Finish";
    }else{
      btmBtnText = "Scan Product";
    }
    setState(() {
      totalProductsPicked = mintotalProductsPicked;
      btmBtnText = btmBtnText;
    });
  }

  Future<void> confirmSubmission() async{
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
                height: size.height * 0.4,
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
                      height: size.height * 0.2,
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
                            "Total Products: $totalProducts",
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
                            Navigator.of(context).pop();
                            submitProducts();
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

    List<Map<String, dynamic>> productsToSubmit = [];

    for (var product in products) {
      if(product.serialNumbers.isNotEmpty){
        productsToSubmit.add({
          "id": product.id,
          "itemCode": product.itemCode,
          "serial_numbers": product.serialNumbers,
          "comment": product.comment,
          "is_skipped": product.isSkipped
        });
      }
    }

    if(productsToSubmit.isNotEmpty){
      try {
        var response = await apiService.submitProductsPicked({"token": context.read<UserProvider>().user!.token,"products": productsToSubmit,});

        if (response["status"] == "success") {
          Navigator.of(context).pop();
          dynamicMaster.displaySuccessMessage(context, "Products submitted successfully. Please wait redirecting");

          // Delay for 2 seconds
          await Future.delayed(const Duration(seconds: 2));

          Navigator.of(context).pushReplacementNamed('/delivery_screen');
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

    if(currentPageIndex == products.length - 1){
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

  Future<void> previousPage() async{
    await _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    int currentPageIndex = _pageController.page?.round() ?? 0;

    if(currentPageIndex == products.length - 1){
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
      width: double.infinity,
      decoration: BoxDecoration(
        gradient:  LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.blue.shade900,
              Colors.blue.shade600,
              Colors.blue.shade600,
              Colors.blue.shade400,
            ]
          )
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: size.height * 0.03,),
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
                              "Delivery Pick Up",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            Text(
                              "Load products to deliver", 
                              style: TextStyle(
                                color: Colors.grey[350], 
                                fontSize: 20
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // SizedBox(height: size.height * 0.033,),
              Container(
                height: size.height * 0.832,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  )
                ),
                child: isLoading ? 
                const Center(
                  child: CircularProgressIndicator(),
                ) :
                products.isEmpty ?
                const Center(
                  child: Text("No products found."),
                ) :
                Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.669,
                      child: Column(
                        children: [
                          SizedBox(
                            height: size.height * 0.5,
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: products.length,
                              physics: const NeverScrollableScrollPhysics(),
                              onPageChanged: (index) {
                                // setState(() {
                                //   currentQuestionIndex = index;
                                // });
                              },
                              itemBuilder: (context, index) {
                                return DeliveryPickUpProductCard(deliveryModal: products[index],);
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
                                    count: products.length,
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
                                  
                                  int currentPageIndex = _pageController.page?.round() ?? 0;
                            print("Serial numbers: ${products[currentPageIndex].serialNumbers.length}");
                            print("Delivery quantity: ${products[currentPageIndex].deliveryQuantity}");
                                  if(products[currentPageIndex].serialNumbers.isNotEmpty && products[currentPageIndex].deliveryQuantity >= products[currentPageIndex].serialNumbers.length && products[currentPageIndex].isSkipped == false){
                                   
                                    nextPage();
                                  }else if(products[currentPageIndex].isSkipped == true){
                                    nextPage();
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
                      height: size.height * 0.163,
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
                              "Total Products: $totalProducts",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox(height: size.height * 0.01,),
                            Text(
                              "Products Picked: ${products.where((element) => element.serialNumbers.isNotEmpty).length}",
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
                                      int currentPageIndex = _pageController.page?.round() ?? 0;
                                      productSkipModal(products[currentPageIndex]);
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
                                      scanProduct(products[currentPageIndex]);
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
              ),
            ],
          ),
        )
      ),
    );
  }
}