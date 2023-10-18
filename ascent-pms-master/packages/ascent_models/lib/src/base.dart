import 'collections.dart';

sealed class AttrType {
  const AttrType();
}

class StringAttr extends AttrType {
  final int maxLength;
  const StringAttr(this.maxLength);
}

class BooleanAttr extends AttrType {
  final bool? defaultValue;
  const BooleanAttr(this.defaultValue);
}

class ImageIdAttr extends AttrType {
  const ImageIdAttr();
}

class DateTimeAttr extends AttrType {
  const DateTimeAttr();
}

class EnumAttr extends AttrType {
  final List<String> values;
  const EnumAttr(this.values);
}

class Many2ManyRelationAttr extends AttrType {
  final String relatedCollectionId;
  const Many2ManyRelationAttr(this.relatedCollectionId);
}

class Many2OneRelationAttr extends AttrType {
  final String relatedCollectionId;
  const Many2OneRelationAttr(this.relatedCollectionId);
}

class One2ManyRelationAttr extends AttrType {
  final String relatedCollectionId;
  const One2ManyRelationAttr(this.relatedCollectionId);
}

typedef AttrMeta = ({AttrType type, bool required});
typedef AttrMap = Map<String, AttrMeta>;

sealed class ModelSchema {
  const ModelSchema();
}

class UserSchema extends ModelSchema {
  const UserSchema();
}

class CollectionSchema extends ModelSchema {
  final AttrMap fields;

  /// The collection ID of the model in the database.
  final String id;

  /// Factory function for creating the model from json.
  final BaseModel Function(Map<String, dynamic>) modelFromJson;

  const CollectionSchema(this.id, this.modelFromJson, this.fields);

  const CollectionSchema.jsonModel(this.id)
      : modelFromJson = JsonModel.fromJson,
        fields = const {};

  // Without these equality overrides, the class will not work well with
  // riverpod's family because {} != {} for `fields`.
  // https://stackoverflow.com/a/67851608/7115678
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CollectionSchema &&
          runtimeType == other.runtimeType &&
          id == id &&
          // NOTE: this is a shallow comparison
          _mapEquals(fields, other.fields);

  @override
  int get hashCode => Object.hash(id, fields);
}

class InvalidAttribute implements Exception {
  final String attributeName;
  const InvalidAttribute(this.attributeName);
}

abstract class BaseModel {
  const BaseModel();

  String get id;

  dynamic getAttr(String attr);
}

class JsonModel extends BaseModel {
  final Map<String, dynamic> json;
  const JsonModel(this.json);

  @override
  dynamic getAttr(String attr) {
    return json[attr];
  }

  @override
  String get id => json['\$id'];

  factory JsonModel.fromJson(Map<String, dynamic> data) => JsonModel(data);
}

class UserAccountModel extends BaseModel {
  @override
  final String id;
  final String name;
  final String phone;
  final String email;

  UserAccountModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
  });

  @override
  getAttr(String attr) => switch (attr) {
        'id' => id,
        'name' => name,
        'phone' => phone,
        'email' => email,
        _ => throw InvalidAttribute(attr),
      };

  // UserAccountModel.fromAppwrite(appwrite.User user)
  //     : id = user.$id,
  //       name = user.name,
  //       phone = user.phone,
  //       email = user.email;
}

class UserModel extends BaseModel {
  final UserAccountModel account;
  // TODO: Get rid of user_data since it just duplicates data already in package
  // and service purchase history. directly pull data from them doing filtering
  // based on user_id
  final UserDataModel data;

  UserModel(this.account, this.data);

  @override
  getAttr(String attr) => null;

  @override
  String get id => account.id;
}

// Copied from  package:flutter/foundation.dart
bool _mapEquals<T, U>(Map<T, U>? a, Map<T, U>? b) {
  if (a == null) {
    return b == null;
  }
  if (b == null || a.length != b.length) {
    return false;
  }
  if (identical(a, b)) {
    return true;
  }
  for (final T key in a.keys) {
    if (!b.containsKey(key) || b[key] != a[key]) {
      return false;
    }
  }
  return true;
}

extension AdminUsersExt on AdminUsersModel {
  bool get hasMainAdminRights => role == "MainAdmin";
  bool get hasSubAdminRights => role == "SubAdmin" || hasMainAdminRights;
}
