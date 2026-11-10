// To parse this JSON data, do
//
//     final jobCardSparePartsModal = jobCardSparePartsModalFromJson(jsonString);

import 'dart:convert';

JobCardSparePartsModal jobCardSparePartsModalFromJson(String str) => JobCardSparePartsModal.fromJson(json.decode(str));

String jobCardSparePartsModalToJson(JobCardSparePartsModal data) => json.encode(data.toJson());

class JobCardSparePartsModal {
  dynamic docEntry;
  dynamic lineId;
  dynamic jobCardNo;
  dynamic itemNumber;
  dynamic itemName;
  dynamic partNumber;
  dynamic unitPrice;
  dynamic amount;
  dynamic prNumber;
  dynamic dateReceived;
  dynamic prDate;
  dynamic posted;
  dynamic warehouseCode;
  dynamic goodsIssueNumber;
  dynamic goodsIssueDate;
  dynamic qtyInStock;
  dynamic quantity;
  dynamic modelNumber;
  dynamic sparePartType;

  JobCardSparePartsModal({
    required this.docEntry,
    required this.lineId,
    required this.jobCardNo,
    required this.itemNumber,
    required this.itemName,
    required this.partNumber,
    required this.unitPrice,
    required this.amount,
    required this.prNumber,
    required this.dateReceived,
    required this.prDate,
    required this.posted,
    required this.warehouseCode,
    required this.goodsIssueNumber,
    required this.goodsIssueDate,
    required this.qtyInStock,
    required this.quantity,
    required this.modelNumber,
    required this.sparePartType,
  });

  factory JobCardSparePartsModal.fromJson(Map<String, dynamic> json) => JobCardSparePartsModal(
    docEntry: json["docEntry"],
    lineId: json["lineId"],
    jobCardNo: json["jobCardNo"],
    itemNumber: json["itemNumber"],
    itemName: json["itemName"],
    partNumber: json["partNumber"],
    unitPrice: json["unitPrice"],
    amount: json["amount"],
    prNumber: json["prNumber"],
    dateReceived: json["dateReceived"],
    prDate: json["prDate"],
    posted: json["posted"],
    warehouseCode: json["warehouseCode"],
    goodsIssueNumber: json["goodsIssueNumber"],
    goodsIssueDate: json["goodsIssueDate"],
    qtyInStock: json["qtyInStock"],
    quantity: json["quantity"],
    modelNumber: json["U_OurModelNo"],
    sparePartType: json["sparePartType"],
  );

  Map<String, dynamic> toJson() => {
    "docEntry": docEntry,
    "lineId": lineId,
    "jobCardNo": jobCardNo,
    "itemNumber": itemNumber,
    "itemName": itemName,
    "partNumber": partNumber,
    "unitPrice": unitPrice,
    "amount": amount,
    "prNumber": prNumber,
    "dateReceived": dateReceived,
    "prDate": prDate,
    "posted": posted,
    "warehouseCode": warehouseCode,
    "goodsIssueNumber": goodsIssueNumber,
    "goodsIssueDate": goodsIssueDate,
    "qtyInStock": qtyInStock,
    "quantity": quantity,
    "U_OurModelNo": modelNumber,
    "sparePartType": sparePartType,
  };
}
