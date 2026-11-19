// To parse this JSON data, do
//
//     final prayerRequestsreponses = prayerRequestsreponsesFromJson(jsonString);

import 'dart:convert';

PrayerRequestsreponses prayerRequestsreponsesFromJson(String str) =>
    PrayerRequestsreponses.fromJson(json.decode(str));

String prayerRequestsreponsesToJson(PrayerRequestsreponses data) =>
    json.encode(data.toJson());

class PrayerRequestsreponses {
  int status;
  int code;
  String message;
  Data data;

  PrayerRequestsreponses({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory PrayerRequestsreponses.fromJson(Map<String, dynamic> json) =>
      PrayerRequestsreponses(
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
  int noOfRequesters;
  List<AllPrayer> allPrayers;

  Data({required this.noOfRequesters, required this.allPrayers});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    noOfRequesters: json["no_of_requesters"],
    allPrayers: List<AllPrayer>.from(
      json["all_prayers"].map((x) => AllPrayer.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "no_of_requesters": noOfRequesters,
    "all_prayers": List<dynamic>.from(allPrayers.map((x) => x.toJson())),
  };
}

class AllPrayer {
  int id;
  int? requester;
  String name;
  String prayer;
  bool isMe;
  int viewCount;
  DateTime createdAt;
  DateTime updatedAt;

  AllPrayer({
    required this.id,
    required this.requester,
    required this.name,
    required this.prayer,
    required this.isMe,
    required this.viewCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AllPrayer.fromJson(Map<String, dynamic> json) => AllPrayer(
    id: json["id"],
    requester: (json["requester"] as num?)?.toInt(),
    name: json["name"]!,
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
