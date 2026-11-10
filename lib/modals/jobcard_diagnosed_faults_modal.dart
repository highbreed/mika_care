// To parse this JSON data, do
//
//     final jobCardDiagnosedFaultModel = jobCardDiagnosedFaultModelFromJson(jsonString);

import 'dart:convert';

JobCardDiagnosedFaultModel jobCardDiagnosedFaultModelFromJson(String str) =>
    JobCardDiagnosedFaultModel.fromJson(json.decode(str));

String jobCardDiagnosedFaultModelToJson(JobCardDiagnosedFaultModel data) =>
    json.encode(data.toJson());

class JobCardDiagnosedFaultModel {
  String docEntry;
  String jobCardNumber;
  String fault;
  // String uPosted;
  String subFault;
  String dateCreated;

  JobCardDiagnosedFaultModel({
    required this.docEntry,
    required this.jobCardNumber,
    required this.fault,
    // required this.uPosted,
    required this.subFault,
    required this.dateCreated,
  });

  factory JobCardDiagnosedFaultModel.fromJson(Map<String, dynamic> json) =>
      JobCardDiagnosedFaultModel(
        docEntry: json["DocEntry"],
        jobCardNumber: json["jobCardNumber"],
        fault: json["fault"],
        // uPosted: json["U_Posted"],
        subFault: json["subFault"],
        dateCreated: json["dateCreated"],
      );

  Map<String, dynamic> toJson() => {
    "DocEntry": docEntry,
    "jobCardNumber": jobCardNumber,
    "fault": fault,
    // "U_Posted": uPosted,
    "subFault": subFault,
    "dateCreated": dateCreated,
  };
}
