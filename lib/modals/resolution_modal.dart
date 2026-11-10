// To parse this JSON data, do
//
//     final resolutionModal = resolutionModalFromJson(jsonString);

import 'dart:convert';

ResolutionModal resolutionModalFromJson(String str) =>
    ResolutionModal.fromJson(json.decode(str));

String resolutionModalToJson(ResolutionModal data) =>
    json.encode(data.toJson());

class ResolutionModal {
  dynamic id;
  String name;
  dynamic createdAt;

  ResolutionModal({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  factory ResolutionModal.fromJson(Map<String, dynamic> json) =>
      ResolutionModal(
        id: json["id"],
        name: json["name"] ?? json["Name"] ?? "",
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "createdAt": createdAt,
  };

  @override
  String toString() => name;
}
