import 'package:flutter/material.dart';
import '../../../components/dynamic_widgets.dart';
import '../../../modals/jobcard_details_modal.dart';

class ProductInfoTab extends StatelessWidget {
  final JobCardDetailsModal jobCardDetailObj;
  final DynamicMaster dynamicMaster = DynamicMaster();

  ProductInfoTab({super.key, required this.jobCardDetailObj});

  Widget _buildInfoRow(IconData icon, String label, String value, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Details Section
          Container(
            padding: EdgeInsets.all(16),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.devices, color: Colors.blue.shade700, size: 24),
                    SizedBox(width: 8),
                    Text(
                      "Product Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
                Divider(height: 24, thickness: 1),
                _buildInfoRow(
                  Icons.shopping_bag,
                  "Product Name",
                  jobCardDetailObj.itemName ?? "N/A",
                  Colors.blue,
                ),
                _buildInfoRow(
                  Icons.qr_code,
                  "Item Code",
                  jobCardDetailObj.itemCode ?? "N/A",
                  Colors.purple,
                ),
                _buildInfoRow(
                  Icons.memory,
                  "Model Number",
                  jobCardDetailObj.modelNo ?? "N/A",
                  Colors.orange,
                ),
                _buildInfoRow(
                  Icons.tag,
                  "Serial Number",
                  jobCardDetailObj.serialNo ?? "N/A",
                  Colors.green,
                ),
              ],
            ),
          ),

          SizedBox(height: 16),

          // Warranty Details Section
          Container(
            padding: EdgeInsets.all(16),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.shield, color: Colors.green.shade700, size: 24),
                    SizedBox(width: 8),
                    Text(
                      "Warranty Information",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
                Divider(height: 24, thickness: 1),
                
                // Warranty Status Badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: jobCardDetailObj.underWarranty == "YES"
                        ? Colors.green.shade50
                        : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: jobCardDetailObj.underWarranty == "YES"
                          ? Colors.green.shade300
                          : Colors.red.shade300,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        jobCardDetailObj.underWarranty == "YES"
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: jobCardDetailObj.underWarranty == "YES"
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                        size: 28,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              jobCardDetailObj.underWarranty == "YES"
                                  ? "Under Warranty"
                                  : "Out of Warranty",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: jobCardDetailObj.underWarranty == "YES"
                                    ? Colors.green.shade700
                                    : Colors.red.shade700,
                              ),
                            ),
                            if (jobCardDetailObj.warrantyCardNo != null &&
                                jobCardDetailObj.warrantyCardNo != "")
                              Text(
                                "Card: ${jobCardDetailObj.warrantyCardNo}",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                if (jobCardDetailObj.dateOfPurchase != null) ...[
                  SizedBox(height: 16),
                  _buildInfoRow(
                    Icons.calendar_today,
                    "Date of Purchase",
                    jobCardDetailObj.dateOfPurchase ?? "N/A",
                    Colors.blue,
                  ),
                ],
              ],
            ),
          ),

          SizedBox(height: 16),

          // Product Condition Section
          Container(
            padding: EdgeInsets.all(16),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.assessment, color: Colors.orange.shade700, size: 24),
                    SizedBox(width: 8),
                    Text(
                      "Product Condition",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
                Divider(height: 24, thickness: 1),
                _buildInfoRow(
                  Icons.warning_amber,
                  "Reported Fault",
                  jobCardDetailObj.fault ?? "N/A",
                  Colors.red,
                ),
                _buildInfoRow(
                  Icons.broken_image,
                  "Damages",
                  jobCardDetailObj.damage ?? "None",
                  Colors.orange,
                ),
                _buildInfoRow(
                  Icons.build_circle,
                  "Missing Parts",
                  jobCardDetailObj.missingPart ?? "None",
                  Colors.purple,
                ),
                if (jobCardDetailObj.remarks != null &&
                    jobCardDetailObj.remarks != "") ...[
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.note, size: 16, color: Colors.blue.shade700),
                            SizedBox(width: 6),
                            Text(
                              "Additional Remarks",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
                        Text(
                          jobCardDetailObj.remarks ?? "",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          SizedBox(height: 16),
        ],
      ),
    );
  }
}