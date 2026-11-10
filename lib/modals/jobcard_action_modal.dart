// To parse this JSON data, do
//
//     final jobCardActionModal = jobCardActionModalFromJson(jsonString);

import 'dart:convert';

JobCardActionModal jobCardActionModalFromJson(String str) => JobCardActionModal.fromJson(json.decode(str));

String jobCardActionModalToJson(JobCardActionModal data) => json.encode(data.toJson());

class JobCardActionModal {
    int id;
    String name;
    DateTime createdAt;

    JobCardActionModal({
        required this.id,
        required this.name,
        required this.createdAt,
    });

    factory JobCardActionModal.fromJson(Map<String, dynamic> json) => JobCardActionModal(
        id: json["id"],
        name: json["name"],
        createdAt: DateTime.parse(json["createdAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "createdAt": createdAt.toIso8601String(),
    };

    @override
    String toString() {
        return name;
    }
}
