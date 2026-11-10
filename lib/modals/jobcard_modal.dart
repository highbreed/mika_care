// To parse this JSON data, do
//
//     final jobcardModal = jobcardModalFromJson(jsonString);

import 'dart:convert';

JobcardModal jobcardModalFromJson(String str) => JobcardModal.fromJson(json.decode(str));

String jobcardModalToJson(JobcardModal data) => json.encode(data.toJson());

class JobcardModal {
    dynamic id;
    dynamic technicianId;
    dynamic jobCardDocEntry;
    dynamic jobCardDocNo;
    dynamic scheduleDateFrom;
    dynamic scheduleDateTo;
    dynamic startTime;
    dynamic endTime;
    dynamic status;
    dynamic priority;
    dynamic location;
    dynamic description;
    dynamic createdAt;
    dynamic createdBy;
    dynamic updatedAt;
    dynamic updatedBy;
    dynamic technicianFullname;
    dynamic technicianPhoneNumber;
    dynamic createdByFullname;
    dynamic updatedByFullname;
    dynamic complaintNo;
    dynamic complaintType;
    dynamic itemCode;
    dynamic itemName;
    dynamic modelNo;
    dynamic serialNo;
    dynamic fault;
    dynamic missingPart;
    dynamic damage;
    dynamic remarks;
    dynamic underWarranty;
    dynamic customerName;
    dynamic customerEmail;
    dynamic customerMobile;
    dynamic customerTown;

    JobcardModal({
        required this.id,
        required this.technicianId,
        required this.jobCardDocEntry,
        required this.jobCardDocNo,
        required this.scheduleDateFrom,
        required this.scheduleDateTo,
        required this.startTime,
        required this.endTime,
        required this.status,
        required this.priority,
        required this.location,
        required this.description,
        required this.createdAt,
        required this.createdBy,
        required this.updatedAt,
        required this.updatedBy,
        required this.technicianFullname,
        required this.technicianPhoneNumber,
        required this.createdByFullname,
        required this.updatedByFullname,
        required this.complaintNo,
        required this.complaintType,
        required this.itemCode,
        required this.itemName,
        required this.modelNo,
        required this.serialNo,
        required this.fault,
        required this.missingPart,
        required this.damage,
        required this.remarks,
        required this.underWarranty,
        required this.customerName,
        required this.customerEmail,
        required this.customerMobile,
        required this.customerTown,
    });

    factory JobcardModal.fromJson(Map<String, dynamic> json) => JobcardModal(
        id: json["id"],
        technicianId: json["technician_id"],
        jobCardDocEntry: json["jobCardDocEntry"],
        jobCardDocNo: json["jobCardDocNo"],
        scheduleDateFrom: json["scheduleDateFrom"],
        scheduleDateTo: json["scheduleDateTo"],
        startTime: json["startTime"],
        endTime: json["endTime"],
        status: json["status"],
        priority: json["priority"],
        location: json["location"],
        description: json["description"],
        createdAt: json["createdAt"],
        createdBy: json["createdBy"],
        updatedAt: json["updatedAt"],
        updatedBy: json["updatedBy"],
        technicianFullname: json["technician_fullname"],
        technicianPhoneNumber: json["technician_phoneNumber"],
        createdByFullname: json["createdBy_fullname"],
        updatedByFullname: json["updatedBy_fullname"],
        complaintNo: json["complaintNo"],
        complaintType: json["complaintType"],
        itemCode: json["itemCode"],
        itemName: json["itemName"],
        modelNo: json["modelNo"],
        serialNo: json["serialNo"],
        fault: json["fault"],
        missingPart: json["missingPart"],
        damage: json["damage"],
        remarks: json["remarks"],
        underWarranty: json["underWarranty"],
        customerName: json["customerName"],
        customerEmail: json["customerEmail"],
        customerMobile: json["customerMobile"],
        customerTown: json["customerTown"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "technician_id": technicianId,
        "jobCardDocEntry": jobCardDocEntry,
        "jobCardDocNo": jobCardDocNo,
        "scheduleDateFrom": scheduleDateFrom,
        "scheduleDateTo": scheduleDateTo,
        "startTime": startTime,
        "endTime": endTime,
        "status": status,
        "priority": priority,
        "location": location,
        "description": description,
        "createdAt": createdAt,
        "createdBy": createdBy,
        "updatedAt": updatedAt,
        "updatedBy": updatedBy,
        "technician_fullname": technicianFullname,
        "technician_phoneNumber": technicianPhoneNumber,
        "createdBy_fullname": createdByFullname,
        "updatedBy_fullname": updatedByFullname,
        "complaintNo": complaintNo,
        "complaintType": complaintType,
        "itemCode": itemCode,
        "itemName": itemName,
        "modelNo": modelNo,
        "serialNo": serialNo,
        "fault": fault,
        "missingPart": missingPart,
        "damage": damage,
        "remarks": remarks,
        "underWarranty": underWarranty,
        "customerName": customerName,
        "customerEmail": customerEmail,
        "customerMobile": customerMobile,
        "customerTown": customerTown,
    };
}
