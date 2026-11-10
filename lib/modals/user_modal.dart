import 'dart:convert';

import 'role_modal.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
    int userId;
    String phoneNumber;
    String token;
    String username;
    String email;
    String fullName;
    String firstName;
    String lastName;
    String userStatus;
    List<Role> role;

    User({
        required this.userId,
        required this.phoneNumber,
        required this.token,
        required this.username,
        required this.email,
        required this.fullName,
        required this.firstName,
        required this.lastName,
        required this.userStatus,
        required this.role,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["user_id"],
        phoneNumber: json["phoneNumber"],
        token: json["token"],
        username: json["username"],
        email: json["email"],
        fullName: json["fullName"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        userStatus: json["user_status"],
        role: List<Role>.from(json["role"].map((x) => Role.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "phoneNumber": phoneNumber,
        "token": token,
        "username": username,
        "email": email,
        "fullName": fullName,
        "firstName": firstName,
        "lastName": lastName,
        "user_status": userStatus,
        "role": List<dynamic>.from(role.map((x) => x.toJson())),
    };
}