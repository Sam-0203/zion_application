// To parse this JSON data, do
//
//     final languages = languagesFromJson(jsonString);

import 'dart:convert';

AppLanguages languagesFromJson(String str) =>
    AppLanguages.fromJson(json.decode(str));

String languagesToJson(AppLanguages data) => json.encode(data.toJson());

class AppLanguages {
  int status;
  int code;
  String message;
  List<Datum> data;

  AppLanguages({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory AppLanguages.fromJson(Map<String, dynamic> json) => AppLanguages(
    status: json["status"],
    code: json["code"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int id;
  String languageCode;
  String languages;
  bool isActive;
  DateTime createdAt;
  DateTime updatedAt;

  Datum({
    required this.id,
    required this.languageCode,
    required this.languages,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    languageCode: json["languageCode"],
    languages: json["languages"],
    isActive: json["is_active"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "languageCode": languageCode,
    "languages": languages,
    "is_active": isActive,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
