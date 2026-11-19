// To parse this JSON data, do
//
//     final singleUserIsActiveResponseModel = singleUserIsActiveResponseModelFromJson(jsonString);

import 'dart:convert';

SingleUserIsActiveResponseModel singleUserIsActiveResponseModelFromJson(
  String str,
) => SingleUserIsActiveResponseModel.fromJson(json.decode(str));

String singleUserIsActiveResponseModelToJson(
  SingleUserIsActiveResponseModel data,
) => json.encode(data.toJson());

class SingleUserIsActiveResponseModel {
  int status;
  int code;
  String message;
  Data data;

  SingleUserIsActiveResponseModel({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory SingleUserIsActiveResponseModel.fromJson(Map<String, dynamic> json) =>
      SingleUserIsActiveResponseModel(
        status: json["status"],
        code: json["code"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  int id;
  String name;
  dynamic mobileNumber;
  bool isActive;
  DateTime createdAt;
  DateTime updatedAt;

  Data({
    required this.id,
    required this.name,
    required this.mobileNumber,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    mobileNumber: json["mobileNumber"],
    isActive: json["is_active"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "mobileNumber": mobileNumber,
    "is_active": isActive,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
