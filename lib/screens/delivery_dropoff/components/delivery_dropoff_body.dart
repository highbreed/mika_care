// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';
import '../../../components/dynamic_widgets.dart';
import '../../../components/rounded_buttons.dart';
import '../../../constants/main_constants.dart';
import '../../../modals/delivery_details_modal.dart';
import '../../../providers/user_provider.dart';
import 'delivery_dropoff_product.dart';
import '../../../services/api_services.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DeliveryDropOffBody extends StatefulWidget {
  final int deliveryId;
  const DeliveryDropOffBody({super.key, required this.deliveryId});

  @override
  State<DeliveryDropOffBody> createState() => _DeliveryDropOffBodyState();
}

class _DeliveryDropOffBodyState extends State<DeliveryDropOffBody> {
  final PageController _pageController = PageController();
  ApiService apiService = ApiService();
  UserProvider session = UserProvider();
  DynamicMaster dynamicMaster = DynamicMaster();

  DeliveryDetails? currentDeliveryDetails;

  bool isLoading = false;
  int currentPage = 0;
  String btmBtnText = "Scan Product";
  bool isLastPage = false;
  int totalProducts = 0;
  int totalProductsPicked = 0;
  bool signatureCaptured = false;
  File? scannedDeliveryDocument;
  List<Map<String, List<String>>> deliveryItemsScanned = [];

  SignatureController? _signatureController;
  TextEditingController customerOtpInputController = TextEditingController();

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
      print(response);

      if (response["status"] == "success" && response["data_obj"] != null) {
        currentDeliveryDetails = deliveryDetailsFromJson(
          jsonEncode(response["data_obj"]),
        );

        for (var product in currentDeliveryDetails!.deliveryItems) {
          totalProducts += product.serialNumber.length;
        }

        apiService.initiateOrderDelivery(
          session.user!.token,
          widget.deliveryId.toString(),
        );
      }
    } catch (error) {
      dynamicMaster.displayError(context, "Error", error.toString());
    }
    isLoading = false;

    setState(() {});
  }

  Future<void> nextPage() async {
    await _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    int currentPageIndex = _pageController.page?.round() ?? 0;

    if (currentPageIndex == currentDeliveryDetails!.deliveryItems.length - 1) {
      setState(() {
        isLastPage = true;
      });
    } else {
      setState(() {
        isLastPage = false;
      });
    }
    refreshScreen();
  }

  Future<void> previousPage() async {
    await _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    int currentPageIndex = _pageController.page?.round() ?? 0;

    if (currentPageIndex == currentDeliveryDetails!.deliveryItems.length - 1) {
      setState(() {
        isLastPage = true;
      });
    } else {
      setState(() {
        isLastPage = false;
      });
    }
    refreshScreen();
  }

  Future<void> refreshScreen() async {
    int currentPageIndex = _pageController.page?.round() ?? 0;

    // Update isLastPage based on current position
    if (currentPageIndex == currentDeliveryDetails!.deliveryItems.length - 1) {
      isLastPage = true;
    } else {
      isLastPage = false;
    }

    int mintotalProductsPicked = 0;
    int currentProductPickedSerialNo = 0;

    if (deliveryItemsScanned.isNotEmpty) {
      for (var product in deliveryItemsScanned) {
        if (product.containsKey(
          currentDeliveryDetails!.deliveryItems[currentPageIndex].itemCode,
        )) {
          for (var serialNumber in product.values) {
            currentProductPickedSerialNo += serialNumber.length;
          }
        }
        for (var serialNumber in product.values) {
          mintotalProductsPicked += serialNumber.length;
        }
      }
    }

    if (isLastPage &&
            currentProductPickedSerialNo ==
                currentDeliveryDetails!
                    .deliveryItems[currentPageIndex]
                    .serialNumber
                    .length ||
        isLastPage &&
            currentDeliveryDetails!.deliveryItems[currentPageIndex].isSkipped ==
                true) {
      btmBtnText = "Finish";
    } else {
      btmBtnText = "Scan Product";
    }
    setState(() {
      totalProductsPicked = mintotalProductsPicked;
      btmBtnText = btmBtnText;
    });
  }

  Future<void> productSkipModal(DeliveryItem product) async {
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
    bool commentsHasError = false;
    TextEditingController commentsController = TextEditingController();

    if (product.isSkipped) {
      commentsController.text = product.comment;
    }

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
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
                        closeButtonWidget,
                      ],
                    ),
                    const SizedBox(height: 0),
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: "Skip product",
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
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(height: 10, thickness: 1),
                    Container(
                      height: size.height * 0.18,
                      width: size.width * 0.8,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          SizedBox(height: size.height * .03),
                          Row(
                            children: [
                              const Text(
                                "Remarks:",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: size.width * 0.009),
                              const Text(
                                "*",
                                style: TextStyle(color: kRedColor),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.005),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: commentsHasError
                                    ? Colors.red
                                    : Colors.grey,
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
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: const InputDecoration(
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  hintText: "Enter Reason for skipping product",
                                  border: InputBorder.none,
                                ),
                                controller: commentsController,
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    setState(() {
                                      commentsHasError = false;
                                    });
                                  } else {
                                    setState(() {
                                      commentsHasError = true;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              // primary: kRedColor,
                            ),
                            child: const Text("Cancel"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (commentsController.text.isNotEmpty) {
                                setState(() {
                                  product.isSkipped = true;
                                  product.comment = commentsController.text;
                                });

                                Navigator.of(context).pop();
                                dynamicMaster.displaySuccessMessage(
                                  context,
                                  "Product skipped successfully",
                                );
                                nextPage();

                                refreshScreen();
                              } else {
                                setState(() {
                                  commentsHasError = true;
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              // primary: kBlueColor,
                            ),
                            child: const Text("Save"),
                          ),
                        ],
                      ),
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

  Future<void> submitProducts() async {
    dynamicMaster.displayLoadingModal(context);

    try {
      // Save signature to temporary file if exists
      File? signatureFile;
      if (_signatureController != null && _signatureController!.isNotEmpty) {
        final Uint8List? signatureBytes = await _signatureController!
            .toPngBytes();
        if (signatureBytes != null) {
          final tempDir = Directory.systemTemp;
          signatureFile = File(
            '${tempDir.path}/signature_${widget.deliveryId}.png',
          );
          await signatureFile.writeAsBytes(signatureBytes);
        }
      }

      // Call API service
      var response = await apiService.submitDeliveryProducts(
        session.user!.token,
        widget.deliveryId.toString(),
        deliveryItemsScanned,
        signatureFile,
        scannedDeliveryDocument,
      );

      Navigator.of(context).pop();

      if (response["status"] == "success") {
        dynamicMaster.displaySuccessMessage(context, response["message"]);
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pushReplacementNamed(context, "/delivery_screen");
      } else {
        dynamicMaster.displayError(context, "Error", response["message"]);
      }
    } catch (error) {
      Navigator.of(context).pop();
      dynamicMaster.displayError(context, "Error", error.toString());
    }
  }

  Future<void> deliveryComplete() async {
    Size size = MediaQuery.of(context).size;

    // Reset state for clean modal
    scannedDeliveryDocument = null;
    signatureCaptured = false;

    // Initialize signature controller
    _signatureController = SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
    );

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: size.height * 0.75,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  top: size.height * 0.02,
                  left: size.width * 0.05,
                  right: size.width * 0.05,
                  bottom:
                      MediaQuery.of(context).viewInsets.bottom +
                      MediaQuery.of(context).padding.bottom +
                      10,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          "assets/images/mika.png",
                          height: size.height * 0.04,
                          width: size.width * 0.2,
                        ),
                        IconButton(
                          onPressed: () {
                            _signatureController?.dispose();
                            setState(() {
                              scannedDeliveryDocument = null;
                              signatureCaptured = false;
                            });
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.close, size: 28),
                        ),
                      ],
                    ),
                    const Text(
                      "Confirm Submission",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(height: 10, thickness: 1),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: size.height * 0.01),
                            const Text(
                              "Are you sure you want to submit?",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: size.height * 0.01),
                            const Text(
                              "Kindly confirm that you have scanned all serial numbers for all products",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: size.height * 0.015),
                            Text(
                              "Total Products: $totalProducts",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: size.height * 0.01),
                            Text(
                              "Products Picked: $totalProductsPicked",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: size.height * 0.02),
                            Row(
                              children: [
                                const Text(
                                  "Customer Signature:",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: size.width * 0.009),
                                const Text(
                                  "*",
                                  style: TextStyle(color: kRedColor),
                                ),
                              ],
                            ),
                            SizedBox(height: size.height * 0.01),
                            Container(
                              height: size.height * 0.2,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: signatureCaptured
                                      ? Colors.green
                                      : Colors.grey,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Signature(
                                controller: _signatureController!,
                                backgroundColor: Colors.white,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _signatureController?.clear();
                                      signatureCaptured = false;
                                    });
                                  },
                                  child: const Text("Clear Signature"),
                                ),
                              ],
                            ),
                            SizedBox(height: size.height * 0.02),
                            Row(
                              children: [
                                const Text(
                                  "Delivery Document:",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: size.width * 0.009),
                                const Text(
                                  "*",
                                  style: TextStyle(color: kRedColor),
                                ),
                              ],
                            ),
                            SizedBox(height: size.height * 0.01),
                            GestureDetector(
                              onTap: () async {
                                final ImagePicker picker = ImagePicker();
                                final XFile? image = await picker.pickImage(
                                  source: ImageSource.camera,
                                  imageQuality: 60,
                                  maxWidth: 1024,
                                  maxHeight: 1024,
                                );

                                if (image != null) {
                                  setState(() {
                                    scannedDeliveryDocument = File(image.path);
                                  });
                                  Fluttertoast.showToast(
                                    msg: "Document captured successfully",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.TOP_RIGHT,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                  );
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                height: scannedDeliveryDocument != null
                                    ? size.height * 0.25
                                    : size.height * 0.12,
                                decoration: BoxDecoration(
                                  color: scannedDeliveryDocument != null
                                      ? Colors.green.shade50
                                      : Colors.grey.shade100,
                                  border: Border.all(
                                    color: scannedDeliveryDocument != null
                                        ? Colors.green
                                        : Colors.grey,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: scannedDeliveryDocument != null
                                    ? Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              6.0,
                                            ),
                                            child: Image.file(
                                              scannedDeliveryDocument!,
                                              width: double.infinity,
                                              height: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Positioned(
                                            top: 8,
                                            right: 8,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                                shape: BoxShape.circle,
                                              ),
                                              padding: const EdgeInsets.all(4),
                                              child: const Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.camera_alt,
                                            size: 40,
                                            color: Colors.grey.shade600,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            "Tap to capture delivery document",
                                            style: TextStyle(
                                              color: Colors.grey.shade700,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                            SizedBox(height: size.height * 0.01),
                            const Text(
                              "This action cannot be undone",
                              style: TextStyle(color: Colors.red, fontSize: 13),
                            ),
                            SizedBox(height: size.height * 0.01),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: size.height * 0.01,
                        bottom: size.height * 0.02,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                _signatureController?.dispose();
                                setState(() {
                                  scannedDeliveryDocument = null;
                                  signatureCaptured = false;
                                });
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              child: const Text("Cancel"),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_signatureController!.isEmpty) {
                                  Fluttertoast.showToast(
                                    msg: "Please provide customer signature",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.TOP_RIGHT,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                  );
                                  return;
                                }

                                if (scannedDeliveryDocument == null) {
                                  Fluttertoast.showToast(
                                    msg:
                                        "Please capture customer delivery document",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.TOP_RIGHT,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                  );
                                  return;
                                }

                                setState(() {
                                  signatureCaptured = true;
                                });
                                _signatureController?.dispose();
                                Navigator.of(context).pop();
                                submitProducts();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kBlueColor,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              child: const Text("Submit"),
                            ),
                          ),
                        ],
                      ),
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

  Future<void> scanProduct(DeliveryItem product) async {
    Size size = MediaQuery.of(context).size;

    if (isLastPage && product.isSkipped == true ||
        isLastPage && btmBtnText == "Finish") {
      deliveryComplete();
      return;
    } else {
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
                              text: "Deliver Products",
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
                            var scannedSerialNumber =
                                await BarcodeScanner.scan();

                            if (scannedSerialNumber.rawContent != "-1") {
                              if (product.serialNumber.contains(
                                scannedSerialNumber.rawContent,
                              )) {
                                if (deliveryItemsScanned.isEmpty) {
                                  List<String> minSerialNumber = [];
                                  minSerialNumber.add(
                                    scannedSerialNumber.rawContent,
                                  );
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
                                  print(
                                    "product: ${deliveryItemsScanned.toString()}",
                                  );
                                  int index = deliveryItemsScanned.indexWhere(
                                    (map) => map.containsKey(product.itemCode),
                                  );

                                  print("product id $index");

                                  if (index != -1) {
                                    if (deliveryItemsScanned[index][product
                                                .itemCode]!
                                            .contains(
                                              scannedSerialNumber.rawContent,
                                            ) ==
                                        false) {
                                      setState(() {
                                        deliveryItemsScanned[index][product
                                                .itemCode]!
                                            .add(
                                              scannedSerialNumber.rawContent,
                                            );
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
                                    minSerialNumber.add(
                                      scannedSerialNumber.rawContent,
                                    );
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
                                      "Serial '${scannedSerialNumber.rawContent}' not marked for delivery",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.TOP_RIGHT,
                                  timeInSecForIosWeb: 2,
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
                                      int index2 = deliveryItemsScanned
                                          .indexWhere(
                                            (map) => map.containsKey(
                                              product.itemCode,
                                            ),
                                          );
                                      return Container(
                                        margin: EdgeInsets.only(
                                          top: size.height * 0.02,
                                        ),
                                        child: ListTile(
                                          tileColor: index2 == -1
                                              ? Colors.amber
                                              : deliveryItemsScanned.isNotEmpty
                                              ? deliveryItemsScanned[index2]
                                                        .containsKey(
                                                          product.itemCode,
                                                        )
                                                    ? deliveryItemsScanned[index2][product
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
                                          trailing: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                product.serialNumber.removeAt(
                                                  index,
                                                );
                                              });
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          ),
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
                                refreshScreen();
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
                                Icon(
                                  Icons.save_as_outlined,
                                  color: Colors.white,
                                ),
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
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : currentDeliveryDetails == null
        ? const Center(child: Text("No data found"))
        : Container(
            height: size.height,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [
                  Colors.orange.shade900,
                  Colors.orange.shade600,
                  Colors.orange.shade600,
                  Colors.orange.shade400,
                ],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: size.height * 0.03),
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
                                  borderRadius: BorderRadius.circular(50),
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
                                ),
                              ),
                              const SizedBox(width: 30),
                              Column(
                                children: [
                                  const Text(
                                    "Delivery Drop Off",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Drop off the package at the destination",
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
                      height: size.height * 0.84,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: size.height * 0.669,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: size.height * 0.56,
                                  child: PageView.builder(
                                    controller: _pageController,
                                    itemCount: currentDeliveryDetails!
                                        .deliveryItems
                                        .length,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    onPageChanged: (index) {
                                      // setState(() {
                                      //   currentQuestionIndex = index;
                                      // });
                                    },
                                    itemBuilder: (context, index) {
                                      return DeliveryDropOffProductCard(
                                        deliveryItem: currentDeliveryDetails!
                                            .deliveryItems[index],
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: size.height * 0.03),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        previousPage();
                                      },
                                      icon: Icon(
                                        Icons.arrow_back_ios_outlined,
                                        color: Colors.blue[700],
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: SmoothPageIndicator(
                                          controller: _pageController,
                                          count: currentDeliveryDetails!
                                              .deliveryItems
                                              .length,
                                          effect: const WormEffect(),
                                          onDotClicked: (index) {
                                            _pageController.animateToPage(
                                              index,
                                              duration: const Duration(
                                                milliseconds: 300,
                                              ),
                                              curve: Curves.easeInOut,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        int currentPageIndex =
                                            _pageController.page?.round() ?? 0;
                                        if (deliveryItemsScanned.isNotEmpty) {
                                          bool
                                          containsKey = deliveryItemsScanned.any(
                                            (map) => map.containsKey(
                                              currentDeliveryDetails!
                                                  .deliveryItems[currentPageIndex]
                                                  .itemCode,
                                            ),
                                          );
                                          if (currentDeliveryDetails!
                                                  .deliveryItems[currentPageIndex]
                                                  .serialNumber
                                                  .isNotEmpty &&
                                              containsKey) {
                                            Map<String, dynamic> resultMap =
                                                deliveryItemsScanned.firstWhere(
                                                  (map) => map.containsKey(
                                                    currentDeliveryDetails!
                                                        .deliveryItems[currentPageIndex]
                                                        .itemCode,
                                                  ),
                                                  orElse: () => {},
                                                );

                                            for (var serialNumber
                                                in currentDeliveryDetails!
                                                    .deliveryItems[currentPageIndex]
                                                    .serialNumber) {
                                              if (resultMap[currentDeliveryDetails!
                                                          .deliveryItems[currentPageIndex]
                                                          .itemCode]
                                                      .contains(serialNumber) ==
                                                  false) {
                                                dynamicMaster.displayError(
                                                  context,
                                                  "Error",
                                                  "Kindly scan all serial numbers before proceeding",
                                                );
                                                return;
                                              }
                                            }
                                            nextPage();
                                          } else if (currentDeliveryDetails!
                                                  .deliveryItems[currentPageIndex]
                                                  .isSkipped ==
                                              true) {
                                            nextPage();
                                          } else {
                                            dynamicMaster.displayError(
                                              context,
                                              "Error",
                                              "Kindly scan serial numbers before proceeding",
                                            );
                                          }
                                        } else if (currentDeliveryDetails!
                                                .deliveryItems[currentPageIndex]
                                                .isSkipped ==
                                            true) {
                                          nextPage();
                                        } else {
                                          dynamicMaster.displayError(
                                            context,
                                            "Error",
                                            "Kindly scan serial numbers before proceeding",
                                          );
                                        }
                                      },
                                      icon: Icon(
                                        Icons.arrow_forward_ios_outlined,
                                        color: Colors.blue[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: size.height * 0.171,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Color(0xFF002FA7),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 20.0,
                                right: 20,
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: size.height * 0.01),
                                  Text(
                                    "Total Products: $totalProducts",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: size.height * 0.01),
                                  Text(
                                    "Products Picked: $totalProductsPicked",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: size.height * 0.01),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.4,
                                        child: RoundedButton(
                                          btnText: "Skip Product",
                                          press: () {
                                            int currentPageIndex =
                                                _pageController.page?.round() ??
                                                0;
                                            productSkipModal(
                                              currentDeliveryDetails!
                                                  .deliveryItems[currentPageIndex],
                                            );
                                          },
                                          btnColor: kPrimaryLightColor,
                                          textColor: kRedColor,
                                        ),
                                      ),
                                      SizedBox(
                                        width: size.width * 0.4,
                                        child: RoundedButton(
                                          btnText: btmBtnText,
                                          press: () {
                                            int currentPageIndex =
                                                _pageController.page?.round() ??
                                                0;
                                            scanProduct(
                                              currentDeliveryDetails!
                                                  .deliveryItems[currentPageIndex],
                                            );
                                          },
                                          btnColor: kPrimaryLightColor,
                                          textColor: kSecondaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
