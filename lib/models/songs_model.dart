// To parse this JSON data, do
//
// final languageList = languageListFromJson(jsonString);

import 'dart:convert';

LanguageList languageListFromJson(String str) => LanguageList.fromJson(json.decode(str));

String languageListToJson(LanguageList data) => json.encode(data.toJson());

class LanguageList {
    int status;
    int code;
    String message;
    List<Datum> data;

    LanguageList({
        required this.status,
        required this.code,
        required this.message,
        required this.data,
    });

    factory LanguageList.fromJson(Map<String, dynamic> json) => LanguageList(
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
