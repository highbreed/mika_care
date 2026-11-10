// To parse this JSON data, do
//
//     final faultModel = faultModelFromJson(jsonString);

import 'dart:convert';

FaultModel faultModelFromJson(String str) => FaultModel.fromJson(json.decode(str));

String faultModelToJson(FaultModel data) => json.encode(data.toJson());

class FaultModel {
    int id;
    String name;
    String itemGroupName;

    FaultModel({
        required this.id,
        required this.name,
        required this.itemGroupName,
    });

    factory FaultModel.fromJson(Map<String, dynamic> json) => FaultModel(
        id: json["id"],
        name: json["name"],
        itemGroupName: json["itemGroupName"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "itemGroupName": itemGroupName,
    };

    @override
    String toString() {
        return name;
    }
}
