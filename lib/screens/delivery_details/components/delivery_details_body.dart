import 'dart:convert';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradient_slide_to_act/gradient_slide_to_act.dart';
import '../../../components/dynamic_widgets.dart';
import '../../../constants/main_constants.dart';
import '../../../modals/delivery_details_modal.dart';
import '../../../providers/user_provider.dart';
import 'delivery_details_card.dart';
import '../../../services/api_services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DeliveryDetailsBody extends StatefulWidget {
  final int deliveryId;
  const DeliveryDetailsBody({super.key, required this.deliveryId});

  @override
  State<DeliveryDetailsBody> createState() => _DeliveryDetailsBodyState();
}

class _DeliveryDetailsBodyState extends State<DeliveryDetailsBody> {
  DynamicMaster dynamicMaster = DynamicMaster();
  ApiService apiService = ApiService();
  UserProvider session = UserProvider();

  bool isLoading = false;

  DeliveryDetails? deliveryDetails;

  List<Map<String, List<String>>> deliveryItemsScanned = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      session = Provider.of<UserProvider>(context, listen: false);
    });
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      var response = await apiService.getDeliveryDetails(
        session.user!.token,
        widget.deliveryId.toString(),
      );

      if (response["status"] == "success" && response["data_obj"] != null) {
        deliveryDetails = deliveryDetailsFromJson(
          jsonEncode(response["data_obj"]),
        );
      }
    } catch (error) {
      dynamicMaster.displayError(context, "Error", error.toString());
    }
    isLoading = false;

    setState(() {});
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    String url = 'tel:$phoneNumber';
    final Uri phoneLaunchUri = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunchUrl(phoneLaunchUri)) {
      await launchUrl(phoneLaunchUri);
    } else {
      dynamicMaster.displayError(context, "Error", "Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: double.infinity,
      padding: EdgeInsets.only(
        left: size.width * 0.03,
        right: size.width * 0.03,
      ),
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : deliveryDetails == null
          ? const Center(child: Text("No data found"))
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Order No: ${deliveryDetails!.invoiceNumber}",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: size.height * 0.01),
                      const Text(
                        "Status: pending",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.02),
                  Container(
                    height: size.height * 0.22,
                    width: double.infinity,
                    padding: EdgeInsets.all(size.width * 0.03),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12.withOpacity(0.3),
                          offset: const Offset(-2.0, 2.0),
                          blurRadius: 10.0,
                          spreadRadius: 2.0,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Customer Contact Details",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        Text(
                          deliveryDetails!.customerName,
                          style: const TextStyle(
                            fontSize: 18,
                            // color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        Text(
                          deliveryDetails!.customerPhoneNumber,
                          style: const TextStyle(
                            // fontSize: 18,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        Text(
                          deliveryDetails!.deliveryLocation,
                          softWrap: true,
                          style: const TextStyle(
                            // fontSize: 18,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        Container(
                          padding: EdgeInsets.only(
                            left: size.width * 0.03,
                            right: size.width * 0.03,
                          ),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      // _makePhoneCall(deliveryDetails!.customerPhoneNumber);
                                      _makePhoneCall("0795112229");
                                    },
                                    icon: const Icon(
                                      Icons.call,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const Text(
                                    "Call",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: size.width * 0.1),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.pin_drop_outlined,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const Text(
                                    "Directions",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  SizedBox(
                    height: deliveryDetails!.status == "loaded"
                        ? size.height * 0.45
                        : size.height * 0.52,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "ITEM: ",
                              style: TextStyle(
                                fontSize: 18,
                                // color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              deliveryDetails!.deliveryItems.length.toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.01),
                        SizedBox(
                          height: deliveryDetails!.status == "loaded"
                              ? size.height * 0.4
                              : size.height * 0.48,
                          // color: Colors.red,
                          child: ListView.builder(
                            itemCount: deliveryDetails!.deliveryItems.length,
                            itemBuilder: (BuildContext context, int index) {
                              return DeliveryDetailsProductCard(
                                deliveryItems:
                                    deliveryDetails!.deliveryItems[index],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),
                  // RoundedButton(
                  //   btnText: "Proceed to delivery",
                  //   press: (){
                  //     deliveryComplete();
                  //   },
                  //   btnColor: kSecondaryColor,
                  //   textColor: kPrimaryLightColor
                  // ),
                  deliveryDetails!.status == "loaded"
                      ? GradientSlideToAct(
                          width: size.width * 0.7,
                          dragableIconBackgroundColor: Colors.greenAccent,
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                          backgroundColor: kPrimaryColor,
                          text: "Slide to complete delivery",
                          onSubmit: () {
                            print(widget.deliveryId);
                            Navigator.of(context).pushNamed(
                              "/delivery_dropoff",
                              arguments: widget.deliveryId,
                            );
                          },
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0Xff11998E), Color(0Xff38EF7D)],
                          ),
                        )
                      : const SizedBox(),
                  SizedBox(height: size.height * 0.03),
                ],
              ),
            ),
    );
  }

  Future<void> scanProduct(DeliveryItem product) async {
    Size size = MediaQuery.of(context).size;

    IconButton closeButtonWidget = IconButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      icon: const Icon(
        Icons.clear,
        size: 30,
        // color: ,
      ),
    );
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
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
                        closeButtonWidget,
                      ],
                    ),
                    const SizedBox(height: 0),
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: "Product Drop Off",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      product.modelNo,
                      style: const TextStyle(
                        color: Colors.black,
                        // fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(height: 10, thickness: 1),
                    Container(
                      width: size.width * 0.8,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: kSecondaryColor2,
                        splashColor: Colors.white.withAlpha(100),
                        highlightColor: kSecondaryColor2,
                        onPressed: () async {
                          // String scannedSerialNumber = await FlutterBarcodeScanner.scanBarcode('#ff6666','Cancel',true,ScanMode.BARCODE,);
                          final results = await BarcodeScanner.scan();

                          String scannedSerialNumber = results.rawContent;

                          if (scannedSerialNumber != "-1") {
                            if (product.serialNumber.contains(
                              scannedSerialNumber,
                            )) {
                              if (deliveryItemsScanned.isEmpty) {
                                List<String> minSerialNumber = [];
                                minSerialNumber.add(scannedSerialNumber);
                                setState(() {
                                  deliveryItemsScanned.add({
                                    product.itemCode: minSerialNumber,
                                  });
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
                              } else {
                                int index = deliveryItemsScanned.indexWhere(
                                  (map) => map.containsKey(product.itemCode),
                                );

                                if (index != -1) {
                                  if (deliveryItemsScanned[index][product
                                              .itemCode]!
                                          .contains(scannedSerialNumber) ==
                                      false) {
                                    setState(() {
                                      deliveryItemsScanned[index][product
                                              .itemCode]!
                                          .add(scannedSerialNumber);
                                    });
                                    // deliveryItemsScanned[index][product.itemCode]!.add(scannedSerialNumber);
                                  } else {
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
                                } else {
                                  List<String> minSerialNumber = [];
                                  minSerialNumber.add(scannedSerialNumber);
                                  setState(() {
                                    deliveryItemsScanned.add({
                                      product.itemCode: minSerialNumber,
                                    });
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
                            } else {
                              Fluttertoast.showToast(
                                msg:
                                    "Serial number has not been marked for delivery",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.TOP_RIGHT,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                              return;
                            }
                          } else {
                            Fluttertoast.showToast(
                              msg:
                                  "Kindly scann a valid serial number or qrcode",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP_RIGHT,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                            return;
                          }
                          setState(() {});
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
                          child: product.serialNumber.isNotEmpty
                              ? ListView.builder(
                                  itemCount: product.serialNumber.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Container(
                                      margin: EdgeInsets.only(
                                        top: size.height * 0.02,
                                      ),
                                      child: ListTile(
                                        tileColor:
                                            deliveryItemsScanned.isNotEmpty
                                            ? deliveryItemsScanned[0]
                                                      .containsKey(
                                                        product.itemCode,
                                                      )
                                                  ? deliveryItemsScanned[0][product
                                                                .itemCode]!
                                                            .contains(
                                                              product
                                                                  .serialNumber[index],
                                                            )
                                                        ? Colors.green
                                                        : Colors.amber
                                                  : Colors.amber
                                            : Colors.amber,
                                        leading: Text(
                                          "${index + 1}",
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        title: Text(
                                          product.serialNumber[index],
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        // trailing: IconButton(
                                        //   onPressed: (){
                                        //     setState(() {
                                        //       // product.serialNumber.removeAt(index);
                                        //     });
                                        //   },
                                        //   icon: const Icon(
                                        //     Icons.skip_next_outlined,
                                        //     color: Colors.red,
                                        //   )
                                        // ),
                                      ),
                                    );
                                  },
                                )
                              : const Center(
                                  child: Text(
                                    "No serial numbers found. Kindly scan serial numbers.",
                                  ),
                                ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: kBlueColor,
                          splashColor: Colors.white.withAlpha(100),
                          highlightColor: kBlueColor,
                          onPressed: () {
                            if (product.serialNumber.isNotEmpty) {
                              Navigator.of(context).pop();
                              dynamicMaster.displaySuccessMessage(
                                context,
                                "Product saved successfully",
                              );
                            } else {
                              dynamicMaster.displayError(
                                context,
                                "Error",
                                "Kindly scan serial numbers before saving",
                              );
                            }
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.save_as_outlined, color: Colors.white),
                              SizedBox(width: 10),
                              Text(
                                "Save",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
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
      },
    );
  }

  Future<void> deliveryComplete() async {
    Size size = MediaQuery.of(context).size;

    int currentStep = 0;
    List<bool> stepErrors = [false, false];

    List<Step> getSteps() => [
      Step(
        state: stepErrors[0] == true
            ? StepState.error
            : currentStep > 0
            ? StepState.complete
            : StepState.indexed,
        title: currentStep == 0 ? const Text("Scan Products") : Container(),
        content: SizedBox(
          width: size.width,
          height: size.height * 0.51,
          child: ListView.builder(
            itemCount: deliveryDetails!.deliveryItems.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  scanProduct(deliveryDetails!.deliveryItems[index]);
                },
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: size.height * 0.02),
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(size.width * 0.03),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12.withOpacity(0.3),
                              offset: const Offset(-2.0, 2.0),
                              blurRadius: 10.0,
                              spreadRadius: 2.0,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: size.height * 0.1,
                              width: size.width * 0.2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image:
                                      deliveryDetails!
                                              .deliveryItems[index]
                                              .itemImage !=
                                          ''
                                      ? NetworkImage(
                                          deliveryDetails!
                                              .deliveryItems[index]
                                              .itemImage,
                                        )
                                      : const AssetImage(
                                              'assets/images/empty_image_placeholder.png',
                                            )
                                            as ImageProvider,
                                ),
                              ),
                            ),
                            SizedBox(width: size.width * 0.03),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: size.width * 0.427,
                                  child: Text(
                                    deliveryDetails!
                                        .deliveryItems[index]
                                        .modelNo,
                                    softWrap: true,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: size.height * 0.01),
                                Text(
                                  deliveryDetails!
                                      .deliveryItems[index]
                                      .itemGroup,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: size.height * 0.01),
                                Text(
                                  "Delivery Qty: ${deliveryDetails!.deliveryItems[index].deliveryQuantity.toString()}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: size.height * 0.01),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: dynamicMaster.displayBadge(
                          Colors.amber,
                          "Pending: 1 ",
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
      Step(
        state: stepErrors[1] == true
            ? StepState.error
            : currentStep > 1
            ? StepState.complete
            : StepState.indexed,
        title: currentStep == 1
            ? const Text("Customer Confirmation")
            : Container(),
        content: const SizedBox(),
      ),
    ];

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        IconButton closeButtonWidget = IconButton(
          icon: const Icon(Icons.clear, size: 30),
          onPressed: () {
            Navigator.of(context).pop();
          },
        );
        return Container(
          height: size.height * 0.9,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset("assets/images/mika.png", height: 50, width: 50),
                  closeButtonWidget,
                ],
              ),
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "Order Delivery",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 10, thickness: 1),
              SizedBox(height: size.height * 0.02),
              SizedBox(
                height: size.height * 0.7,
                child: Stepper(
                  type: StepperType.horizontal,
                  currentStep: currentStep,
                  physics: const NeverScrollableScrollPhysics(),
                  onStepTapped: (int index) {
                    if (index > currentStep) {
                      // If the user taps on a future step, don't allow navigation.
                      return;
                    }
                    // Perform validation and allow navigation if the current step is valid.
                    // validateStep();
                  },
                  onStepContinue: () {
                    // validateStep();
                  },
                  onStepCancel: () {
                    setState(() {
                      if (currentStep > 0) {
                        currentStep--;
                      } else {
                        currentStep = 0;
                      }
                    });
                  },
                  steps: getSteps(),
                  controlsBuilder: (context, details) {
                    return Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: details.onStepContinue,
                              child: Text(
                                currentStep == getSteps().length - 1
                                    ? "Submit"
                                    : "Next",
                              ),
                            ),
                          ),
                          const SizedBox(width: 40),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: details.onStepCancel,
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(
                                  Colors.grey,
                                ),
                              ),
                              child: const Text("Previous"),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
