// To parse this JSON data, do
//
//     final routeDetailsModal = routeDetailsModalFromJson(jsonString);

import 'dart:convert';

RouteDetailsModal routeDetailsModalFromJson(String str) => RouteDetailsModal.fromJson(json.decode(str));

String routeDetailsModalToJson(RouteDetailsModal data) => json.encode(data.toJson());

class RouteDetailsModal {
    int id;
    String routeName;
    int transpoterId;
    int regionId;
    int vehicleId;
    int driverId;
    String status;
    int totalDeliveries;
    int totalDelivered;
    DateTime routeDate;
    String createdAt;
    int createdBy;
    String driverFullName;
    String driverPhoneNumber;
    String driverEmail;
    String plateNumber;
    int maxCbm;
    String transpoterName;
    String tranpoterPhoneNumber;
    String transpoterEmail;
    List<DeliveryOrder> deliveryOrders;

    RouteDetailsModal({
        required this.id,
        required this.routeName,
        required this.transpoterId,
        required this.regionId,
        required this.vehicleId,
        required this.driverId,
        required this.status,
        required this.totalDeliveries,
        required this.totalDelivered,
        required this.routeDate,
        required this.createdAt,
        required this.createdBy,
        required this.driverFullName,
        required this.driverPhoneNumber,
        required this.driverEmail,
        required this.plateNumber,
        required this.maxCbm,
        required this.transpoterName,
        required this.tranpoterPhoneNumber,
        required this.transpoterEmail,
        required this.deliveryOrders,
    });

    factory RouteDetailsModal.fromJson(Map<String, dynamic> json) => RouteDetailsModal(
        id: json["id"],
        routeName: json["routeName"],
        transpoterId: json["transpoterId"],
        regionId: json["regionId"],
        vehicleId: json["vehicleId"],
        driverId: json["driverId"],
        status: json["status"],
        totalDeliveries: json["totalDeliveries"],
        totalDelivered: json["totalDelivered"],
        routeDate: DateTime.parse(json["routeDate"]),
        createdAt: json["createdAt"],
        createdBy: json["createdBy"],
        driverFullName: json["driverFullName"],
        driverPhoneNumber: json["driverPhoneNumber"],
        driverEmail: json["driverEmail"],
        plateNumber: json["plateNumber"],
        maxCbm: json["maxCbm"],
        transpoterName: json["transpoterName"],
        tranpoterPhoneNumber: json["tranpoterPhoneNumber"],
        transpoterEmail: json["transpoterEmail"],
        deliveryOrders: List<DeliveryOrder>.from(json["delivery_orders"].map((x) => DeliveryOrder.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "routeName": routeName,
        "transpoterId": transpoterId,
        "regionId": regionId,
        "vehicleId": vehicleId,
        "driverId": driverId,
        "status": status,
        "totalDeliveries": totalDeliveries,
        "totalDelivered": totalDelivered,
        "routeDate": "${routeDate.year.toString().padLeft(4, '0')}-${routeDate.month.toString().padLeft(2, '0')}-${routeDate.day.toString().padLeft(2, '0')}",
        "createdAt": createdAt,
        "createdBy": createdBy,
        "driverFullName": driverFullName,
        "driverPhoneNumber": driverPhoneNumber,
        "driverEmail": driverEmail,
        "plateNumber": plateNumber,
        "maxCbm": maxCbm,
        "transpoterName": transpoterName,
        "tranpoterPhoneNumber": tranpoterPhoneNumber,
        "transpoterEmail": transpoterEmail,
        "delivery_orders": List<dynamic>.from(deliveryOrders.map((x) => x.toJson())),
    };
}

class DeliveryOrder {
    String invoiceNumber;
    String deliveryLocation;
    String customerName;
    String customerPhoneNo;
    int loadingSequency;
    String invoiceStatus;
    dynamic loadedAt;
    dynamic deliveredAt;

    DeliveryOrder({
        required this.invoiceNumber,
        required this.deliveryLocation,
        required this.customerName,
        required this.customerPhoneNo,
        required this.loadingSequency,
        required this.invoiceStatus,
        required this.loadedAt,
        required this.deliveredAt,
    });

    factory DeliveryOrder.fromJson(Map<String, dynamic> json) => DeliveryOrder(
        invoiceNumber: json["invoiceNumber"],
        deliveryLocation: json["deliveryLocation"],
        customerName: json["customerName"],
        customerPhoneNo: json["customerPhoneNo"],
        loadingSequency: json["loadingSequency"],
        invoiceStatus: json["invoiceStatus"],
        loadedAt: json["loadedAt"],
        deliveredAt: json["deliveredAt"],
    );

    Map<String, dynamic> toJson() => {
        "invoiceNumber": invoiceNumber,
        "deliveryLocation": deliveryLocation,
        "customerName": customerName,
        "customerPhoneNo": customerPhoneNo,
        "loadingSequency": loadingSequency,
        "invoiceStatus": invoiceStatus,
        "loadedAt": loadedAt,
        "deliveredAt": deliveredAt,
    };
}
