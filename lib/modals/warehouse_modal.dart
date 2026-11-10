// To parse this JSON data, do
//
//     final warehouseModal = warehouseModalFromJson(jsonString);

import 'dart:convert';

WarehouseModal warehouseModalFromJson(String str) => WarehouseModal.fromJson(json.decode(str));

String warehouseModalToJson(WarehouseModal data) => json.encode(data.toJson());

class WarehouseModal {
    int id;
    String name;
    String code;
    String status;
    DateTime createdAt;

    WarehouseModal({
        required this.id,
        required this.name,
        required this.code,
        required this.status,
        required this.createdAt,
    });

    factory WarehouseModal.fromJson(Map<String, dynamic> json) => WarehouseModal(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        status: json["status"],
        createdAt: DateTime.parse(json["createdAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "status": status,
        "createdAt": createdAt.toIso8601String(),
    };
}
