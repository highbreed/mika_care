// To parse this JSON data, do
//
//     final deliveryProductsModal = deliveryProductsModalFromJson(jsonString);

import 'dart:convert';

DeliveryProductsModal deliveryProductsModalFromJson(String str) =>
    DeliveryProductsModal.fromJson(json.decode(str));

String deliveryProductsModalToJson(DeliveryProductsModal data) =>
    json.encode(data.toJson());

class DeliveryProductsModal {
  int id;
  int routeId;
  int driverId;
  String invoiceNo;
  String deliveryLocation;
  String customerName;
  String customerPhoneNo;
  int loadingSequency;
  int vehicleId;
  String driverFullName;
  String driverPhoneNumber;
  String driverEmail;
  String plateNumber;
  int maxCbm;
  int transporterId;
  String transpoterName;
  String transpoterPhoneNumber;
  String transporterEmail;
  String? itemImage;
  String? itemGroup;
  String modelNo;
  String itemCode;
  int deliveryQuantity;
  dynamic loadedQty;
  String comment;
  bool isSkipped;
  List<dynamic> serialNumbers;

  DeliveryProductsModal({
    required this.id,
    required this.routeId,
    required this.driverId,
    required this.invoiceNo,
    required this.deliveryLocation,
    required this.customerName,
    required this.customerPhoneNo,
    required this.loadingSequency,
    required this.vehicleId,
    required this.driverFullName,
    required this.driverPhoneNumber,
    required this.driverEmail,
    required this.plateNumber,
    required this.maxCbm,
    required this.transporterId,
    required this.transpoterName,
    required this.transpoterPhoneNumber,
    required this.transporterEmail,
    required this.itemImage,
    required this.itemGroup,
    required this.modelNo,
    required this.itemCode,
    required this.deliveryQuantity,
    required this.loadedQty,
    required this.comment,
    required this.isSkipped,
    required this.serialNumbers,
  });

  factory DeliveryProductsModal.fromJson(Map<String, dynamic> json) =>
      DeliveryProductsModal(
        id: json["id"],
        routeId: json["routeId"],
        driverId: json["driverId"],
        invoiceNo: json["invoiceNo"],
        deliveryLocation: json["deliveryLocation"],
        customerName: json["customerName"],
        customerPhoneNo: json["customerPhoneNo"],
        loadingSequency: json["loadingSequency"],
        vehicleId: json["vehicleId"],
        driverFullName: json["driver_fullName"],
        driverPhoneNumber: json["driver_phoneNumber"],
        driverEmail: json["driver_email"],
        plateNumber: json["plateNumber"],
        maxCbm: json["maxCbm"],
        transporterId: json["transporterId"],
        transpoterName: json["transpoter_name"],
        transpoterPhoneNumber: json["transpoter_phoneNumber"],
        transporterEmail: json["transporter_email"],
        itemImage: json["itemImage"],
        itemGroup: json["itemGroup"],
        modelNo: json["modelNo"],
        itemCode: json["itemCode"],
        deliveryQuantity: json["deliveryQuantity"],
        loadedQty: json["loadedQty"],
        comment: json["comment"],
        isSkipped: json["isSkipped"],
        serialNumbers: List<dynamic>.from(json["serialNumbers"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "routeId": routeId,
    "driverId": driverId,
    "invoiceNo": invoiceNo,
    "deliveryLocation": deliveryLocation,
    "customerName": customerName,
    "customerPhoneNo": customerPhoneNo,
    "loadingSequency": loadingSequency,
    "vehicleId": vehicleId,
    "driver_fullName": driverFullName,
    "driver_phoneNumber": driverPhoneNumber,
    "driver_email": driverEmail,
    "plateNumber": plateNumber,
    "maxCbm": maxCbm,
    "transporterId": transporterId,
    "transpoter_name": transpoterName,
    "transpoter_phoneNumber": transpoterPhoneNumber,
    "transporter_email": transporterEmail,
    "itemImage": itemImage,
    "itemGroup": itemGroup,
    "modelNo": modelNo,
    "itemCode": itemCode,
    "deliveryQuantity": deliveryQuantity,
    "loadedQty": loadedQty,
    "comment": comment,
    "isSkipped": isSkipped,
    "serialNumbers": List<dynamic>.from(serialNumbers.map((x) => x)),
  };
}
