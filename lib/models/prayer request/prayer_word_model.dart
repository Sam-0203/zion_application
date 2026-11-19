import 'dart:convert';

PrayerRequestsAndGodVerseoftheday prayerRequestsAndGodVerseofthedayFromJson(
  String str,
) => PrayerRequestsAndGodVerseoftheday.fromJson(json.decode(str));

String prayerRequestsAndGodVerseofthedayToJson(
  PrayerRequestsAndGodVerseoftheday data,
) => json.encode(data.toJson());

class PrayerRequestsAndGodVerseoftheday {
  int status;
  int code;
  String message;
  Data data;

  PrayerRequestsAndGodVerseoftheday({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory PrayerRequestsAndGodVerseoftheday.fromJson(
    Map<String, dynamic> json,
  ) {
    return PrayerRequestsAndGodVerseoftheday(
      status: json['status'] ?? 0,
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: Data.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'code': code,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class Data {
  WordOfGod wordOfGod;
  PrayerRequests prayerRequests;

  Data({required this.wordOfGod, required this.prayerRequests});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      wordOfGod: WordOfGod.fromJson(json['word_of_god'] ?? {}),
      prayerRequests: PrayerRequests.fromJson(json['prayer_requests'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word_of_god': wordOfGod.toJson(),
      'prayer_requests': prayerRequests.toJson(),
    };
  }
}

class WordOfGod {
  String reference;
  DateTime date;
  Language language;
  Verses verses;

  WordOfGod({
    required this.reference,
    required this.date,
    required this.language,
    required this.verses,
  });

  factory WordOfGod.fromJson(Map<String, dynamic> json) {
    return WordOfGod(
      reference: json['reference'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      language: Language.fromJson(json['language'] ?? {}),
      verses: Verses.fromJson(json['verses'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reference': reference,
      'date':
          '${date.year.toString().padLeft(4, '0')}-'
          '${date.month.toString().padLeft(2, '0')}-'
          '${date.day.toString().padLeft(2, '0')}',
      'language': language.toJson(),
      'verses': verses.toJson(),
    };
  }
}

class Language {
  String code;
  String name;

  Language({required this.code, required this.name});

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(code: json['code'] ?? '', name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'code': code, 'name': name};
  }
}

class Verses {
  String selectedVerses;
  String? engVerses;

  Verses({required this.selectedVerses, this.engVerses});

  factory Verses.fromJson(Map<String, dynamic> json) {
    return Verses(
      selectedVerses: json['selected_verses'] ?? '',
      engVerses: json['eng_verses'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'selected_verses': selectedVerses, 'eng_verses': engVerses};
  }
}

class PrayerRequests {
  int noOfRequesters;
  List<AllPrayer> allPrayers;

  PrayerRequests({required this.noOfRequesters, required this.allPrayers});

  factory PrayerRequests.fromJson(Map<String, dynamic> json) {
    return PrayerRequests(
      noOfRequesters: json['no_of_requesters'] ?? 0,
      allPrayers: json['all_prayers'] == null
          ? []
          : List<AllPrayer>.from(
              (json['all_prayers'] as List).map(
                (x) => AllPrayer.fromJson(x as Map<String, dynamic>),
              ),
            ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'no_of_requesters': noOfRequesters,
      'all_prayers': List<dynamic>.from(allPrayers.map((x) => x.toJson())),
    };
  }
}

class AllPrayer {
  int id;
  int requester;
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

  factory AllPrayer.fromJson(Map<String, dynamic> json) {
    return AllPrayer(
      id: json['id'] ?? 0,
      requester: json['requester'] ?? 0,
      name: json['name'] ?? '',
      prayer: json['prayer'] ?? '',
      isMe: json['is_me'] ?? false,
      viewCount: json['view_count'] ?? 0,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'requester': requester,
      'name': name,
      'prayer': prayer,
      'is_me': isMe,
      'view_count': viewCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
