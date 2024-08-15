// To parse this JSON data, do
//
//     final profileGetResponse = profileGetResponseFromJson(jsonString);

import 'dart:convert';

ProfileGetResponse profileGetResponseFromJson(String str) =>
    ProfileGetResponse.fromJson(json.decode(str));

String profileGetResponseToJson(ProfileGetResponse data) =>
    json.encode(data.toJson());

class ProfileGetResponse {
  int idx;
  String fullname;
  String phone;
  String email;
  String image;

  ProfileGetResponse({
    required this.idx,
    required this.fullname,
    required this.phone,
    required this.email,
    required this.image,
  });

  factory ProfileGetResponse.fromJson(Map<String, dynamic> json) =>
      ProfileGetResponse(
        idx: json["idx"],
        fullname: json["fullname"],
        phone: json["phone"],
        email: json["email"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "idx": idx,
        "fullname": fullname,
        "phone": phone,
        "email": email,
        "image": image,
      };
}
