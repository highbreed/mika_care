// To parse this JSON data, do
//
//     final complaintModal = complaintModalFromJson(jsonString);

import 'dart:convert';

ComplaintModal complaintModalFromJson(String str) => ComplaintModal.fromJson(json.decode(str));

String complaintModalToJson(ComplaintModal data) => json.encode(data.toJson());

class ComplaintModal {
    int id;
    String complaintOrigin;
    String complaintNo;
    String docEntryNo;
    String complaintSource;
    String complaintSourceName;
    String productSerialNumber;
    String reportedFault;
    String status;
    dynamic warrantyId;
    dynamic warantyRegDate;
    String customerName;
    String customerEmail;
    String customerMobile;
    String town;
    String productName;
    String productModelNo;
    String dateOfPurchase;
    String productStatus;
    dynamic warrantyPeriod;
    String createdAt;
    int createdBy;
    String updatedAt;
    dynamic updatedBy;
    String createdByFullName;
    dynamic productImage;
    dynamic itemCode;
    dynamic codeBars;
    dynamic itemGroup;

    ComplaintModal({
        required this.id,
        required this.complaintOrigin,
        required this.complaintNo,
        required this.docEntryNo,
        required this.complaintSource,
        required this.complaintSourceName,
        required this.productSerialNumber,
        required this.reportedFault,
        required this.status,
        required this.warrantyId,
        required this.warantyRegDate,
        required this.customerName,
        required this.customerEmail,
        required this.customerMobile,
        required this.town,
        required this.productName,
        required this.productModelNo,
        required this.dateOfPurchase,
        required this.productStatus,
        required this.warrantyPeriod,
        required this.createdAt,
        required this.createdBy,
        required this.updatedAt,
        required this.updatedBy,
        required this.createdByFullName,
        required this.productImage,
        required this.itemCode,
        required this.codeBars,
        required this.itemGroup,
    });

    factory ComplaintModal.fromJson(Map<String, dynamic> json) => ComplaintModal(
        id: json["id"],
        complaintOrigin: json["complaintOrigin"],
        complaintNo: json["complaintNo"],
        docEntryNo: json["docEntryNo"],
        complaintSource: json["complaintSource"],
        complaintSourceName: json["complaintSourceName"],
        productSerialNumber: json["productSerialNumber"],
        reportedFault: json["reportedFault"],
        status: json["status"],
        warrantyId: json["warrantyId"],
        warantyRegDate: json["warantyRegDate"],
        customerName: json["customerName"],
        customerEmail: json["customerEmail"],
        customerMobile: json["customerMobile"],
        town: json["town"],
        productName: json["productName"],
        productModelNo: json["productModelNo"],
        dateOfPurchase: json["dateOfPurchase"],
        productStatus: json["productStatus"],
        warrantyPeriod: json["warrantyPeriod"],
        createdAt: json["createdAt"],
        createdBy: json["createdBy"],
        updatedAt: json["updatedAt"],
        updatedBy: json["updatedBy"],
        createdByFullName: json["createdBy_fullName"],
        productImage: json["productImage"],
        itemCode: json["itemCode"],
        codeBars: json["codeBars"],
        itemGroup: json["itemGroup"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "complaintOrigin": complaintOrigin,
        "complaintNo": complaintNo,
        "docEntryNo": docEntryNo,
        "complaintSource": complaintSource,
        "complaintSourceName": complaintSourceName,
        "productSerialNumber": productSerialNumber,
        "reportedFault": reportedFault,
        "status": status,
        "warrantyId": warrantyId,
        "warantyRegDate": warantyRegDate,
        "customerName": customerName,
        "customerEmail": customerEmail,
        "customerMobile": customerMobile,
        "town": town,
        "productName": productName,
        "productModelNo": productModelNo,
        "dateOfPurchase": dateOfPurchase,
        "productStatus": productStatus,
        "warrantyPeriod": warrantyPeriod,
        "createdAt": createdAt,
        "createdBy": createdBy,
        "updatedAt": updatedAt,
        "updatedBy": updatedBy,
        "createdBy_fullName": createdByFullName,
        "productImage": productImage,
        "itemCode": itemCode,
        "codeBars": codeBars,
        "itemGroup": itemGroup,
    };
}
