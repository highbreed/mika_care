import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import '../../../components/dynamic_widgets.dart';
import '../../../constants/main_constants.dart';
import '../../../modals/jobcard_details_modal.dart';
import '../../../modals/resolution_modal.dart';
import '../../../modals/jobcard_resolution_modal.dart';
import '../../../providers/user_provider.dart';
import '../../../services/api_services.dart';
import 'package:provider/provider.dart';

class ResolutionTab extends StatefulWidget {
  final JobCardDetailsModal jobCardDetailObj;
  final bool isClosed;
  const ResolutionTab({
    super.key,
    required this.jobCardDetailObj,
    this.isClosed = false,
  });

  @override
  State<ResolutionTab> createState() => _ResolutionTabState();
}

class _ResolutionTabState extends State<ResolutionTab> {
  ApiService apiService = ApiService();
  DynamicMaster dynamicMaster = DynamicMaster();
  UserProvider userProvider = UserProvider();

  bool isLoading = false;
  List<JobCardResolutionModal> resolutions = [];

  bool resolutionHasError = false;
  bool remarksHasError = false;

  TextEditingController resolutionInputController = TextEditingController();
  TextEditingController remarksInputController = TextEditingController();

  @override
  void initState() {
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

      var response = await apiService.filterJobCardResolutions({
        "token": context.read<UserProvider>().user!.token,
        "jobCardDocEntry": widget.jobCardDetailObj.docEntry,
      });

      print(response);

      if (response["status"] == "success" && response["data_obj"].length > 0) {
        List<JobCardResolutionModal> minResolutions = [];

        for (var item in response["data_obj"]) {
          minResolutions.add(jobCardResolutionModalFromJson(jsonEncode(item)));
        }

        setState(() {
          resolutions = minResolutions;
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

  Future<List<ResolutionModal>> getResolutions(filter) async {
    var response = await apiService.filterResolutions(
      context.read<UserProvider>().user!.token,
      widget.jobCardDetailObj.itemGroup1,
    );

    print(response);

    if (response.isNotEmpty &&
        response["status"] == "success" &&
        response["data_obj"] != null) {
      List<ResolutionModal> resolutionList = [];

      for (var itemGroup in response["data_obj"]) {
        ResolutionModal resolution = resolutionModalFromJson(
          jsonEncode(itemGroup),
        );
        resolutionList.add(resolution);
      }
      return resolutionList;
    } else {
      return [];
    }
  }

  Widget _resolutionPopupBuilder(
    BuildContext context,
    ResolutionModal item,
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

  Future<void> submitResolution() async {
    dynamicMaster.displayLoadingModal(context);

    var response = await apiService.submitJobCardResolution(
      context.read<UserProvider>().user!.token,
      widget.jobCardDetailObj.docEntry,
      resolutionInputController.text,
      remarksInputController.text,
    );

    Navigator.of(context).pop();

    if (response["status"] == "success") {
      resolutionInputController.clear();
      remarksInputController.clear();
      dynamicMaster.displaySuccessMessage(context, response["message"]);
      initScreen();
    } else {
      dynamicMaster.displayError(context, "Error", response["message"]);
    }
  }

  Future<void> addResolutionModal() async {
    Size size = MediaQuery.of(context).size;

    IconButton closeButtonWidget = IconButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      icon: const Icon(Icons.clear, size: 30),
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
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.05,
                    vertical: size.height * 0.02,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Add Resolution",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          closeButtonWidget,
                        ],
                      ),
                      SizedBox(height: size.height * 0.02),
                      DropdownSearch<ResolutionModal>(
                        asyncItems: (String? filter) => getResolutions(filter),
                        compareFn: (i, s) => i.id == s.id,
                        itemAsString: (ResolutionModal item) => item.name,
                        popupProps: PopupPropsMultiSelection.modalBottomSheet(
                          showSelectedItems: true,
                          showSearchBox: true,
                          itemBuilder: _resolutionPopupBuilder,
                        ),
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: "Select Resolution",
                            hintText: "Search resolution",
                            labelStyle: const TextStyle(color: kPrimaryColor),
                            filled: true,
                            fillColor: kPrimaryLightColor,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: resolutionHasError
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            errorText: resolutionHasError
                                ? "Resolution is required"
                                : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            iconColor: kPrimaryColor,
                            prefixIconColor: kPrimaryColor,
                          ),
                          baseStyle: const TextStyle(color: kPrimaryColor),
                        ),
                        onChanged: (ResolutionModal? data) {
                          if (data != null) {
                            setState(() {
                              resolutionInputController.text = data.id
                                  .toString();
                              resolutionHasError = false;
                            });
                          } else {
                            setState(() {
                              resolutionHasError = true;
                              resolutionInputController.clear();
                            });
                          }
                        },
                      ),
                      SizedBox(height: size.height * 0.02),
                      TextField(
                        controller: remarksInputController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: "Remarks (Optional)",
                          hintText: "Enter any additional remarks",
                          errorText: remarksHasError
                              ? "Remarks cannot be empty"
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.02,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: () {
                            if (resolutionInputController.text.isEmpty) {
                              setState(() {
                                resolutionHasError = true;
                              });
                            } else {
                              setState(() {
                                resolutionHasError = false;
                              });
                              Navigator.of(context).pop();
                              submitResolution();
                            }
                          },
                          child: const Text(
                            "Submit Resolution",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Column(
        children: [
          SizedBox(height: size.height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Resolutions",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              if (!widget.isClosed)
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () {
                    addResolutionModal();
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    "Add Resolution",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            ],
          ),
          SizedBox(height: size.height * 0.02),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : resolutions.isEmpty
                ? const Center(
                    child: Text(
                      "No resolutions added yet",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: resolutions.length,
                    itemBuilder: (context, index) {
                      final resolution = resolutions[index];
                      return Card(
                        margin: EdgeInsets.only(bottom: size.height * 0.02),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(size.width * 0.04),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      resolution.resolutionName ?? "Resolution",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade100,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      resolution.status ?? "Active",
                                      style: TextStyle(
                                        color: Colors.green.shade700,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (resolution.remarks != null &&
                                  resolution.remarks!.isNotEmpty) ...[
                                SizedBox(height: size.height * 0.01),
                                Text(
                                  "Remarks: ${resolution.remarks}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                              SizedBox(height: size.height * 0.01),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.person,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "By: ${resolution.createdBy ?? 'Unknown'}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  const Icon(
                                    Icons.calendar_today,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    resolution.createdDate ?? "",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
