// To parse this JSON data, do
//
//     final routeModal = routeModalFromJson(jsonString);

import 'dart:convert';

RouteModal routeModalFromJson(String str) => RouteModal.fromJson(json.decode(str));

String routeModalToJson(RouteModal data) => json.encode(data.toJson());

class RouteModal {
    int id;
    String routeName;
    int transpoterId;
    int? regionId;
    int vehicleId;
    int driverId;
    String status;
    int? totalDeliveries;
    int delivered;
    DateTime routeDate;
    int? createdBy;
    String createdAt;
    String updatedAt;
    String driverFullName;
    String driverEmail;
    String driverPhoneNumber;
    String createdByFullName;
    String createdByPhoneNumber;
    String createdByEmail;
    String transporterName;
    String transpoterPhoneNumber;
    String transporterEmail;
    String plateNumber;
    int? maxCbm;

    RouteModal({
        required this.id,
        required this.routeName,
        required this.transpoterId,
        required this.regionId,
        required this.vehicleId,
        required this.driverId,
        required this.status,
        required this.totalDeliveries,
        required this.delivered,
        required this.routeDate,
        required this.createdBy,
        required this.createdAt,
        required this.updatedAt,
        required this.driverFullName,
        required this.driverEmail,
        required this.driverPhoneNumber,
        required this.createdByFullName,
        required this.createdByPhoneNumber,
        required this.createdByEmail,
        required this.transporterName,
        required this.transpoterPhoneNumber,
        required this.transporterEmail,
        required this.plateNumber,
        required this.maxCbm,
    });

    factory RouteModal.fromJson(Map<String, dynamic> json) => RouteModal(
        id: json["id"],
        routeName: json["routeName"],
        transpoterId: json["transpoterId"],
        regionId: json["regionId"],
        vehicleId: json["vehicleId"],
        driverId: json["driver_Id"],
        status: json["status"],
        totalDeliveries: json["totalDeliveries"],
        delivered: json["delivered"],
        routeDate: DateTime.parse(json["routeDate"]),
        createdBy: json["createdBy"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        driverFullName: json["driver_fullName"],
        driverEmail: json["driver_email"],
        driverPhoneNumber: json["driver_phoneNumber"],
        createdByFullName: json["createdBy_fullName"],
        createdByPhoneNumber: json["createdBy_phoneNumber"],
        createdByEmail: json["createdBy_email"],
        transporterName: json["transporter_name"],
        transpoterPhoneNumber: json["transpoter_phoneNumber"],
        transporterEmail: json["transporter_email"],
        plateNumber: json["plateNumber"],
        maxCbm: json["maxCbm"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "routeName": routeName,
        "transpoterId": transpoterId,
        "regionId": regionId,
        "vehicleId": vehicleId,
        "driver_Id": driverId,
        "status": status,
        "totalDeliveries": totalDeliveries,
        "delivered": delivered,
        "routeDate": "${routeDate.year.toString().padLeft(4, '0')}-${routeDate.month.toString().padLeft(2, '0')}-${routeDate.day.toString().padLeft(2, '0')}",
        "createdBy": createdBy,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "driver_fullName": driverFullName,
        "driver_email": driverEmail,
        "driver_phoneNumber": driverPhoneNumber,
        "createdBy_fullName": createdByFullName,
        "createdBy_phoneNumber": createdByPhoneNumber,
        "createdBy_email": createdByEmail,
        "transporter_name": transporterName,
        "transpoter_phoneNumber": transpoterPhoneNumber,
        "transporter_email": transporterEmail,
        "plateNumber": plateNumber,
        "maxCbm": maxCbm,
    };
}
