// To parse this JSON data, do
//
//     final godVerseoftheday = godVerseofthedayFromJson(jsonString);

import 'dart:convert';

GodVerseoftheday godVerseofthedayFromJson(String str) =>
    GodVerseoftheday.fromJson(json.decode(str));

String godVerseofthedayToJson(GodVerseoftheday data) =>
    json.encode(data.toJson());

class GodVerseoftheday {
  int status;
  int code;
  String message;
  Data data;

  GodVerseoftheday({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory GodVerseoftheday.fromJson(Map<String, dynamic> json) =>
      GodVerseoftheday(
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
  String reference;
  DateTime date;
  Language language;
  Verses verses;

  Data({
    required this.reference,
    required this.date,
    required this.language,
    required this.verses,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    reference: json["reference"],
    date: DateTime.parse(json["date"]),
    language: Language.fromJson(json["language"]),
    verses: Verses.fromJson(json["verses"]),
  );

  Map<String, dynamic> toJson() => {
    "reference": reference,
    "date":
        "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "language": language.toJson(),
    "verses": verses.toJson(),
  };
}

class Language {
  String code;
  String name;

  Language({required this.code, required this.name});

  factory Language.fromJson(Map<String, dynamic> json) =>
      Language(code: json["code"], name: json["name"]);

  Map<String, dynamic> toJson() => {"code": code, "name": name};
}

class Verses {
  String selectedVerses;
  String? engVerses;

  Verses({required this.selectedVerses, this.engVerses});

  factory Verses.fromJson(Map<String, dynamic> json) => Verses(
    selectedVerses: json["selected_verses"],
    engVerses: json["eng_verses"],
  );

  Map<String, dynamic> toJson() => {
    "selected_verses": selectedVerses,
    "eng_verses": engVerses,
  };
}
