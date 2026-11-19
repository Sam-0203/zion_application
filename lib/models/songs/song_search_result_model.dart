// To parse this JSON data, do
//
//     final searchResultResponseModel = searchResultResponseModelFromJson(jsonString);

import 'dart:convert';

SearchResultResponseModel searchResultResponseModelFromJson(String str) =>
    SearchResultResponseModel.fromJson(json.decode(str));

String searchResultResponseModelToJson(SearchResultResponseModel data) =>
    json.encode(data.toJson());

class SearchResultResponseModel {
  int status;
  int code;
  String message;
  int count;
  List<Datum> data;

  SearchResultResponseModel({
    required this.status,
    required this.code,
    required this.message,
    required this.count,
    required this.data,
  });

  factory SearchResultResponseModel.fromJson(Map<String, dynamic> json) =>
      SearchResultResponseModel(
        status: json["status"],
        code: json["code"],
        message: json["message"],
        count: json["count"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "message": message,
    "count": count,
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
