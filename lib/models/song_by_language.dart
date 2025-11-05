// To parse this JSON data, do
//
//     final songByLanguage = songByLanguageFromJson(jsonString);

import 'dart:convert';

SongByLanguage songByLanguageFromJson(String str) => SongByLanguage.fromJson(json.decode(str));

String songByLanguageToJson(SongByLanguage data) => json.encode(data.toJson());

class SongByLanguage {
    int status;
    int code;
    String message;
    Data data;

    SongByLanguage({
        required this.status,
        required this.code,
        required this.message,
        required this.data,
    });

    factory SongByLanguage.fromJson(Map<String, dynamic> json) => SongByLanguage(
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
    String category;
    List<SongsList> songsList;

    Data({
        required this.id,
        required this.category,
        required this.songsList,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        category: json["category"],
        songsList: List<SongsList>.from(json["songsList"].map((x) => SongsList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "category": category,
        "songsList": List<dynamic>.from(songsList.map((x) => x.toJson())),
    };
}

class SongsList {
    int id;
    int songNo;
    String songName;
    DateTime createdAt;
    DateTime updatedAt;

    SongsList({
        required this.id,
        required this.songNo,
        required this.songName,
        required this.createdAt,
        required this.updatedAt,
    });

    factory SongsList.fromJson(Map<String, dynamic> json) => SongsList(
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
