// To parse this JSON data, do
//
//     final requestedSparePartModal = requestedSparePartModalFromJson(jsonString);

import 'dart:convert';

RequestedSparePartModal requestedSparePartModalFromJson(String str) => RequestedSparePartModal.fromJson(json.decode(str));

String requestedSparePartModalToJson(RequestedSparePartModal data) => json.encode(data.toJson());

class RequestedSparePartModal {
    String jobCardNumber;
    String approvalStatus;
    dynamic requestType;
    dynamic quantity;
    String itemCode;
    String itemName;
    String modelNo;
    dynamic specs;
    dynamic fullDescription;

    RequestedSparePartModal({
        required this.jobCardNumber,
        required this.approvalStatus,
        required this.requestType,
        required this.quantity,
        required this.itemCode,
        required this.itemName,
        required this.modelNo,
        required this.specs,
        required this.fullDescription,
    });

    factory RequestedSparePartModal.fromJson(Map<String, dynamic> json) => RequestedSparePartModal(
        jobCardNumber: json["jobCardNumber"],
        approvalStatus: json["approvalStatus"],
        requestType: json["requestType"],
        quantity: json["quantity"],
        itemCode: json["itemCode"],
        itemName: json["itemName"],
        modelNo: json["modelNo"],
        specs: json["specs"],
        fullDescription: json["fullDescription"],
    );

    Map<String, dynamic> toJson() => {
        "jobCardNumber": jobCardNumber,
        "approvalStatus": approvalStatus,
        "requestType": requestType,
        "quantity": quantity,
        "itemCode": itemCode,
        "itemName": itemName,
        "modelNo": modelNo,
        "specs": specs,
        "fullDescription": fullDescription,
    };
}
