// To parse this JSON data, do
//
//     final afterSalePickUpProductModal = afterSalePickUpProductModalFromJson(jsonString);

import 'dart:convert';

AfterSalePickUpProductModal afterSalePickUpProductModalFromJson(String str) => AfterSalePickUpProductModal.fromJson(json.decode(str));

String afterSalePickUpProductModalToJson(AfterSalePickUpProductModal data) => json.encode(data.toJson());

class AfterSalePickUpProductModal {
    int id;
    int complaintId;
    int driverId;
    String serialNo;
    String status;
    DateTime createdAt;
    int createdBy;
    String complaintNo;
    String customerName;
    String customerEmail;
    String customerMobile;
    String town;
    String productName;
    String productModelNo;
    String productStatus;
    dynamic productImage;
    dynamic itemCode;
    dynamic codeBars;
    dynamic itemGroup;

    AfterSalePickUpProductModal({
        required this.id,
        required this.complaintId,
        required this.driverId,
        required this.serialNo,
        required this.status,
        required this.createdAt,
        required this.createdBy,
        required this.complaintNo,
        required this.customerName,
        required this.customerEmail,
        required this.customerMobile,
        required this.town,
        required this.productName,
        required this.productModelNo,
        required this.productStatus,
        required this.productImage,
        required this.itemCode,
        required this.codeBars,
        required this.itemGroup,
    });

    factory AfterSalePickUpProductModal.fromJson(Map<String, dynamic> json) => AfterSalePickUpProductModal(
        id: json["id"],
        complaintId: json["complaintId"],
        driverId: json["driver_id"],
        serialNo: json["serialNo"],
        status: json["status"],
        createdAt: DateTime.parse(json["createdAt"]),
        createdBy: json["createdBy"],
        complaintNo: json["complaintNo"],
        customerName: json["customerName"],
        customerEmail: json["customerEmail"],
        customerMobile: json["customerMobile"],
        town: json["town"],
        productName: json["productName"],
        productModelNo: json["productModelNo"],
        productStatus: json["productStatus"],
        productImage: json["productImage"],
        itemCode: json["itemCode"],
        codeBars: json["codeBars"],
        itemGroup: json["itemGroup"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "complaintId": complaintId,
        "driver_id": driverId,
        "serialNo": serialNo,
        "status": status,
        "createdAt": createdAt.toIso8601String(),
        "createdBy": createdBy,
        "complaintNo": complaintNo,
        "customerName": customerName,
        "customerEmail": customerEmail,
        "customerMobile": customerMobile,
        "town": town,
        "productName": productName,
        "productModelNo": productModelNo,
        "productStatus": productStatus,
        "productImage": productImage,
        "itemCode": itemCode,
        "codeBars": codeBars,
        "itemGroup": itemGroup,
    };
}
