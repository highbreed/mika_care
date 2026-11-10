// To parse this JSON data, do
//
//     final deliveryDetails = deliveryDetailsFromJson(jsonString);

import 'dart:convert';

DeliveryDetails deliveryDetailsFromJson(String str) => DeliveryDetails.fromJson(json.decode(str));

String deliveryDetailsToJson(DeliveryDetails data) => json.encode(data.toJson());

class DeliveryDetails {
    String customerName;
    String deliveryLocation;
    String customerPhoneNumber;
    String invoiceNumber;
    int loadingSequency;
    String status;
    dynamic loadedAt;
    int driverId;
    int vehicleId;
    dynamic deliveredAt;
    String createdAt;
    int createdBy;
    String driverFullName;
    String driverPhoneNumber;
    String driverEmail;
    String plateNumber;
    int maxCbm;
    String vehicleStatus;
    String transpoterName;
    String tranpoterPhoneNumber;
    String transpoterEmail;
    String transpoterStatus;
    List<DeliveryItem> deliveryItems;

    DeliveryDetails({
        required this.customerName,
        required this.deliveryLocation,
        required this.customerPhoneNumber,
        required this.invoiceNumber,
        required this.loadingSequency,
        required this.status,
        required this.loadedAt,
        required this.driverId,
        required this.vehicleId,
        required this.deliveredAt,
        required this.createdAt,
        required this.createdBy,
        required this.driverFullName,
        required this.driverPhoneNumber,
        required this.driverEmail,
        required this.plateNumber,
        required this.maxCbm,
        required this.vehicleStatus,
        required this.transpoterName,
        required this.tranpoterPhoneNumber,
        required this.transpoterEmail,
        required this.transpoterStatus,
        required this.deliveryItems,
    });

    factory DeliveryDetails.fromJson(Map<String, dynamic> json) => DeliveryDetails(
        customerName: json["customerName"],
        deliveryLocation: json["deliveryLocation"],
        customerPhoneNumber: json["customerPhoneNumber"],
        invoiceNumber: json["invoiceNumber"],
        loadingSequency: json["loadingSequency"],
        status: json["status"],
        loadedAt: json["loadedAt"],
        driverId: json["driverId"],
        vehicleId: json["vehicleId"],
        deliveredAt: json["deliveredAt"],
        createdAt: json["createdAt"],
        createdBy: json["createdBy"],
        driverFullName: json["driverFullName"],
        driverPhoneNumber: json["driverPhoneNumber"],
        driverEmail: json["driverEmail"],
        plateNumber: json["plateNumber"],
        maxCbm: json["maxCbm"],
        vehicleStatus: json["vehicleStatus"],
        transpoterName: json["transpoterName"],
        tranpoterPhoneNumber: json["tranpoterPhoneNumber"],
        transpoterEmail: json["transpoterEmail"],
        transpoterStatus: json["transpoterStatus"],
        deliveryItems: List<DeliveryItem>.from(json["delivery_items"].map((x) => DeliveryItem.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "customerName": customerName,
        "deliveryLocation": deliveryLocation,
        "customerPhoneNumber": customerPhoneNumber,
        "invoiceNumber": invoiceNumber,
        "loadingSequency": loadingSequency,
        "status": status,
        "loadedAt": loadedAt,
        "driverId": driverId,
        "vehicleId": vehicleId,
        "deliveredAt": deliveredAt,
        "createdAt": createdAt,
        "createdBy": createdBy,
        "driverFullName": driverFullName,
        "driverPhoneNumber": driverPhoneNumber,
        "driverEmail": driverEmail,
        "plateNumber": plateNumber,
        "maxCbm": maxCbm,
        "vehicleStatus": vehicleStatus,
        "transpoterName": transpoterName,
        "tranpoterPhoneNumber": tranpoterPhoneNumber,
        "transpoterEmail": transpoterEmail,
        "transpoterStatus": transpoterStatus,
        "delivery_items": List<dynamic>.from(deliveryItems.map((x) => x.toJson())),
    };
}

class DeliveryItem {
    String itemCode;
    String modelNo;
    int deliveryQuantity;
    String productStatus;
    dynamic loadedQty;
    dynamic serialStatus;
    List<dynamic> serialNumber;
    String itemGroup;
    String warehouseCode;
    String itemImage;
    String comment;
    bool isSkipped;

    DeliveryItem({
        required this.itemCode,
        required this.modelNo,
        required this.deliveryQuantity,
        required this.productStatus,
        required this.loadedQty,
        required this.serialStatus,
        required this.serialNumber,
        required this.itemGroup,
        required this.warehouseCode,
        required this.itemImage,
        required this.comment,
        required this.isSkipped,
    });

    factory DeliveryItem.fromJson(Map<String, dynamic> json) => DeliveryItem(
        itemCode: json["itemCode"],
        modelNo: json["modelNo"],
        deliveryQuantity: json["deliveryQuantity"],
        productStatus: json["productStatus"],
        loadedQty: json["loadedQty"],
        serialStatus: json["serialStatus"],
        serialNumber: List<dynamic>.from(json["serialNumber"].map((x) => x)),
        itemGroup: json["itemGroup"],
        warehouseCode: json["warehouseCode"],
        itemImage: json["itemImage"],
        comment: json["comment"],
        isSkipped: json["isSkipped"],
    );

    Map<String, dynamic> toJson() => {
        "itemCode": itemCode,
        "modelNo": modelNo,
        "deliveryQuantity": deliveryQuantity,
        "productStatus": productStatus,
        "loadedQty": loadedQty,
        "serialStatus": serialStatus,
        "serialNumber": List<dynamic>.from(serialNumber.map((x) => x)),
        "itemGroup": itemGroup,
        "warehouseCode": warehouseCode,
        "itemImage": itemImage,
        "comment": comment,
        "isSkipped": isSkipped,
    };
}
