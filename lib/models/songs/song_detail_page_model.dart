import 'dart:convert';

SingleSongsDetailResponses singleSongsDetailResponsesFromJson(String str) =>
    SingleSongsDetailResponses.fromJson(json.decode(str));

String singleSongsDetailResponsesToJson(SingleSongsDetailResponses data) =>
    json.encode(data.toJson());

class SingleSongsDetailResponses {
  int status;
  int code;
  String message;
  SongData data;

  SingleSongsDetailResponses({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory SingleSongsDetailResponses.fromJson(Map<String, dynamic> json) {
    return SingleSongsDetailResponses(
      status: json["status"] ?? 0,
      code: json["code"] ?? 0,
      message: json["message"] ?? '',
      data: SongData.fromJson(json["data"] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "message": message,
    "data": data.toJson(),
  };
}

class SongData {
  int id;
  int songNo;
  String songName;
  String songChorus;
  String priseWord;
  String songLyric;
  String songAudio;
  String songDuration;
  DateTime? createdAt;
  DateTime? updatedAt;

  SongData({
    required this.id,
    required this.songNo,
    required this.songName,
    required this.songChorus,
    required this.priseWord,
    required this.songLyric,
    required this.songAudio,
    required this.songDuration,
    this.createdAt,
    this.updatedAt,
  });

  factory SongData.fromJson(Map<String, dynamic> json) {
    final audio = json["audio"] as Map<String, dynamic>?;

    return SongData(
      id: json["id"] ?? 0,
      songNo: json["song_no"] ?? 0,
      songName: json["song_name"] ?? '',
      songChorus: json["song_chorus"] ?? '',
      priseWord: json["priseWord"] ?? '',
      songLyric: json["song_lyric"] ?? '',

      // IMPORTANT: audio is nested inside "audio"
      songAudio: audio?["song_audio"] ?? '',

      // API duration: "07:27"
      songDuration: audio?["song_duration"] ?? '',

      createdAt: json["created_at"] != null
          ? DateTime.tryParse(json["created_at"])
          : null,

      updatedAt: json["updated_at"] != null
          ? DateTime.tryParse(json["updated_at"])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "song_no": songNo,
    "song_name": songName,
    "song_chorus": songChorus,
    "priseWord": priseWord,
    "song_lyric": songLyric,
    "audio": {
      "name": songName,
      "song_audio": songAudio,
      "song_duration": songDuration,
    },
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
