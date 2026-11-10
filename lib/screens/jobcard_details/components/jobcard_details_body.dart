// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../components/dynamic_widgets.dart';
import '../../../modals/jobcard_details_modal.dart';
import '../../../modals/jobcard_spare_parts_modal.dart';
import '../../../providers/user_provider.dart';
import '../../../screens/jobcard_details/components/diagnosis_info_tab.dart';
import '../../../screens/jobcard_details/components/product_info_tab.dart';
import '../../../screens/jobcard_details/components/spare_parts_tab.dart';
import '../../../screens/jobcard_details/components/resolution_tab.dart';
import '../../../services/api_services.dart';
import 'package:provider/provider.dart';

import 'job_card_action_tab.dart';

class JobCardDetailsBody extends StatefulWidget {
  final JobCardDetailsModal jobCardDetailObj;
  const JobCardDetailsBody({super.key, required this.jobCardDetailObj});

  @override
  State<JobCardDetailsBody> createState() => _JobCardDetailsBodyState();
}

class _JobCardDetailsBodyState extends State<JobCardDetailsBody> {
  ApiService apiService = ApiService();
  DynamicMaster dynamicMaster = DynamicMaster();
  UserProvider userProvider = UserProvider();

  bool isLoading = false;

  List<JobCardSparePartsModal> jobCardSparePartsList = [];

  bool sparePartHasError = false;
  bool remarksHasError = false;

  TextEditingController sparePartInputController = TextEditingController();
  TextEditingController remarksInputController = TextEditingController();

  String _getJobCardStatusLabel(dynamic jobCardStatus, String sapStatus) {
    final sapLower = sapStatus.toLowerCase();
    // SAP Status: "O", "Open", "C", "Closed"
    if (sapLower == 'c' || sapLower == 'closed') return "CLOSED";
    if (sapLower == 'o' || sapLower == 'open') return "OPEN";
    return "OPEN";
  }

  Color _getJobCardStatusColor(dynamic jobCardStatus, String sapStatus) {
    final label = _getJobCardStatusLabel(jobCardStatus, sapStatus);
    return label == "OPEN" ? Colors.green.shade400 : Colors.grey.shade400;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      userProvider = Provider.of<UserProvider>(context, listen: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          // Modern App Bar Header
          SliverAppBar(
            expandedHeight: size.height * 0.18,
            floating: false,
            pinned: true,
            backgroundColor: Colors.blue.shade700,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blue.shade800,
                      Colors.blue.shade600,
                      Colors.lightBlue.shade400,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.04,
                      vertical: size.height * 0.01,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.receipt_long,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      widget.jobCardDetailObj.jobCardNo,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Complaint: ${widget.jobCardDetailObj.complaintNo}",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _getJobCardStatusColor(
                                  widget.jobCardDetailObj.jobCardStatus,
                                  widget.jobCardDetailObj.status,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _getJobCardStatusLabel(
                                  widget.jobCardDetailObj.jobCardStatus,
                                  widget.jobCardDetailObj.status,
                                ),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Quick Info Cards
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(size.width * 0.04),
              child: Column(
                children: [
                  // Customer Card
                  Container(
                    padding: EdgeInsets.all(size.width * 0.04),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.person,
                            color: Colors.blue.shade700,
                            size: 28,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.jobCardDetailObj.customerName,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.phone,
                                    size: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    widget.jobCardDetailObj.customerPhoneNumber,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 2),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    widget.jobCardDetailObj.customerTown ??
                                        "N/A",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right, color: Colors.grey.shade400),
                      ],
                    ),
                  ),

                  SizedBox(height: 12),

                  // Date Info Row
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 20,
                                color: Colors.blue.shade700,
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Created",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                DateFormat('dd MMM').format(
                                  DateTime.parse(
                                    widget.jobCardDetailObj.createDate,
                                  ),
                                ),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.build,
                                size: 20,
                                color: Colors.orange.shade700,
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Technician",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                widget.jobCardDetailObj.technician ?? "N/A",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade800,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Tabs Section
                  SizedBox(
                    height: size.height * 0.65,
                    child: DefaultTabController(
                      length: 5,
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TabBar(
                              indicatorSize: TabBarIndicatorSize.tab,
                              dividerColor: Colors.transparent,
                              indicator: BoxDecoration(
                                color: Colors.blue.shade700,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              labelColor: Colors.white,
                              unselectedLabelColor: Colors.grey.shade600,
                              labelStyle: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                              unselectedLabelStyle: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.normal,
                              ),
                              tabs: [
                                Tab(
                                  icon: Icon(Icons.info_outline, size: 18),
                                  text: "Info",
                                ),
                                Tab(
                                  icon: Icon(Icons.medical_services, size: 18),
                                  text: "Diagnosis",
                                ),
                                Tab(
                                  icon: Icon(Icons.build_circle, size: 18),
                                  text: "Parts",
                                ),
                                Tab(
                                  icon: Icon(
                                    Icons.check_circle_outline,
                                    size: 18,
                                  ),
                                  text: "Resolution",
                                ),
                                Tab(
                                  icon: Icon(Icons.history, size: 18),
                                  text: "Actions",
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12),
                          Expanded(
                            child: TabBarView(
                              children: [
                                ProductInfoTab(
                                  jobCardDetailObj: widget.jobCardDetailObj,
                                ),
                                DiagnosisInfoTab(
                                  jobCardDetailObj: widget.jobCardDetailObj,
                                  isClosed:
                                      _getJobCardStatusLabel(
                                        widget.jobCardDetailObj.jobCardStatus,
                                        widget.jobCardDetailObj.status,
                                      ) ==
                                      "CLOSED",
                                ),
                                SparePartsTab(
                                  jobCardDetailObj: widget.jobCardDetailObj,
                                  isClosed:
                                      _getJobCardStatusLabel(
                                        widget.jobCardDetailObj.jobCardStatus,
                                        widget.jobCardDetailObj.status,
                                      ) ==
                                      "CLOSED",
                                ),
                                ResolutionTab(
                                  jobCardDetailObj: widget.jobCardDetailObj,
                                  isClosed:
                                      _getJobCardStatusLabel(
                                        widget.jobCardDetailObj.jobCardStatus,
                                        widget.jobCardDetailObj.status,
                                      ) ==
                                      "CLOSED",
                                ),
                                JobCardActionTab(
                                  jobCardDetailObj: widget.jobCardDetailObj,
                                  isClosed:
                                      _getJobCardStatusLabel(
                                        widget.jobCardDetailObj.jobCardStatus,
                                        widget.jobCardDetailObj.status,
                                      ) ==
                                      "CLOSED",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
