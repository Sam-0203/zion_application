import 'dart:convert';

LanguagedBibleList languagedBibleListFromJson(String str) =>
    LanguagedBibleList.fromJson(json.decode(str));

String languagedBibleListToJson(LanguagedBibleList data) =>
    json.encode(data.toJson());

class LanguagedBibleList {
  int status;
  int code;
  String message;
  Data data;

  LanguagedBibleList({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory LanguagedBibleList.fromJson(Map<String, dynamic> json) =>
      LanguagedBibleList(
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
  List<BibleList> bibleList;

  Data({required this.id, required this.category, required this.bibleList});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    category: json["category"],
    bibleList: List<BibleList>.from(
      json["bibleList"].map((x) => BibleList.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category": category,
    "bibleList": List<dynamic>.from(bibleList.map((x) => x.toJson())),
  };
}

class BibleList {
  int id;
  BibleLanguage bibleLanguage;
  String testament;
  int booknumber;
  String bookName;
  int chapters;
  DateTime createdAt;
  DateTime updatedAt;

  BibleList({
    required this.id,
    required this.bibleLanguage,
    required this.testament,
    required this.booknumber,
    required this.bookName,
    required this.chapters,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BibleList.fromJson(Map<String, dynamic> json) => BibleList(
    id: json["id"],
    bibleLanguage: BibleLanguage.fromJson(json["bibleLanguage"]),
    testament: json["testament"],
    booknumber: json["booknumber"],
    bookName: json["bookName"],
    chapters: json["chapters"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "bibleLanguage": bibleLanguage.toJson(),
    "testament": testament,
    "booknumber": booknumber,
    "bookName": bookName,
    "chapters": chapters,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class BibleLanguage {
  int id;
  String languageCode;
  String languages;
  bool isActive;

  BibleLanguage({
    required this.id,
    required this.languageCode,
    required this.languages,
    required this.isActive,
  });

  factory BibleLanguage.fromJson(Map<String, dynamic> json) => BibleLanguage(
    id: json["id"],
    languageCode: json["languageCode"],
    languages: json["languages"],
    isActive: json["is_active"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "languageCode": languageCode,
    "languages": languages,
    "is_active": isActive,
  };
}
