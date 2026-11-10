// To parse this JSON data, do
//
//     final deliveryModal = deliveryModalFromJson(jsonString);

import 'dart:convert';

DeliveryModal deliveryModalFromJson(String str) => DeliveryModal.fromJson(json.decode(str));

String deliveryModalToJson(DeliveryModal data) => json.encode(data.toJson());

class DeliveryModal {
    int id;
    String invoiceNo;
    int vehicleId;
    int driverId;
    String deliveryLocation;
    int loadingSequency;
    int createdBy;
    String createdAt;
    dynamic deliveredAt;
    dynamic loadedAt;
    String status;
    String driverFullName;
    String driverPhoneNumber;
    String driverEmail;
    String plateNumber;
    int maxCbm;
    int transporterId;
    String transpoterName;
    String transpoterPhoneNumber;
    String transpoterEmail;
    String customerName;
    String customerPhoneNo;

    DeliveryModal({
        required this.id,
        required this.invoiceNo,
        required this.vehicleId,
        required this.driverId,
        required this.deliveryLocation,
        required this.loadingSequency,
        required this.createdBy,
        required this.createdAt,
        required this.deliveredAt,
        required this.loadedAt,
        required this.status,
        required this.driverFullName,
        required this.driverPhoneNumber,
        required this.driverEmail,
        required this.plateNumber,
        required this.maxCbm,
        required this.transporterId,
        required this.transpoterName,
        required this.transpoterPhoneNumber,
        required this.transpoterEmail,
        required this.customerName,
        required this.customerPhoneNo,
    });

    factory DeliveryModal.fromJson(Map<String, dynamic> json) => DeliveryModal(
        id: json["id"],
        invoiceNo: json["invoiceNo"],
        vehicleId: json["vehicle_id"],
        driverId: json["driver_Id"],
        deliveryLocation: json["deliveryLocation"],
        loadingSequency: json["loadingSequency"],
        createdBy: json["createdBy"],
        createdAt: json["createdAt"],
        deliveredAt: json["deliveredAt"],
        loadedAt: json["loadedAt"],
        status: json["status"],
        driverFullName: json["driver_fullName"],
        driverPhoneNumber: json["driver_phoneNumber"],
        driverEmail: json["driver_email"],
        plateNumber: json["plateNumber"],
        maxCbm: json["maxCbm"],
        transporterId: json["transporterId"],
        transpoterName: json["transpoter_name"],
        transpoterPhoneNumber: json["transpoter_phoneNumber"],
        transpoterEmail: json["transpoter_email"],
        customerName: json["customerName"],
        customerPhoneNo: json["customerPhoneNo"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "invoiceNo": invoiceNo,
        "vehicle_id": vehicleId,
        "driver_Id": driverId,
        "deliveryLocation": deliveryLocation,
        "loadingSequency": loadingSequency,
        "createdBy": createdBy,
        "createdAt": createdAt,
        "deliveredAt": deliveredAt,
        "loadedAt": loadedAt,
        "status": status,
        "driver_fullName": driverFullName,
        "driver_phoneNumber": driverPhoneNumber,
        "driver_email": driverEmail,
        "plateNumber": plateNumber,
        "maxCbm": maxCbm,
        "transporterId": transporterId,
        "transpoter_name": transpoterName,
        "transpoter_phoneNumber": transpoterPhoneNumber,
        "transpoter_email": transpoterEmail,
        "customerName": customerName,
        "customerPhoneNo": customerPhoneNo,
    };
}
