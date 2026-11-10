import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import '../../../components/dynamic_widgets.dart';
import '../../../constants/main_constants.dart';
import '../../../modals/fault_modal.dart';
import '../../../modals/jobcard_details_modal.dart';
import '../../../modals/jobcard_diagnosed_faults_modal.dart';
import '../../../providers/user_provider.dart';
import '../../../services/api_services.dart';
import 'package:provider/provider.dart';

class DiagnosisInfoTab extends StatefulWidget {
  final JobCardDetailsModal jobCardDetailObj;
  final bool isClosed;
  const DiagnosisInfoTab({
    super.key,
    required this.jobCardDetailObj,
    this.isClosed = false,
  });

  @override
  State<DiagnosisInfoTab> createState() => _DiagnosisInfoTabState();
}

class _DiagnosisInfoTabState extends State<DiagnosisInfoTab> {
  ApiService apiService = ApiService();
  DynamicMaster dynamicMaster = DynamicMaster();
  UserProvider userProvider = UserProvider();

  bool isLoading = false;
  List<JobCardDiagnosedFaultModel> diagnosedFaults = [];

  bool faultHasError = false;
  bool remarksHasError = false;

  TextEditingController faultInputController = TextEditingController();
  TextEditingController remarksInputController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      userProvider = Provider.of<UserProvider>(context, listen: false);
    });
    initScreen();
  }

  Future<void> initScreen() async {
    try {
      setState(() {
        isLoading = true;
      });
      var response = await apiService.filterJobCardDiagnosedFaults({
        "token": context.read<UserProvider>().user!.token,
        "jobCardDocEntry": widget.jobCardDetailObj.docEntry,
      });

      if (response["status"] == "success" && response["data_obj"].length > 0) {
        List<JobCardDiagnosedFaultModel> minDiagnosedFaults = [];

        for (var item in response["data_obj"]) {
          minDiagnosedFaults.add(
            jobCardDiagnosedFaultModelFromJson(jsonEncode(item)),
          );
        }
        setState(() {
          diagnosedFaults = minDiagnosedFaults;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      dynamicMaster.displayError(context, "Error", e.toString());
    }
  }

  Future<List<FaultModel>> getProductFaults(filter) async {
    var response = await apiService.filterFaults(
      context.read<UserProvider>().user!.token,
      widget.jobCardDetailObj.itemGroup1,
    );

    if (response.isNotEmpty &&
        response["status"] == "success" &&
        response["data_obj"] != null) {
      List<FaultModel> sparePartsList = [];

      response["data_obj"].forEach((itemGroup) {
        FaultModel sparePart = faultModelFromJson(jsonEncode(itemGroup));
        sparePartsList.add(sparePart);
      });
      return sparePartsList;
    } else {
      return [];
    }
  }

  Widget _sparePartPopupBuilder(
    BuildContext context,
    FaultModel item,
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
      child: ListTile(selected: isSelected, title: Text(item.name)),
    );
  }

  Future<void> submitSparePartRequest() async {
    dynamicMaster.displayLoadingModal(context);

    var response = await apiService.submitJobCardDiagnosis(
      context.read<UserProvider>().user!.token,
      widget.jobCardDetailObj.docEntry,
      faultInputController.text,
      remarksInputController.text,
    );

    Navigator.of(context).pop();

    if (response["status"] == "success") {
      remarksInputController.clear();
      dynamicMaster.displaySuccessMessage(context, response["message"]);
      initScreen();
    } else {
      dynamicMaster.displayError(context, "Error", response["message"]);
    }
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
                height: size.height * 0.5,
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
                            text: "Diagnose Product",
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
                                "Enter Fault:",
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
                          DropdownSearch<FaultModel>(
                            asyncItems: (String? filter) =>
                                getProductFaults(filter),
                            popupProps:
                                PopupPropsMultiSelection.modalBottomSheet(
                                  showSelectedItems: true,
                                  itemBuilder: _sparePartPopupBuilder,
                                  showSearchBox: true,
                                ),
                            compareFn: (item, sItem) => item.name == sItem.name,
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                labelText: 'Select Fault',
                                labelStyle: const TextStyle(
                                  color: kPrimaryColor,
                                ),
                                filled: true,
                                fillColor: kPrimaryLightColor,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: faultHasError
                                        ? Colors.red
                                        : Colors.grey,
                                  ),
                                  // borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                ),
                                iconColor: kPrimaryColor,
                                prefixIconColor: kPrimaryColor,
                              ),
                              baseStyle: const TextStyle(color: kPrimaryColor),
                            ),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  faultHasError = false;
                                  faultInputController.text = value.id
                                      .toString();
                                });
                              } else {
                                setState(() {
                                  faultHasError = true;
                                  faultInputController.clear();
                                });
                              }
                            },
                          ),
                          SizedBox(height: size.height * 0.02),
                          Row(
                            children: [
                              const Text(
                                "Sub-Fault:",
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
                                  hintText: "Enter Sub-Fault",
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
                                  if (faultInputController.text.isEmpty) {
                                    setState(() {
                                      faultHasError = true;
                                    });
                                  } else if (remarksInputController
                                      .text
                                      .isEmpty) {
                                    setState(() {
                                      remarksHasError = true;
                                    });
                                  } else {
                                    setState(() {
                                      faultHasError = false;
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
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.01),
      child: Column(
        children: [
          SizedBox(height: size.height * 0.02),
          // Fault Reported Card
          Container(
            width: size.width,
            padding: EdgeInsets.all(size.width * 0.04),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange.shade700,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Fault Reported",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.jobCardDetailObj.fault ?? "N/A",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: size.height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Diagnosed Faults:",
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
                      Icon(Icons.settings_applications_sharp),
                      Text("Diagnose Product"),
                    ],
                  ),
                ),
            ],
          ),
          SizedBox(height: size.height * 0.01),
          Container(
            color: Colors.blueGrey,
            height: size.height * 0.05,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(width: size.width * 0.4, child: const Text('Fault:')),
                SizedBox(
                  width: size.width * 0.4,
                  child: const Text('Sub Fault:'),
                ),
              ],
            ),
          ),
          isLoading
              ? Column(
                  children: [
                    SizedBox(height: size.height * 0.03),
                    const Center(child: CircularProgressIndicator()),
                  ],
                )
              : diagnosedFaults.isEmpty
              ? Column(
                  children: [
                    SizedBox(height: size.height * 0.03),
                    const Center(child: Text("No Diagnosed Faults Found")),
                  ],
                )
              : Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SizedBox(
                      child: DataTable(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        ),
                        headingRowHeight: 0,
                        border: TableBorder.all(color: Colors.black),
                        columns: [
                          DataColumn(label: Container()),
                          DataColumn(label: Container()),
                        ],
                        rows: List<DataRow>.generate(
                          diagnosedFaults.length, // Number of rows
                          (index) => DataRow(
                            cells: [
                              DataCell(
                                SizedBox(
                                  width: size.width * 0.4,
                                  child: Text(diagnosedFaults[index].fault),
                                ),
                              ),
                              DataCell(
                                SizedBox(
                                  width: size.width * 0.4,
                                  child: Text(diagnosedFaults[index].subFault),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
