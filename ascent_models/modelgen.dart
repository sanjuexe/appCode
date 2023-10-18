import 'dart:convert';
import 'dart:io';

import 'package:ascent_utils/ascent_utils.dart';

class AppwriteConfig {
  final String projectId;
  final String projectName;
  final List<Database> databases;
  final List<Collection> collections;
  final List<Bucket> buckets;

  AppwriteConfig({
    required this.projectId,
    required this.projectName,
    required this.databases,
    required this.collections,
    required this.buckets,
  });

  factory AppwriteConfig.fromRawJson(String str) =>
      AppwriteConfig.fromJson(json.decode(str));

  factory AppwriteConfig.fromJson(Map<String, dynamic> json) => AppwriteConfig(
        projectId: json["projectId"],
        projectName: json["projectName"],
        databases: List<Database>.from(
            json["databases"].map((x) => Database.fromJson(x))),
        collections: List<Collection>.from(
            json["collections"].map((x) => Collection.fromJson(x))),
        buckets:
            List<Bucket>.from(json["buckets"].map((x) => Bucket.fromJson(x))),
      );
}

class Bucket {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> permissions;
  final bool fileSecurity;
  final String name;
  final bool enabled;
  final int maximumFileSize;
  final List<dynamic> allowedFileExtensions;
  final String compression;
  final bool encryption;
  final bool antivirus;

  Bucket({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.permissions,
    required this.fileSecurity,
    required this.name,
    required this.enabled,
    required this.maximumFileSize,
    required this.allowedFileExtensions,
    required this.compression,
    required this.encryption,
    required this.antivirus,
  });

  factory Bucket.fromRawJson(String str) => Bucket.fromJson(json.decode(str));

  factory Bucket.fromJson(Map<String, dynamic> json) => Bucket(
        id: json["\u0024id"],
        createdAt: DateTime.parse(json["\u0024createdAt"]),
        updatedAt: DateTime.parse(json["\u0024updatedAt"]),
        permissions: List<String>.from(json["\u0024permissions"].map((x) => x)),
        fileSecurity: json["fileSecurity"],
        name: json["name"],
        enabled: json["enabled"],
        maximumFileSize: json["maximumFileSize"],
        allowedFileExtensions:
            List<dynamic>.from(json["allowedFileExtensions"].map((x) => x)),
        compression: json["compression"],
        encryption: json["encryption"],
        antivirus: json["antivirus"],
      );
}

class Collection {
  final String id;
  final List<dynamic> permissions;
  final String databaseId;
  final String name;
  final bool enabled;
  final bool documentSecurity;
  final List<Attribute> attributes;

  Collection({
    required this.id,
    required this.permissions,
    required this.databaseId,
    required this.name,
    required this.enabled,
    required this.documentSecurity,
    required this.attributes,
  });

  factory Collection.fromRawJson(String str) =>
      Collection.fromJson(json.decode(str));

  factory Collection.fromJson(Map<String, dynamic> json) => Collection(
        id: json["\u0024id"],
        permissions:
            List<dynamic>.from(json["\u0024permissions"].map((x) => x)),
        databaseId: json["databaseId"],
        name: json["name"],
        enabled: json["enabled"],
        documentSecurity: json["documentSecurity"],
        attributes: List<Attribute>.from(
            json["attributes"].map((x) => Attribute.fromJson(x))),
      );
}

class Attribute {
  final String key;
  final Type type;
  final Status status;
  final bool required;
  final bool array;
  final int? size;
  final dynamic attributeDefault;
  final String? format;
  final String? relatedCollection;
  final RelationType? relationType;
  final bool? twoWay;
  final String? twoWayKey;
  final String? onDelete;
  final String? side;
  final List<String>? enumElements;

  Attribute({
    required this.key,
    required this.type,
    required this.status,
    required this.required,
    required this.array,
    this.size,
    this.attributeDefault,
    this.format,
    this.relatedCollection,
    this.relationType,
    this.twoWay,
    this.twoWayKey,
    this.onDelete,
    this.side,
    this.enumElements,
  });

  factory Attribute.fromJson(Map<String, dynamic> json) => Attribute(
        key: json["key"],
        type: typeValues.map[json["type"]]!,
        status: statusValues.map[json["status"]]!,
        required: json["required"],
        array: json["array"],
        size: json["size"],
        attributeDefault: json["default"],
        format: json["format"],
        relatedCollection: json["relatedCollection"],
        relationType: relationTypeValues.map[json["relationType"]],
        twoWay: json["twoWay"],
        twoWayKey: json["twoWayKey"],
        onDelete: json["onDelete"],
        side: json["side"],
        enumElements: json['elements']?.cast<String>(),
      );
}

enum RelationType { manyToMany, manyToOne, oneToMany }

final relationTypeValues = EnumValues({
  "manyToMany": RelationType.manyToMany,
  "manyToOne": RelationType.manyToOne,
  "oneToMany": RelationType.oneToMany,
});

enum Status { available }

final statusValues = EnumValues({"available": Status.available});

enum Type { boolean, relationship, string, datetime }

final typeValues = EnumValues({
  "boolean": Type.boolean,
  "relationship": Type.relationship,
  "string": Type.string,
  "datetime": Type.datetime,
});

class Database {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  Database({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Database.fromRawJson(String str) =>
      Database.fromJson(json.decode(str));

  factory Database.fromJson(Map<String, dynamic> json) => Database(
        id: json["\u0024id"],
        name: json["name"],
        createdAt: DateTime.parse(json["\u0024createdAt"]),
        updatedAt: DateTime.parse(json["\u0024updatedAt"]),
      );
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

// --------------------------------------------------------------------------

void main() {
  final json = File('appwrite.json').readAsStringSync();
  final appwrite = AppwriteConfig.fromRawJson(json);

  final buffer = StringBuffer();

  writePreamble(buffer);

  for (final collection in appwrite.collections) {
    if (collection.id != collection.name) {
      continue;
    }
    writeModeltype(collection, buffer);
  }

  buffer.writeln('CollectionSchema schemaById(String id) => switch (id) {');
  for (final collection in appwrite.collections) {
    if (collection.id != collection.name) {
      continue;
    }
    buffer.writeln(
      "  '${collection.name}' => ${modelTypeName(collection.name)}.schema,",
    );
  }
  buffer.writeln("  _ => throw Exception('Invalid collection name'),");
  buffer.writeln('};');

  final out = File('lib/src/collections.dart');
  out.writeAsStringSync(buffer.toString(), flush: true);
}

void writePreamble(StringBuffer buffer) {
  buffer.writeln("""
// ignore_for_file: non_constant_identifier_names
import 'base.dart';
""");
}

String modelTypeName(String collectionName) {
  return '${collectionName.snakeCase2PascalCase()}Model';
}

void writeModeltype(Collection collection, StringBuffer buffer) {
  final modelName = modelTypeName(collection.name);
  buffer.writeln('class $modelName extends BaseModel {');

  buffer.writeln(
    "  static const schema = CollectionSchema('${collection.id}', $modelName.fromJson, {",
  );

  for (final Attribute(
        :key,
        :type,
        :relatedCollection,
        :relationType,
        :required,
        :attributeDefault,
        :size,
        :format,
        :enumElements,
      ) in collection.attributes) {
    final atype = switch (type) {
      // string attribute without a size is probablya url, maximum length
      // of url accepted by chrome is around 2048
      Type.string => key == 'image_id'
          ? "ImageIdAttr()"
          : format == 'enum'
              ? "EnumAttr(${stringifyList(enumElements!)})"
              : 'StringAttr(${size ?? 2048})',
      Type.boolean => 'BooleanAttr($attributeDefault)',
      Type.relationship => switch (relationType!) {
          RelationType.manyToMany =>
            "Many2ManyRelationAttr('${relatedCollection!}')",
          RelationType.manyToOne =>
            "Many2OneRelationAttr('${relatedCollection!}')",
          RelationType.oneToMany =>
            "One2ManyRelationAttr('${relatedCollection!}')",
        },
      Type.datetime => 'DateTimeAttr()'
    };
    buffer.writeln(
      "    '$key': (type: $atype, required: $required),",
    );
  }
  buffer.writeln('  });\n');

  // Write the attributes themselves with correspoding dart types
  buffer.writeln('  @override');
  buffer.writeln('  final String id;');
  for (final attr in collection.attributes) {
    final nullable = !attr.required;
    final type = switch (attr.type) {
      Type.string => 'String',
      Type.boolean => 'bool',
      Type.datetime => 'DateTime',
      Type.relationship => switch (attr.relationType!) {
          RelationType.manyToMany ||
          RelationType.oneToMany =>
            'List<${modelTypeName(attr.relatedCollection!)}>',
          RelationType.manyToOne => modelTypeName(attr.relatedCollection!),
        },
    };

    buffer.writeln('  final $type${nullable ? '?' : ''} ${attr.key};');
  }

  buffer.writeln();

  // Write constructor
  buffer.writeln('  const $modelName(');
  buffer.writeln('    this.id,');
  for (final attr in collection.attributes) {
    buffer.writeln('    this.${attr.key},');
  }
  buffer.writeln('  );\n');

  // Write factory method to construct the model from an appwrite Document
  buffer.writeln('  factory $modelName.fromJson(Map<String, dynamic> data) {');
  buffer.writeln('    return $modelName(');
  buffer.writeln("      data['\\\$id'],");
  for (final attr in collection.attributes) {
    if (attr.type == Type.relationship) {
      final related = modelTypeName(attr.relatedCollection!);
      switch (attr.relationType!) {
        case RelationType.manyToMany:
        case RelationType.oneToMany:
          buffer.writeln("      data['${attr.key}']");
          buffer.writeln(
              "          ?.map<$related>((m) => $related.fromJson(m))");
          buffer.writeln("          ?.toList(),");
          break;
        case RelationType.manyToOne:
          buffer.writeln(
              "      data['${attr.key}'] != null ? $related.fromJson(data['${attr.key}']) : null,");
      }
    } else if (attr.type == Type.datetime) {
      buffer.writeln("      DateTime.parse(data['${attr.key}']),");
    } else {
      buffer.writeln("      data['${attr.key}'],");
    }
  }
  buffer.writeln('    );');
  buffer.writeln('  }\n');

  // Write method to convert model to json
  // buffer.writeln('  @override');
  // buffer.writeln('  Map<String, dynamic> toJson() => {');
  // buffer.writeln("    'id': id,");
  // for (final Attribute(:key, :type) in collection.attributes) {
  //   if (type == Type.RELATIONSHIP) {
  //     buffer.writeln("    '$key': $key?.map((m) => m.toJson()).toList(),");
  //   } else {
  //     buffer.writeln("    '$key': $key,");
  //   }
  // }
  // buffer.writeln('  };\n');

  // Write method to get value of an attribute
  buffer.writeln('  @override');
  buffer.writeln('  dynamic getAttr(String attr) => switch (attr) {');
  buffer.writeln("    'id' => id,");
  for (final Attribute(:key) in collection.attributes) {
    buffer.writeln("    '$key' => $key,");
  }
  buffer.writeln(
    "    _ => throw InvalidAttribute(attr),",
  );
  buffer.writeln('  };');

  buffer.writeln('}\n');
}

String stringifyList(List<dynamic> list) {
  final contents = list.map((e) => '"$e"').join(', ');
  return '[$contents]';
}
