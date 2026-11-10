import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import '../../../components/dynamic_widgets.dart';
import '../../../constants/main_constants.dart';
import '../../../modals/jobcard_details_modal.dart';
import '../../../modals/jobcard_spare_parts_modal.dart';
import '../../../modals/requested_spare_part_modal.dart';
import '../../../modals/sparepart_modal.dart';
import '../../../providers/user_provider.dart';
import '../../../services/api_services.dart';
import 'package:provider/provider.dart';

class SparePartsTab extends StatefulWidget {
  final JobCardDetailsModal jobCardDetailObj;
  final bool isClosed;
  const SparePartsTab({
    super.key,
    required this.jobCardDetailObj,
    this.isClosed = false,
  });

  @override
  State<SparePartsTab> createState() => _SparePartsTabState();
}

class _SparePartsTabState extends State<SparePartsTab> {
  ApiService apiService = ApiService();
  DynamicMaster dynamicMaster = DynamicMaster();
  UserProvider userProvider = UserProvider();

  bool isLoading = false;

  List<RequestedSparePartModal> requestedSparePartsList = [];
  List<JobCardSparePartsModal> issuedSparePartsList = [];

  bool sparePartHasError = false;
  bool remarksHasError = false;

  TextEditingController sparePartInputController = TextEditingController();
  TextEditingController remarksInputController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      userProvider = Provider.of<UserProvider>(context, listen: false);
    });

    getJobCardSpareParts();
    getRequestedSpareParts();
  }

  Future<void> getRequestedSpareParts() async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> queryParameters = {
      "token": context.read<UserProvider>().user!.token,
      "jobCardNumber": widget.jobCardDetailObj.docEntry,
      "requestStatus": "pending",
      "requestType": "1",
    };

    var requestedSparePartsResponse = await apiService
        .filterRequestedSpareParts(queryParameters);

    List<RequestedSparePartModal> tempRequested = [];

    if (requestedSparePartsResponse["status"] == "success" &&
        requestedSparePartsResponse["data_obj"] != null) {
      for (var item in requestedSparePartsResponse["data_obj"]) {
        final part = requestedSparePartModalFromJson(jsonEncode(item));
        tempRequested.add(part);
      }
    }

    setState(() {
      isLoading = false;
      requestedSparePartsList = tempRequested;
    });
  }

  Future<void> getJobCardSpareParts() async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> queryParameters = {
      "token": context.read<UserProvider>().user!.token,
      "docEntry": widget.jobCardDetailObj.docEntry,
    };

    var jobCardSparePartsResponse = await apiService.filterJobCardSpareParts(
      queryParameters,
    );

    List<JobCardSparePartsModal> tempRequested = [];
    List<JobCardSparePartsModal> tempIssued = [];

    if (jobCardSparePartsResponse["status"] == "success" &&
        jobCardSparePartsResponse["data_obj"] != null) {
      for (var item in jobCardSparePartsResponse["data_obj"]) {
        final part = jobCardSparePartsModalFromJson(jsonEncode(item));

        /// Adjust the condition below to match how your API
        /// indicates that a part is requested vs. issued.
        // tempIssued.add(part);
        if (part.sparePartType == "REQUESTED") {
          tempRequested.add(part);
        } else if (part.sparePartType == "ISSUED") {
          tempIssued.add(part);
        }
      }
    }

    setState(() {
      isLoading = false;
      issuedSparePartsList = tempIssued;
    });
  }

  Widget buildRequestedSparePartsTable({
    required List<RequestedSparePartModal> spareParts,
    required String emptyMessage,
  }) {
    Size size = MediaQuery.of(context).size;
    if (isLoading) {
      return SizedBox(
        height: size.height * 0.15,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (spareParts.isEmpty) {
      return SizedBox(
        height: size.height * 0.15,
        child: Center(child: Text(emptyMessage)),
      );
    }

    return SizedBox(
      height: size.height * 0.15,
      child: SingleChildScrollView(
        child: DataTable(
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          headingRowHeight: 0,
          border: TableBorder.all(color: Colors.black),
          columns: const [
            DataColumn(label: SizedBox.shrink()),
            DataColumn(label: SizedBox.shrink()),
            DataColumn(label: SizedBox.shrink()),
          ],
          rows: List<DataRow>.generate(spareParts.length, (index) {
            final item = spareParts[index];
            return DataRow(
              cells: [
                DataCell(
                  SizedBox(
                    width: size.width * 0.18,
                    child: Text(item.itemName),
                  ),
                ),
                DataCell(
                  SizedBox(width: size.width * 0.18, child: Text(item.modelNo)),
                ),
                DataCell(
                  SizedBox(
                    width: size.width * 0.2,
                    child: Text(item.quantity.toString()),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget buildSparePartsTable({
    required List<JobCardSparePartsModal> spareParts,
    required String emptyMessage,
  }) {
    Size size = MediaQuery.of(context).size;
    if (isLoading) {
      return SizedBox(
        height: size.height * 0.15,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (spareParts.isEmpty) {
      return SizedBox(
        height: size.height * 0.15,
        child: Center(child: Text(emptyMessage)),
      );
    }

    return SizedBox(
      height: size.height * 0.15,
      child: SingleChildScrollView(
        child: DataTable(
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          headingRowHeight: 0,
          border: TableBorder.all(color: Colors.black),
          columns: const [
            DataColumn(label: SizedBox.shrink()),
            DataColumn(label: SizedBox.shrink()),
            DataColumn(label: SizedBox.shrink()),
          ],
          rows: List<DataRow>.generate(spareParts.length, (index) {
            final item = spareParts[index];
            return DataRow(
              cells: [
                DataCell(
                  SizedBox(
                    width: size.width * 0.18,
                    child: Text(item.itemName),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: size.width * 0.18,
                    child: Text(item.modelNumber),
                  ),
                ),
                DataCell(
                  SizedBox(width: size.width * 0.2, child: const Text("N/A")),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Future<List<SparePartModal>> getSpareParts(filter) async {
    Map<String, dynamic> queryParameters = {
      "token": context.read<UserProvider>().user!.token,
      "itemCode": widget.jobCardDetailObj.itemCode,
    };

    var response = await apiService.filterSpareParts(queryParameters);

    print(response);

    if (response.isNotEmpty &&
        response["status"] == "success" &&
        response["data_obj"] != null) {
      List<SparePartModal> sparePartsList = [];

      response["data_obj"].forEach((itemGroup) {
        SparePartModal sparePart = sparePartModalFromJson(
          jsonEncode(itemGroup),
        );
        sparePartsList.add(sparePart);
      });
      return sparePartsList;
    } else {
      return [];
    }
  }

  Widget _sparePartPopupBuilder(
    BuildContext context,
    SparePartModal item,
    bool isSelected,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
        selected: isSelected,
        title: Text("${item.uFullDesc}-${item.uOurModelNo}"),
      ),
    );
  }

  Future<void> requestSpareModal() async {
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
                height: size.height * 0.6,
                width: size.width,
                child: SingleChildScrollView(
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
                              text: "Spare Parts Request",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        "please fill the form below to request spare parts",
                        style: TextStyle(
                          // color: Colors.black,
                        ),
                      ),
                      const Divider(height: 10, thickness: 1),
                      SizedBox(height: size.height * 0.02),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Spare Part Name:",
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
                            DropdownSearch<SparePartModal>(
                              asyncItems: (String? filter) =>
                                  getSpareParts(filter),
                              popupProps:
                                  PopupPropsMultiSelection.modalBottomSheet(
                                    showSelectedItems: true,
                                    itemBuilder: _sparePartPopupBuilder,
                                    showSearchBox: true,
                                  ),
                              compareFn: (item, sItem) =>
                                  item.itemName == sItem.itemName,
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  labelText: 'Select Spare Part',
                                  labelStyle: const TextStyle(
                                    color: kPrimaryColor,
                                  ),
                                  filled: true,
                                  fillColor: kPrimaryLightColor,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: sparePartHasError
                                          ? Colors.red
                                          : Colors.grey,
                                    ),
                                    // borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                  iconColor: kPrimaryColor,
                                  prefixIconColor: kPrimaryColor,
                                ),
                                baseStyle: const TextStyle(
                                  color: kPrimaryColor,
                                ),
                              ),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    sparePartHasError = false;
                                    sparePartInputController.text =
                                        value.itemCode;
                                  });
                                } else {
                                  setState(() {
                                    sparePartHasError = true;
                                    sparePartInputController.clear();
                                  });
                                }
                              },
                            ),
                            SizedBox(height: size.height * 0.02),
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
                                  color: remarksHasError
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
                                    hintText: "Enter Remarks",
                                    border: InputBorder.none,
                                  ),
                                  controller: remarksInputController,
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      setState(() {
                                        remarksHasError = false;
                                      });
                                    } else {
                                      setState(() {
                                        remarksHasError = true;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: size.height * 0.06),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey[400],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  child: const Text("Cancel"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    if (sparePartInputController.text.isEmpty) {
                                      setState(() {
                                        sparePartHasError = true;
                                      });
                                    } else if (remarksInputController
                                        .text
                                        .isEmpty) {
                                      setState(() {
                                        remarksHasError = true;
                                      });
                                    } else {
                                      setState(() {
                                        sparePartHasError = false;
                                        remarksHasError = false;
                                      });
                                      Navigator.of(context).pop();
                                      submitSparePartRequest();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  child: const Text("Submit"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> submitSparePartRequest() async {
    dynamicMaster.displayLoadingModal(context);

    var response = await apiService.submitSparePartRequest(
      context.read<UserProvider>().user!.token,
      widget.jobCardDetailObj.docEntry,
      sparePartInputController.text,
      remarksInputController.text,
    );

    Navigator.of(context).pop(); // close loading modal

    if (response["status"] == "success") {
      dynamicMaster.displaySuccessMessage(context, response["message"]);

      // After a successful submission, re-fetch the data
      getJobCardSpareParts();
      getRequestedSpareParts();
    } else {
      dynamicMaster.displayError(context, "Error", response["message"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// -----------------------------------
          ///  1) REQUESTED SPARE PARTS
          /// -----------------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Requested Spare Parts:",
                style: TextStyle(
                  fontSize: size.height * 0.02,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (!widget.isClosed)
                MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: kSecondaryColor2,
                  splashColor: Colors.white.withAlpha(100),
                  highlightColor: kSecondaryColor2,
                  onPressed: () {
                    requestSpareModal();
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.request_page_outlined),
                      Text("Request Parts"),
                    ],
                  ),
                ),
            ],
          ),
          SizedBox(height: size.height * 0.01),

          // Header for the table
          Container(
            color: Colors.blueGrey,
            height: size.height * 0.05,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(width: 100, child: Text('Item Name:')),
                SizedBox(width: 100, child: Text('Model No:')),
                SizedBox(width: 100, child: Text('Quantity:')),
              ],
            ),
          ),

          // Table of REQUESTED PARTS
          buildRequestedSparePartsTable(
            spareParts: requestedSparePartsList,
            emptyMessage: "No Spare Parts Requested",
          ),

          const SizedBox(height: 20),

          /// -----------------------------------
          ///  2) ISSUED SPARE PARTS
          /// -----------------------------------
          Text(
            "Spare Parts Issued:",
            style: TextStyle(
              fontSize: size.height * 0.02,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: size.height * 0.01),

          Container(
            color: Colors.blueGrey,
            height: size.height * 0.05,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(width: 100, child: Text('Item Name:')),
                SizedBox(width: 100, child: Text('Model No:')),
                SizedBox(width: 100, child: Text('Quantity:')),
              ],
            ),
          ),

          // Table of ISSUED PARTS
          buildSparePartsTable(
            spareParts: issuedSparePartsList,
            emptyMessage: "No Spare Parts Issued",
          ),
        ],
      ),
    );
  }
}
