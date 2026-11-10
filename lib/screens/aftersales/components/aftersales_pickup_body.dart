// ignore_for_file: use_build_context_synchronously

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../components/dynamic_widgets.dart';
import '../../../components/rounded_buttons.dart';
import '../../../constants/main_constants.dart';
import '../../../modals/complaint_modal.dart';
import '../../../providers/user_provider.dart';
import '../../../services/api_services.dart';
import 'package:provider/provider.dart';

class AfterSalesPickUpBody extends StatefulWidget {
  final ComplaintModal complaintModal;
  const AfterSalesPickUpBody({super.key, required this.complaintModal});

  @override
  State<AfterSalesPickUpBody> createState() => _AfterSalesPickUpBodyState();
}

class _AfterSalesPickUpBodyState extends State<AfterSalesPickUpBody> {
  ApiService apiService = ApiService();
  DynamicMaster dynamicMaster = DynamicMaster();
  UserProvider userProvider = UserProvider();

  bool isLoading = false;

  List<String> serialNumbers = [];
  String btmBtnText = "Scan Product";
  int totalProductsPicked = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      userProvider = Provider.of<UserProvider>(context, listen: false);
    });
  }

  
  Future<void> scanProduct() async {
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
                      widget.complaintModal.productModelNo,
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
                            borderRadius: BorderRadius.circular(20)),
                        color: kSecondaryColor2,
                        splashColor: Colors.white.withAlpha(100),
                        highlightColor: kSecondaryColor2,
                        onPressed: () async{
                          
                          // String scannedSerialNumber = await FlutterBarcodeScanner.scanBarcode('#ff6666','Cancel',true,ScanMode.BARCODE,);

                          
                          final results = await BarcodeScanner.scan();

                          String scannedSerialNumber = results.rawContent;

                          if(scannedSerialNumber != "-1"){
                            if(serialNumbers.contains(scannedSerialNumber)){
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
                                serialNumbers.add(scannedSerialNumber);
                                // product.isSkipped = false;
                              });
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
                          child: serialNumbers.isNotEmpty ?
                          ListView.builder(
                            itemCount: serialNumbers.length,
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
                                  serialNumbers[index],
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                  )
                                ),
                                trailing: IconButton(
                                  onPressed: (){
                                    setState(() {
                                      serialNumbers.removeAt(index);
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
                            if(serialNumbers.isNotEmpty){
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

  }

  Future<void> refreshScreen() async{
    if(serialNumbers.isNotEmpty){
      btmBtnText = "Submit";
    }else{
      btmBtnText = "Scan Product";
    }
    setState(() {
      totalProductsPicked = serialNumbers.length;
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
                          const Text(
                            "Total Products: 1",
                            style: TextStyle(
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


    if(serialNumbers.isNotEmpty){
      try {
        var response = await apiService.submitAfterSalesProductPickUp({"token": context.read<UserProvider>().user!.token,"complaintNo": widget.complaintModal.complaintNo, "serialNumber" : serialNumbers});

        if (response["status"] == "success") {
          Navigator.of(context).pop();
          dynamicMaster.displaySuccessMessage(context, "Products submitted successfully. Please wait redirecting");

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
                              "AfterSale Pick Up",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            Text(
                              "Load aftersales products", 
                              style: TextStyle(
                                color: Colors.grey[350], 
                                // fontSize: 20
                              ),
                            ),
                            
                            Text(
                              "Complaint No: ${widget.complaintModal.complaintNo}",
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
                      child: Column(
                        children: [
                          Container(
                            height: size.height * 0.675,
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
                                      image: widget.complaintModal.productImage != '' ? NetworkImage(widget.complaintModal.productImage) : const AssetImage('assets/images/empty_image_placeholder.png') as ImageProvider,
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
                                            "Complaint NO: ${widget.complaintModal.complaintNo}", 
                                            style: const TextStyle(
                                              color: Colors.black, 
                                              fontSize: 16, 
                                              fontWeight: FontWeight.bold
                                            )
                                          ),
                                          const Text(
                                            "Quantity: 1", 
                                            style: TextStyle(
                                              color: Colors.black, 
                                              fontSize: 16, 
                                              fontWeight: FontWeight.bold
                                            )
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: size.height * 0.01),
                                      Text(
                                        "Model: ${widget.complaintModal.productModelNo}", 
                                        style: const TextStyle(
                                          color: Colors.black, 
                                          fontSize: 16, 
                                          fontWeight: FontWeight.bold
                                        )
                                      ),
                                      SizedBox(height: size.height * 0.01),
                                      Text(
                                        "Item Group: ${widget.complaintModal.itemGroup}", 
                                        style: const TextStyle(
                                          color: Colors.black, 
                                          fontSize: 16, 
                                          fontWeight: FontWeight.bold
                                        )
                                      ),
                                      SizedBox(height: size.height * 0.01),
                                      Text(
                                        "Customer Name: ${widget.complaintModal.customerName}", 
                                        style: const TextStyle(
                                          color: Colors.black, 
                                          fontSize: 16, 
                                          fontWeight: FontWeight.bold
                                        )
                                      ),
                                      SizedBox(height: size.height * 0.01),
                                      Text(
                                        "Customer Email: ${widget.complaintModal.customerEmail}", 
                                        style: const TextStyle(
                                          color: Colors.black, 
                                          fontSize: 16, 
                                          fontWeight: FontWeight.bold
                                        )
                                      ),
                                      SizedBox(height: size.height * 0.01),
                                      Text(
                                        "Customer Phone: ${widget.complaintModal.customerMobile}", 
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

                          )
                        ],
                      )
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
                            const Text(
                              "Total Products: 1",
                              style: TextStyle(
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
                                      if(btmBtnText == "Submit"){
                                        confirmSubmission();
                                      }else{
                                        scanProduct();
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