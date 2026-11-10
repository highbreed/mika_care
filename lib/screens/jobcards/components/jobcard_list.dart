// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../components/dynamic_widgets.dart';
import '../../../constants/main_constants.dart';
import '../../../modals/jobcard_details_modal.dart';
import '../../../modals/jobcard_modal.dart';
import '../../../providers/user_provider.dart';
import '../../../services/api_services.dart';
import 'package:provider/provider.dart';

class JobCardList extends StatefulWidget {
  final String status;
  final bool showFilter;
  const JobCardList({super.key, required this.status, this.showFilter = false});

  @override
  State<JobCardList> createState() => _JobCardListState();
}

class _JobCardListState extends State<JobCardList> {
  ApiService apiService = ApiService();
  DynamicMaster dynamicMaster = DynamicMaster();

  bool isLoading = false;
  DateTime currentDate = DateTime.now();

  List<JobcardModal> jobCardList = [];
  List<JobcardModal> filteredJobCardList = [];
  final TextEditingController _searchController = TextEditingController();

  // Filter state
  String _selectedStatus = "all";
  DateTime? _dateFrom;
  DateTime? _dateTo;
  bool _filtersApplied = false;
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _jobCardNumberController =
      TextEditingController();
  final TextEditingController _complaintNumberController =
      TextEditingController();

  final List<Map<String, String>> _statusOptions = [
    {"value": "all", "label": "All"},
    {"value": "pending", "label": "Pending"},
    {"value": "active", "label": "Active"},
    {"value": "completed", "label": "Completed"},
    {"value": "closed", "label": "Closed"},
  ];

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _customerNameController.dispose();
    _jobCardNumberController.dispose();
    _complaintNumberController.dispose();
    super.dispose();
  }

  void _filterList(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredJobCardList = List.from(jobCardList);
      } else {
        final lowerQuery = query.toLowerCase();
        filteredJobCardList = jobCardList.where((card) {
          return (card.jobCardDocNo ?? '').toString().toLowerCase().contains(
                lowerQuery,
              ) ||
              (card.customerName ?? '').toString().toLowerCase().contains(
                lowerQuery,
              ) ||
              (card.modelNo ?? '').toString().toLowerCase().contains(
                lowerQuery,
              ) ||
              (card.customerTown ?? '').toString().toLowerCase().contains(
                lowerQuery,
              );
        }).toList();
      }
    });
  }

  Future<void> _refresh({Map<String, dynamic>? extraFilters}) async {
    setState(() {
      isLoading = true;
      jobCardList = [];
      filteredJobCardList = [];
    });

    Map<String, dynamic> params = {
      "token": context.read<UserProvider>().user!.token,
      "technicianId": context.read<UserProvider>().user!.userId,
    };

    // For active tab, always use widget.status
    // For history tab with filters, use selected status or omit for "all"
    if (extraFilters != null) {
      params.addAll(extraFilters);
    } else {
      params["status"] = widget.status;
    }

    var response = await apiService.filterJobCards(params);

    if (response["status"] == "success" &&
        response["data_obj"] != null &&
        response["data_obj"].length > 0) {
      List<JobcardModal> minJobCardList = [];

      for (var item in response["data_obj"]) {
        minJobCardList.add(jobcardModalFromJson(jsonEncode(item)));
      }
      setState(() {
        jobCardList = minJobCardList;
        filteredJobCardList = List.from(minJobCardList);
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _applyFilters() async {
    Map<String, dynamic> filters = {};

    if (_selectedStatus != "all") {
      filters["status"] = _selectedStatus;
    }

    if (_dateFrom != null) {
      filters["dateRange_filter_from"] = DateFormat(
        'yyyy-MM-dd',
      ).format(_dateFrom!);
    }

    if (_dateTo != null) {
      filters["dateRange_filter_to"] = DateFormat(
        'yyyy-MM-dd',
      ).format(_dateTo!);
    }

    if (_customerNameController.text.isNotEmpty) {
      filters["customerName"] = _customerNameController.text;
    }

    if (_jobCardNumberController.text.isNotEmpty) {
      filters["jobCardDocNo"] = _jobCardNumberController.text;
    }

    if (_complaintNumberController.text.isNotEmpty) {
      filters["complaintNo"] = _complaintNumberController.text;
    }

    setState(() {
      _filtersApplied =
          _selectedStatus != "all" ||
          _dateFrom != null ||
          _dateTo != null ||
          _customerNameController.text.isNotEmpty ||
          _jobCardNumberController.text.isNotEmpty ||
          _complaintNumberController.text.isNotEmpty;
    });

    await _refresh(extraFilters: filters.isNotEmpty ? filters : null);
  }

  void _clearFilters() {
    setState(() {
      _selectedStatus = "all";
      _dateFrom = null;
      _dateTo = null;
      _customerNameController.clear();
      _jobCardNumberController.clear();
      _complaintNumberController.clear();
      _filtersApplied = false;
    });
    _refresh();
  }

  Future<DateTime?> _pickDate(DateTime? initial) async {
    return showDatePicker(
      context: context,
      initialDate: initial ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: kSecondaryColor,
              onPrimary: Colors.white,
              onSurface: kPrimaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
  }

  Widget _buildFilterChip(String label) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: kSecondaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: kSecondaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _showFilterModal() {
    String tempStatus = _selectedStatus;
    DateTime? tempDateFrom = _dateFrom;
    DateTime? tempDateTo = _dateTo;
    final tempCustomerName = TextEditingController(
      text: _customerNameController.text,
    );
    final tempJobCardNumber = TextEditingController(
      text: _jobCardNumberController.text,
    );
    final tempComplaintNumber = TextEditingController(
      text: _complaintNumberController.text,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle bar
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Title row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Filter Job Cards",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setModalState(() {
                              tempStatus = "all";
                              tempDateFrom = null;
                              tempDateTo = null;
                              tempCustomerName.clear();
                              tempJobCardNumber.clear();
                              tempComplaintNumber.clear();
                            });
                          },
                          child: const Text(
                            "Reset",
                            style: TextStyle(color: kSecondaryColor),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Status filter
                    const Text(
                      "Status",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: kPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _statusOptions.map((option) {
                        final isSelected = tempStatus == option["value"];
                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              tempStatus = option["value"]!;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? kSecondaryColor
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? kSecondaryColor
                                    : Colors.grey.shade300,
                              ),
                            ),
                            child: Text(
                              option["label"]!,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey.shade700,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // Job Card Number
                    const Text(
                      "Job Card Number",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: kPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: tempJobCardNumber,
                      decoration: InputDecoration(
                        hintText: "Enter job card number",
                        hintStyle: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade500,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(
                          Icons.description_outlined,
                          size: 18,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Customer Name
                    const Text(
                      "Customer Name",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: kPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: tempCustomerName,
                      decoration: InputDecoration(
                        hintText: "Enter customer name",
                        hintStyle: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade500,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(
                          Icons.person_outline,
                          size: 18,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Complaint Number
                    const Text(
                      "Complaint Number",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: kPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: tempComplaintNumber,
                      decoration: InputDecoration(
                        hintText: "Enter complaint number",
                        hintStyle: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade500,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(
                          Icons.report_outlined,
                          size: 18,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Date range filter
                    const Text(
                      "Date Range",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: kPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final picked = await _pickDate(tempDateFrom);
                              if (picked != null) {
                                setModalState(() {
                                  tempDateFrom = picked;
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    size: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    tempDateFrom != null
                                        ? DateFormat(
                                            'dd MMM yyyy',
                                          ).format(tempDateFrom!)
                                        : "From",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: tempDateFrom != null
                                          ? kPrimaryColor
                                          : Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(
                            Icons.arrow_forward,
                            size: 16,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final picked = await _pickDate(tempDateTo);
                              if (picked != null) {
                                setModalState(() {
                                  tempDateTo = picked;
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    size: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    tempDateTo != null
                                        ? DateFormat(
                                            'dd MMM yyyy',
                                          ).format(tempDateTo!)
                                        : "To",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: tempDateTo != null
                                          ? kPrimaryColor
                                          : Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Apply button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kSecondaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _selectedStatus = tempStatus;
                            _dateFrom = tempDateFrom;
                            _dateTo = tempDateTo;
                            _customerNameController.text =
                                tempCustomerName.text;
                            _jobCardNumberController.text =
                                tempJobCardNumber.text;
                            _complaintNumberController.text =
                                tempComplaintNumber.text;
                          });
                          Navigator.pop(context);
                          _applyFilters();
                        },
                        child: const Text(
                          "Apply Filters",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> fetchJobCardDetails(String jobCardNumber) async {
    dynamicMaster.displayLoadingModal(context);

    var response = await apiService.getJobCardDetails(
      jobCardNumber,
      context.read<UserProvider>().user!.token,
    );

    Navigator.pop(context);

    if (response["status"] == "success") {
      Navigator.pushNamed(
        context,
        "/jobcard_detail",
        arguments: jobCardDetailsModalFromJson(
          jsonEncode(response["data_obj"]),
        ),
      );
    } else {
      dynamicMaster.displayError(context, "Error", response["message"]);
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'active':
        return Colors.green;
      case 'completed':
        return kBlueColor;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search bar with filter button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterList,
                  decoration: InputDecoration(
                    hintText: "Search job cards...",
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 20),
                            onPressed: () {
                              _searchController.clear();
                              _filterList('');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              if (widget.showFilter) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _showFilterModal,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _filtersApplied
                          ? kSecondaryColor
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.tune,
                      size: 22,
                      color: _filtersApplied
                          ? Colors.white
                          : Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        // Active filter chips
        if (widget.showFilter && _filtersApplied)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        if (_selectedStatus != "all")
                          _buildFilterChip(
                            "Status: ${_statusOptions.firstWhere((o) => o["value"] == _selectedStatus)["label"]}",
                          ),
                        if (_dateFrom != null)
                          _buildFilterChip(
                            "From: ${DateFormat('dd MMM').format(_dateFrom!)}",
                          ),
                        if (_dateTo != null)
                          _buildFilterChip(
                            "To: ${DateFormat('dd MMM').format(_dateTo!)}",
                          ),
                        if (_customerNameController.text.isNotEmpty)
                          _buildFilterChip(
                            "Customer: ${_customerNameController.text}",
                          ),
                        if (_jobCardNumberController.text.isNotEmpty)
                          _buildFilterChip(
                            "JC#: ${_jobCardNumberController.text}",
                          ),
                        if (_complaintNumberController.text.isNotEmpty)
                          _buildFilterChip(
                            "Complaint: ${_complaintNumberController.text}",
                          ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _clearFilters,
                  child: const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Text(
                      "Clear",
                      style: TextStyle(
                        color: kSecondaryColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        // List content
        Expanded(
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: kSecondaryColor),
                )
              : RefreshIndicator(
                  color: kSecondaryColor,
                  onRefresh: _refresh,
                  child: filteredJobCardList.isEmpty
                      ? ListView(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.2,
                            ),
                            Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.assignment_outlined,
                                    size: 64,
                                    color: Colors.grey.shade300,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    _searchController.text.isNotEmpty
                                        ? "No matching job cards"
                                        : "No job cards found",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade500,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: filteredJobCardList.length,
                          itemBuilder: (BuildContext context, int index) {
                            final card = filteredJobCardList[index];
                            final statusColor = _getStatusColor(
                              (card.status ?? '').toString(),
                            );

                            return GestureDetector(
                              onTap: () {
                                fetchJobCardDetails(card.jobCardDocEntry);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      offset: const Offset(0, 2),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Header row with job card number and status
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade50,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.description_outlined,
                                                size: 18,
                                                color: kSecondaryColor,
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                "#${card.jobCardDocNo ?? ''}",
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: kPrimaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: statusColor.withOpacity(
                                                0.15,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              (card.status ?? '')
                                                  .toString()
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                color: statusColor,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Card body content
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        14,
                                        10,
                                        14,
                                        12,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Product model
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.devices,
                                                size: 16,
                                                color: Colors.grey.shade600,
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  card.modelNo ?? 'N/A',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: kPrimaryColor,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          // Customer name
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.person_outline,
                                                size: 16,
                                                color: Colors.grey.shade600,
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  card.customerName ?? 'N/A',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey.shade700,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          // Location
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.location_on_outlined,
                                                size: 16,
                                                color: Colors.grey.shade600,
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  card.customerTown ?? 'N/A',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey.shade700,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Bottom row with arrow indicator
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                            color: Colors.grey.shade100,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          if (card.scheduleDateFrom != null &&
                                              card.scheduleDateFrom
                                                  .toString()
                                                  .isNotEmpty)
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.calendar_today_outlined,
                                                  size: 14,
                                                  color: Colors.grey.shade500,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  card.scheduleDateFrom
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey.shade500,
                                                  ),
                                                ),
                                              ],
                                            )
                                          else
                                            const SizedBox(),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            size: 14,
                                            color: Colors.grey.shade400,
                                          ),
                                        ],
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
      ],
    );
  }
}
