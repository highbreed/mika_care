// To parse this JSON data, do
//
//     final jobCardActionDetailsModal = jobCardActionDetailsModalFromJson(jsonString);

import 'dart:convert';

JobCardActionDetailsModal jobCardActionDetailsModalFromJson(String str) =>
    JobCardActionDetailsModal.fromJson(json.decode(str));

String jobCardActionDetailsModalToJson(JobCardActionDetailsModal data) =>
    json.encode(data.toJson());

class JobCardActionDetailsModal {
  dynamic docEntry;
  dynamic lineId;
  dynamic jobCardNo;
  dynamic jobStatus;
  dynamic posted;
  String date;

  JobCardActionDetailsModal({
    required this.docEntry,
    required this.lineId,
    required this.jobCardNo,
    required this.jobStatus,
    required this.posted,
    required this.date,
  });

  factory JobCardActionDetailsModal.fromJson(Map<String, dynamic> json) =>
      JobCardActionDetailsModal(
        docEntry: json["DocEntry"],
        lineId: json["LineId"],
        jobCardNo: json["U_JobCardNo"],
        jobStatus: json["U_JobStatus"],
        posted: json["U_Posted"],
        date: json["U_Date"] is Map
            ? json["U_Date"]["date"] ?? ""
            : (json["U_Date"] ?? "").toString(),
      );

  Map<String, dynamic> toJson() => {
    "DocEntry": docEntry,
    "LineId": lineId,
    "U_JobCardNo": jobCardNo,
    "U_JobStatus": jobStatus,
    "U_Posted": posted,
    "U_Date": date,
  };
}
