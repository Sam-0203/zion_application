// To parse this JSON data, do
//
//     final songsListResponses = songsListResponsesFromJson(jsonString);

import 'dart:convert';

SongsListResponses songsListResponsesFromJson(String str) =>
    SongsListResponses.fromJson(json.decode(str));

String songsListResponsesToJson(SongsListResponses data) =>
    json.encode(data.toJson());

class SongsListResponses {
  int status;
  int code;
  String message;
  List<Datum> data;

  SongsListResponses({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory SongsListResponses.fromJson(Map<String, dynamic> json) =>
      SongsListResponses(
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
  int songNo;
  String songName;
  DateTime createdAt;
  DateTime updatedAt;

  Datum({
    required this.id,
    required this.songNo,
    required this.songName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    songNo: json["song_no"],
    songName: json["song_name"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "song_no": songNo,
    "song_name": songName,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
