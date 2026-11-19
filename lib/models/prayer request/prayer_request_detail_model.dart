// To parse this JSON data, do
//
//     final prayerRequestsDetailsReponses = prayerRequestsDetailsReponsesFromJson(jsonString);

import 'dart:convert';

PrayerRequestsDetailsReponses prayerRequestsDetailsReponsesFromJson(
  String str,
) => PrayerRequestsDetailsReponses.fromJson(json.decode(str));

String prayerRequestsDetailsReponsesToJson(
  PrayerRequestsDetailsReponses data,
) => json.encode(data.toJson());

class PrayerRequestsDetailsReponses {
  int status;
  int code;
  String message;
  Data data;

  PrayerRequestsDetailsReponses({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory PrayerRequestsDetailsReponses.fromJson(Map<String, dynamic> json) =>
      PrayerRequestsDetailsReponses(
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
  int requester;
  String name;
  String prayer;
  bool isMe;
  int viewCount;
  DateTime createdAt;
  DateTime updatedAt;

  Data({
    required this.id,
    required this.requester,
    required this.name,
    required this.prayer,
    required this.isMe,
    required this.viewCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    requester: json["requester"],
    name: json["name"],
    prayer: json["prayer"],
    isMe: json["is_me"],
    viewCount: json["view_count"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "requester": requester,
    "name": name,
    "prayer": prayer,
    "is_me": isMe,
    "view_count": viewCount,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
