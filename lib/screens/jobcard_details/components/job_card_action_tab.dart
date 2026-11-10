import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:intl/intl.dart';

import '../../../modals/jobcard_action_details.dart';
import '../../../modals/jobcard_action_modal.dart';
import '../../../providers/user_provider.dart';
import '../../../services/api_services.dart';
import 'package:provider/provider.dart';
import '../../../components/dynamic_widgets.dart';
import '../../../constants/main_constants.dart';
import '../../../modals/jobcard_details_modal.dart';

class JobCardActionTab extends StatefulWidget {
  final JobCardDetailsModal jobCardDetailObj;
  final bool isClosed;
  const JobCardActionTab({
    super.key,
    required this.jobCardDetailObj,
    this.isClosed = false,
  });

  @override
  State<JobCardActionTab> createState() => _JobCardActionTabState();
}

class _JobCardActionTabState extends State<JobCardActionTab> {
  ApiService apiService = ApiService();
  DynamicMaster dynamicMaster = DynamicMaster();
  UserProvider userProvider = UserProvider();

  bool isLoading = false;

  List<JobCardActionDetailsModal> jobCardAcctionList = [];

  bool actionHasError = false;

  TextEditingController actionInputController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      userProvider = Provider.of<UserProvider>(context, listen: false);
    });

    getJobCardActionDetails();
  }

  Future<void> getJobCardActionDetails() async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> queryParameters = {
      "token": context.read<UserProvider>().user!.token,
      "docEntry": widget.jobCardDetailObj.docEntry,
    };

    var jobCardSparePartsResponse = await apiService.getJobCardActions(
      queryParameters,
    );

    print(jobCardSparePartsResponse);

    List<JobCardActionDetailsModal> tempRequested = [];

    if (jobCardSparePartsResponse["status"] == "success" &&
        jobCardSparePartsResponse["data_obj"] != null) {
      for (var item in jobCardSparePartsResponse["data_obj"]) {
        final part = jobCardActionDetailsModalFromJson(jsonEncode(item));

        tempRequested.add(part);
      }
    }

    setState(() {
      isLoading = false;
      jobCardAcctionList = tempRequested;
    });
  }

  Future<List<JobCardActionModal>> getJobCardAction(filter) async {
    Map<String, dynamic> queryParameters = {
      "token": context.read<UserProvider>().user!.token,
    };

    var response = await apiService.filterJobCardActions(queryParameters);

    if (response.isNotEmpty &&
        response["status"] == "success" &&
        response["data_obj"] != null) {
      List<JobCardActionModal> actionList = [];

      response["data_obj"].forEach((itemGroup) {
        JobCardActionModal sparePart = jobCardActionModalFromJson(
          jsonEncode(itemGroup),
        );
        actionList.add(sparePart);
      });
      return actionList;
    } else {
      return [];
    }
  }

  Widget _jobCardActionPopupBuilder(
    BuildContext context,
    JobCardActionModal item,
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

  Future<void> submitJobCardAction() async {
    dynamicMaster.displayLoadingModal(context);

    var response = await apiService.submitJobCardAction(
      context.read<UserProvider>().user!.token,
      widget.jobCardDetailObj.docEntry,
      actionInputController.text,
    );

    Navigator.of(context).pop(); // close loading modal

    if (response["status"] == "success") {
      dynamicMaster.displaySuccessMessage(context, response["message"]);

      // After a successful submission, re-fetch the data
      getJobCardActionDetails();
    } else {
      dynamicMaster.displayError(context, "Error", response["message"]);
    }
  }

  Future<void> addJobCardAction() async {
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
                        closeButtonWidget,
                      ],
                    ),
                    const SizedBox(height: 0),
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: "Action JobCard",
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
                      "please fill the form below to action the jobcard",
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
                                "Enter Action:",
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
                          DropdownSearch<JobCardActionModal>(
                            asyncItems: (String? filter) =>
                                getJobCardAction(filter),
                            popupProps:
                                PopupPropsMultiSelection.modalBottomSheet(
                                  showSelectedItems: true,
                                  itemBuilder: _jobCardActionPopupBuilder,
                                  showSearchBox: true,
                                ),
                            compareFn: (item, sItem) => item.name == sItem.name,
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                labelText: 'Select Jobcard Action',
                                labelStyle: const TextStyle(
                                  color: kPrimaryColor,
                                ),
                                filled: true,
                                fillColor: kPrimaryLightColor,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: actionHasError
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
                                  actionHasError = false;
                                  actionInputController.text = value.id
                                      .toString();
                                });
                              } else {
                                setState(() {
                                  actionHasError = true;
                                  actionInputController.clear();
                                });
                              }
                            },
                          ),
                          SizedBox(height: size.height * 0.02),
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
                                  if (actionInputController.text.isEmpty) {
                                    setState(() {
                                      actionHasError = true;
                                    });
                                  } else {
                                    setState(() {
                                      actionHasError = false;
                                    });
                                    Navigator.of(context).pop();
                                    submitJobCardAction();
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

  Widget buildSparePartsTable({
    required List<JobCardActionDetailsModal> spareParts,
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
          ],
          rows: List<DataRow>.generate(spareParts.length, (index) {
            final item = spareParts[index];
            return DataRow(
              cells: [
                DataCell(
                  SizedBox(
                    width: size.width * 0.4,
                    child: Text(item.jobStatus),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: size.width * 0.4,
                    child: Text(
                      DateFormat(
                        'dd-MMMM-yyyy',
                      ).format(DateTime.parse(item.date)),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
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
          SizedBox(height: size.height * 0.02),
          if (!widget.isClosed)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: kSecondaryColor2,
                  splashColor: Colors.white.withAlpha(100),
                  highlightColor: kSecondaryColor2,
                  onPressed: () {
                    addJobCardAction();
                  },
                  child: const Row(
                    children: [Icon(Icons.add), Text("Action JobCard")],
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 100, child: Text('Status:')),
                SizedBox(width: 100, child: Text('Date:')),
              ],
            ),
          ),

          // Table of REQUESTED PARTS
          buildSparePartsTable(
            spareParts: jobCardAcctionList,
            emptyMessage: "No JobCard Action found",
          ),
        ],
      ),
    );
  }
}
