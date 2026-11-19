import 'dart:convert';

BibleVersesResponse bibleVersesResponseFromJson(String str) =>
    BibleVersesResponse.fromJson(json.decode(str));

String bibleVersesResponseToJson(BibleVersesResponse data) =>
    json.encode(data.toJson());

class BibleVersesResponse {
  int status;
  int code;
  String message;
  List<BibleVerseData> data;

  BibleVersesResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory BibleVersesResponse.fromJson(Map<String, dynamic> json) {
    return BibleVersesResponse(
      status: json['status'],
      code: json['code'],
      message: json['message'],
      data: List<BibleVerseData>.from(
        json['data'].map((x) => BibleVerseData.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'code': code,
    'message': message,
    'data': List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class BibleVerseData {
  int id;
  BibleBook book;
  String bookName;
  int noOfChapter;
  int noOfVerses;
  VerseText verses;
  DateTime createdAt;
  DateTime updatedAt;

  BibleVerseData({
    required this.id,
    required this.book,
    required this.bookName,
    required this.noOfChapter,
    required this.noOfVerses,
    required this.verses,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BibleVerseData.fromJson(Map<String, dynamic> json) {
    return BibleVerseData(
      id: json['id'],
      book: BibleBook.fromJson(json['book']),
      bookName: json['book_name'],
      noOfChapter: json['no_of_chapter'],
      noOfVerses: json['no_of_verses'],
      verses: VerseText.fromJson(json['verses']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'book': book.toJson(),
    'book_name': bookName,
    'no_of_chapter': noOfChapter,
    'no_of_verses': noOfVerses,
    'verses': verses.toJson(),
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}

class BibleBook {
  int id;
  BibleLanguage bibleLanguage;
  String testament;
  int booknumber;
  String bookName;
  int chapters;
  DateTime createdAt;
  DateTime updatedAt;

  BibleBook({
    required this.id,
    required this.bibleLanguage,
    required this.testament,
    required this.booknumber,
    required this.bookName,
    required this.chapters,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BibleBook.fromJson(Map<String, dynamic> json) {
    return BibleBook(
      id: json['id'],
      bibleLanguage: BibleLanguage.fromJson(json['bibleLanguage']),
      testament: json['testament'],
      booknumber: json['booknumber'],
      bookName: json['bookName'],
      chapters: json['chapters'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'bibleLanguage': bibleLanguage.toJson(),
    'testament': testament,
    'booknumber': booknumber,
    'bookName': bookName,
    'chapters': chapters,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
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

  factory BibleLanguage.fromJson(Map<String, dynamic> json) {
    return BibleLanguage(
      id: json['id'],
      languageCode: json['languageCode'],
      languages: json['languages'],
      isActive: json['is_active'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'languageCode': languageCode,
    'languages': languages,
    'is_active': isActive,
  };
}

class VerseText {
  String selectedVerses;
  String? engVerses;
  String? selectedVersesAudio;
  String selectedVersesAudioDuration;

  VerseText({
    required this.selectedVerses,
    required this.selectedVersesAudioDuration,
    this.engVerses,
    this.selectedVersesAudio,
  });

  factory VerseText.fromJson(Map<String, dynamic> json) {
    return VerseText(
      selectedVerses: json['selected_verses']?.toString() ?? '',
      engVerses: json['eng_verses']?.toString(),
      selectedVersesAudio: json['selected_verses_audio']?.toString(),
      selectedVersesAudioDuration:
          json['selected_verses_audio_duration']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'selected_verses': selectedVerses,
    'eng_verses': engVerses,
    'selected_verses_audio': selectedVersesAudio,
    'selected_verses_audio_duration': selectedVersesAudioDuration,
  };
}
