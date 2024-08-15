// To parse this JSON data, do
//
//     final customersRegisterPostDes = customersRegisterPostDesFromJson(jsonString);

import 'dart:convert';

CustomersRegisterPostDes customersRegisterPostDesFromJson(String str) =>
    CustomersRegisterPostDes.fromJson(json.decode(str));

String customersRegisterPostDesToJson(CustomersRegisterPostDes data) =>
    json.encode(data.toJson());

class CustomersRegisterPostDes {
  String message;
  int id;

  CustomersRegisterPostDes({
    required this.message,
    required this.id,
  });

  factory CustomersRegisterPostDes.fromJson(Map<String, dynamic> json) =>
      CustomersRegisterPostDes(
        message: json["message"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "id": id,
      };
}
