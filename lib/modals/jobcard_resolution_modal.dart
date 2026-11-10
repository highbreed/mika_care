// To parse this JSON data, do
//
//     final jobCardResolutionModal = jobCardResolutionModalFromJson(jsonString);

import 'dart:convert';

JobCardResolutionModal jobCardResolutionModalFromJson(String str) =>
    JobCardResolutionModal.fromJson(json.decode(str));

String jobCardResolutionModalToJson(JobCardResolutionModal data) =>
    json.encode(data.toJson());

class JobCardResolutionModal {
  dynamic id;
  dynamic docEntry;
  dynamic lineId;
  dynamic resolutionCode;
  dynamic resolutionName;
  dynamic remarks;
  dynamic status;
  dynamic createdBy;
  dynamic createdDate;
  dynamic updatedBy;
  dynamic updatedDate;

  JobCardResolutionModal({
    required this.id,
    required this.docEntry,
    required this.lineId,
    required this.resolutionCode,
    required this.resolutionName,
    required this.remarks,
    required this.status,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
  });

  factory JobCardResolutionModal.fromJson(Map<String, dynamic> json) =>
      JobCardResolutionModal(
        id: json["id"],
        docEntry: json["DocEntry"] ?? json["docEntry"],
        lineId: json["lineId"] ?? json["jobCardNumber"],
        resolutionCode: json["resolutionCode"],
        resolutionName: json["solutionName"] ?? json["resolutionName"],
        remarks: json["solutionDescription"] ?? json["remarks"],
        status: json["U_Posted"] ?? json["status"],
        createdBy: json["createdBy"],
        createdDate: json["dateCreated"] ?? json["createdDate"],
        updatedBy: json["updatedBy"],
        updatedDate: json["updatedDate"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "docEntry": docEntry,
    "lineId": lineId,
    "resolutionCode": resolutionCode,
    "resolutionName": resolutionName,
    "remarks": remarks,
    "status": status,
    "createdBy": createdBy,
    "createdDate": createdDate,
    "updatedBy": updatedBy,
    "updatedDate": updatedDate,
  };
}
