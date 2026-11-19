//     final singleUserDeleteResponseModel = singleUserDeleteResponseModelFromJson(jsonString);

import 'dart:convert';

SingleUserDeleteResponseModel singleUserDeleteResponseModelFromJson(
  String str,
) => SingleUserDeleteResponseModel.fromJson(json.decode(str));

String singleUserDeleteResponseModelToJson(
  SingleUserDeleteResponseModel data,
) => json.encode(data.toJson());

class SingleUserDeleteResponseModel {
  int status;
  int code;
  String message;
  Data data;

  SingleUserDeleteResponseModel({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  factory SingleUserDeleteResponseModel.fromJson(Map<String, dynamic> json) =>
      SingleUserDeleteResponseModel(
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
  String name;
  String role;
  DeletedBy deletedBy;
  DateTime deletedAt;

  Data({
    required this.id,
    required this.name,
    required this.role,
    required this.deletedBy,
    required this.deletedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    role: json["role"],
    deletedBy: DeletedBy.fromJson(json["deleted_by"]),
    deletedAt: DateTime.parse(json["deleted_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "role": role,
    "deleted_by": deletedBy.toJson(),
    "deleted_at": deletedAt.toIso8601String(),
  };
}

class DeletedBy {
  int id;
  String name;
  String role;

  DeletedBy({required this.id, required this.name, required this.role});

  factory DeletedBy.fromJson(Map<String, dynamic> json) =>
      DeletedBy(id: json["id"], name: json["name"], role: json["role"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name, "role": role};
}
