import 'dart:convert';

// ============================================================
// ADMIN LOGIN RESPONSE
// ============================================================

AdminLoginResponse adminLoginResponseFromJson(String str) =>
    AdminLoginResponse.fromJson(json.decode(str));

String adminLoginResponseToJson(AdminLoginResponse data) =>
    json.encode(data.toJson());

class AdminLoginResponse {
  final int status;
  final int code;
  final String message;
  final String token;
  final String accessToken;

  final Data data;

  AdminLoginResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.token,
    required this.accessToken,
    required this.data,
  });

  factory AdminLoginResponse.fromJson(Map<String, dynamic> json) {
    return AdminLoginResponse(
      status: json["status"] ?? 0,
      code: json["code"] ?? 0,
      message: json["message"] ?? "",

      token: json["token"] ?? "",
      accessToken: json["access_token"] ?? "",

      data: Data.fromJson(json["data"] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "code": code,
      "message": message,
      "token": token,
      "access_token": accessToken,
      "data": data.toJson(),
    };
  }
}

// DATA

class Data {
  final PersonalInformation personalInformation;
  final AccountInformation accountInformation;
  final Preferences preferences;
  final StatusInformation statusInformation;
  final Timestamps timestamps;

  Data({
    required this.personalInformation,
    required this.accountInformation,
    required this.preferences,
    required this.statusInformation,
    required this.timestamps,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      personalInformation: PersonalInformation.fromJson(
        json["personal_information"] ?? {},
      ),

      accountInformation: AccountInformation.fromJson(
        json["account_information"] ?? {},
      ),

      preferences: Preferences.fromJson(json["preferences"] ?? {}),

      statusInformation: StatusInformation.fromJson(
        json["status_information"] ?? {},
      ),

      timestamps: Timestamps.fromJson(json["timestamps"] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "personal_information": personalInformation.toJson(),

      "account_information": accountInformation.toJson(),

      "preferences": preferences.toJson(),

      "status_information": statusInformation.toJson(),

      "timestamps": timestamps.toJson(),
    };
  }
}

// ACCOUNT INFORMATION
class AccountInformation {
  final String role;
  final String authType;
  final String username;

  // API lo gmail null ravachu
  final String? gmail;

  final Profile profile;

  AccountInformation({
    required this.role,
    required this.authType,
    required this.username,
    this.gmail,
    required this.profile,
  });

  factory AccountInformation.fromJson(Map<String, dynamic> json) {
    return AccountInformation(
      role: json["role"] ?? "",
      authType: json["auth_type"] ?? "",
      username: json["username"] ?? "",

      // null allowed
      gmail: json["gmail"],

      profile: Profile.fromJson(json["Profile"] ?? json["profile"] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "role": role,
      "auth_type": authType,
      "username": username,
      "gmail": gmail,
      "Profile": profile.toJson(),
    };
  }
}

// ============================================================
// PROFILE
// ============================================================

class Profile {
  final String image;
  final String initials;

  Profile({required this.image, required this.initials});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      image: json["image"] ?? "",
      initials: json["initials"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {"image": image, "initials": initials};
  }
}

// ============================================================
// PERSONAL INFORMATION
// ============================================================

class PersonalInformation {
  final int id;
  final String name;

  // These can be null
  final DateTime? dateOfBirth;
  final int? age;
  final String? mobileNumber;

  final String bio;

  PersonalInformation({
    required this.id,
    required this.name,
    this.dateOfBirth,
    this.age,
    this.mobileNumber,
    required this.bio,
  });

  factory PersonalInformation.fromJson(Map<String, dynamic> json) {
    return PersonalInformation(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",

      // null safe DateTime
      dateOfBirth: json["date_of_birth"] != null
          ? DateTime.tryParse(json["date_of_birth"].toString())
          : null,

      // null safe int
      age: json["age"] != null ? int.tryParse(json["age"].toString()) : null,

      // null safe String
      mobileNumber: json["mobile_number"]?.toString(),

      bio: json["bio"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,

      "date_of_birth": dateOfBirth?.toIso8601String(),

      "age": age,

      "mobile_number": mobileNumber,

      "bio": bio,
    };
  }
}

// ============================================================
// PREFERENCES
// ============================================================

class Preferences {
  final String category;

  // These can be null
  final int? preferredLanguageForDailyWord;

  final int? preferredLanguageForLanguageLocalization;

  Preferences({
    required this.category,
    this.preferredLanguageForDailyWord,
    this.preferredLanguageForLanguageLocalization,
  });

  factory Preferences.fromJson(Map<String, dynamic> json) {
    return Preferences(
      category: json["category"] ?? "",

      preferredLanguageForDailyWord:
          json["preferred_language_for_dailyWord"] != null
          ? int.tryParse(json["preferred_language_for_dailyWord"].toString())
          : null,

      preferredLanguageForLanguageLocalization:
          json["preferred_language_for_languageLocalization"] != null
          ? int.tryParse(
              json["preferred_language_for_languageLocalization"].toString(),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "category": category,

      "preferred_language_for_dailyWord": preferredLanguageForDailyWord,

      "preferred_language_for_languageLocalization":
          preferredLanguageForLanguageLocalization,
    };
  }
}

// ============================================================
// STATUS INFORMATION
// ============================================================

class StatusInformation {
  final bool isLogin;
  final bool isOnline;

  final DateTime? lastSeen;

  final bool isActive;
  final bool isLogout;

  StatusInformation({
    required this.isLogin,
    required this.isOnline,
    this.lastSeen,
    required this.isActive,
    required this.isLogout,
  });

  factory StatusInformation.fromJson(Map<String, dynamic> json) {
    return StatusInformation(
      isLogin: json["is_login"] ?? false,

      isOnline: json["is_online"] ?? false,

      lastSeen: json["last_seen"] != null
          ? DateTime.tryParse(json["last_seen"].toString())
          : null,

      isActive: json["is_active"] ?? false,

      isLogout: json["is_logout"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "is_login": isLogin,
      "is_online": isOnline,

      "last_seen": lastSeen?.toIso8601String(),

      "is_active": isActive,
      "is_logout": isLogout,
    };
  }
}

// ============================================================
// TIMESTAMPS
// ============================================================

class Timestamps {
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Timestamps({this.createdAt, this.updatedAt});

  factory Timestamps.fromJson(Map<String, dynamic> json) {
    return Timestamps(
      createdAt: json["created_at"] != null
          ? DateTime.tryParse(json["created_at"].toString())
          : null,

      updatedAt: json["updated_at"] != null
          ? DateTime.tryParse(json["updated_at"].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "created_at": createdAt?.toIso8601String(),

      "updated_at": updatedAt?.toIso8601String(),
    };
  }
}
