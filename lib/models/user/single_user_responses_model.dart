// To parse this JSON data, do
//
//     final singleUserResponseModel = singleUserResponseModelFromJson(jsonString);

import 'dart:convert';

SingleUserResponseModel singleUserResponseModelFromJson(String str) =>
    SingleUserResponseModel.fromJson(json.decode(str));

String singleUserResponseModelToJson(SingleUserResponseModel data) =>
    json.encode(data.toJson());

class SingleUserResponseModel {
  int status;
  int code;
  String message;
  Data data;

  SingleUserResponseModel({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory SingleUserResponseModel.fromJson(Map<String, dynamic> json) =>
      SingleUserResponseModel(
        status: (json["status"] as num?)?.toInt() ?? 0,
        code: (json["code"] as num?)?.toInt() ?? 0,
        message: json["message"]?.toString() ?? "",
        data: Data.fromJson(
          (json["data"] as Map?)?.cast<String, dynamic>() ?? {},
        ),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  PersonalInformation personalInformation;
  AccountInformation accountInformation;
  Preferences preferences;
  StatusInformation statusInformation;
  Timestamps timestamps;

  Data({
    required this.personalInformation,
    required this.accountInformation,
    required this.preferences,
    required this.statusInformation,
    required this.timestamps,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    personalInformation: PersonalInformation.fromJson(
      (json["personal_information"] as Map?)?.cast<String, dynamic>() ?? {},
    ),
    accountInformation: AccountInformation.fromJson(
      (json["account_information"] as Map?)?.cast<String, dynamic>() ?? {},
    ),
    preferences: Preferences.fromJson(
      (json["preferences"] as Map?)?.cast<String, dynamic>() ?? {},
    ),
    statusInformation: StatusInformation.fromJson(
      (json["status_information"] as Map?)?.cast<String, dynamic>() ?? {},
    ),
    timestamps: Timestamps.fromJson(
      (json["timestamps"] as Map?)?.cast<String, dynamic>() ?? {},
    ),
  );

  Map<String, dynamic> toJson() => {
    "personal_information": personalInformation.toJson(),
    "account_information": accountInformation.toJson(),
    "preferences": preferences.toJson(),
    "status_information": statusInformation.toJson(),
    "timestamps": timestamps.toJson(),
  };
}

class AccountInformation {
  String role;
  String authType;
  String? username;
  String? gmail;
  String? facebookId;
  Profile profile;

  AccountInformation({
    required this.role,
    required this.authType,
    required this.username,
    this.gmail,
    this.facebookId,
    required this.profile,
  });

  factory AccountInformation.fromJson(Map<String, dynamic> json) =>
      AccountInformation(
        role: json["role"]?.toString() ?? "",
        authType: json["auth_type"]?.toString() ?? "",
        username: json["username"]?.toString(),
        gmail: json["gmail"]?.toString(),
        facebookId: json["facebook_id"]?.toString(),
        profile: Profile.fromJson(
          ((json["Profile"] ?? json["profile"]) as Map?)
                  ?.cast<String, dynamic>() ??
              {},
        ),
      );

  Map<String, dynamic> toJson() => {
    "role": role,
    "auth_type": authType,
    "username": username,
    "gmail": gmail,
    "facebook_id": facebookId,
    "Profile": profile.toJson(),
  };
}

class Profile {
  String image;
  String initials;

  Profile({required this.image, required this.initials});

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    image: json["image"]?.toString() ?? "",
    initials: json["initials"]?.toString() ?? "",
  );

  Map<String, dynamic> toJson() => {"image": image, "initials": initials};
}

class PersonalInformation {
  int id;
  String name;
  DateTime? dateOfBirth;
  int? age;
  String? mobileNumber;
  String? bio;

  PersonalInformation({
    required this.id,
    required this.name,
    required this.dateOfBirth,
    required this.age,
    required this.mobileNumber,
    required this.bio,
  });

  factory PersonalInformation.fromJson(Map<String, dynamic> json) =>
      PersonalInformation(
        id: (json["id"] as num?)?.toInt() ?? 0,
        name: json["name"]?.toString() ?? "",
        dateOfBirth: json["date_of_birth"] == null
            ? null
            : DateTime.tryParse(json["date_of_birth"].toString()),
        age: (json["age"] as num?)?.toInt(),
        mobileNumber: json["mobile_number"]?.toString(),
        bio: json["bio"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "date_of_birth": dateOfBirth?.toIso8601String(),
    "age": age,
    "mobile_number": mobileNumber,
    "bio": bio,
  };
}

class Preferences {
  String? category;
  int preferredLanguageForDailyWord;
  int? preferredLanguageForLanguageLocalization;

  Preferences({
    required this.category,
    required this.preferredLanguageForDailyWord,
    required this.preferredLanguageForLanguageLocalization,
  });

  factory Preferences.fromJson(Map<String, dynamic> json) => Preferences(
    category: json["category"]?.toString(),
    preferredLanguageForDailyWord:
        (json["preferred_language_for_dailyWord"] as num?)?.toInt() ?? 0,
    preferredLanguageForLanguageLocalization:
        (json["preferred_language_for_languageLocalization"] as num?)?.toInt(),
  );

  Map<String, dynamic> toJson() => {
    "category": category,
    "preferred_language_for_dailyWord": preferredLanguageForDailyWord,
    "preferred_language_for_languageLocalization":
        preferredLanguageForLanguageLocalization,
  };
}

class StatusInformation {
  bool isLogin;
  bool isOnline;
  DateTime lastSeen;
  bool isActive;
  bool isLogout;

  StatusInformation({
    required this.isLogin,
    required this.isOnline,
    required this.lastSeen,
    required this.isActive,
    required this.isLogout,
  });

  factory StatusInformation.fromJson(Map<String, dynamic> json) =>
      StatusInformation(
        isLogin: json["is_login"] as bool? ?? false,
        isOnline: json["is_online"] as bool? ?? false,
        lastSeen:
            DateTime.tryParse(json["last_seen"]?.toString() ?? "") ??
            DateTime.fromMillisecondsSinceEpoch(0),
        isActive: json["is_active"] as bool? ?? false,
        isLogout: json["is_logout"] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
    "is_login": isLogin,
    "is_online": isOnline,
    "last_seen": lastSeen.toIso8601String(),
    "is_active": isActive,
    "is_logout": isLogout,
  };
}

class Timestamps {
  DateTime createdAt;
  DateTime updatedAt;

  Timestamps({required this.createdAt, required this.updatedAt});

  factory Timestamps.fromJson(Map<String, dynamic> json) => Timestamps(
    createdAt:
        DateTime.tryParse(json["created_at"]?.toString() ?? "") ??
        DateTime.fromMillisecondsSinceEpoch(0),
    updatedAt:
        DateTime.tryParse(json["updated_at"]?.toString() ?? "") ??
        DateTime.fromMillisecondsSinceEpoch(0),
  );

  Map<String, dynamic> toJson() => {
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
