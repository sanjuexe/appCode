// ignore_for_file: non_constant_identifier_names
import 'base.dart';

class BannersModel extends BaseModel {
  static const schema = CollectionSchema('banners', BannersModel.fromJson, {
    'image_id': (type: ImageIdAttr(), required: true),
    'action_url': (type: StringAttr(2048), required: false),
    'description': (type: StringAttr(100), required: false),
  });

  @override
  final String id;
  final String image_id;
  final String? action_url;
  final String? description;

  const BannersModel(
    this.id,
    this.image_id,
    this.action_url,
    this.description,
  );

  factory BannersModel.fromJson(Map<String, dynamic> data) {
    return BannersModel(
      data['\$id'],
      data['image_id'],
      data['action_url'],
      data['description'],
    );
  }

  @override
  dynamic getAttr(String attr) => switch (attr) {
        'id' => id,
        'image_id' => image_id,
        'action_url' => action_url,
        'description' => description,
        _ => throw InvalidAttribute(attr),
      };
}

class PackagesModel extends BaseModel {
  static const schema = CollectionSchema('packages', PackagesModel.fromJson, {
    'name': (type: StringAttr(50), required: true),
    'image_id': (type: ImageIdAttr(), required: true),
    'homepage_visibility': (type: BooleanAttr(true), required: false),
    'short_description': (type: StringAttr(2000), required: false),
    'long_description': (type: StringAttr(5000), required: false),
    'services': (type: Many2ManyRelationAttr('services'), required: false),
  });

  @override
  final String id;
  final String name;
  final String image_id;
  final bool? homepage_visibility;
  final String? short_description;
  final String? long_description;
  final List<ServicesModel>? services;

  const PackagesModel(
    this.id,
    this.name,
    this.image_id,
    this.homepage_visibility,
    this.short_description,
    this.long_description,
    this.services,
  );

  factory PackagesModel.fromJson(Map<String, dynamic> data) {
    return PackagesModel(
      data['\$id'],
      data['name'],
      data['image_id'],
      data['homepage_visibility'],
      data['short_description'],
      data['long_description'],
      data['services']
          ?.map<ServicesModel>((m) => ServicesModel.fromJson(m))
          ?.toList(),
    );
  }

  @override
  dynamic getAttr(String attr) => switch (attr) {
        'id' => id,
        'name' => name,
        'image_id' => image_id,
        'homepage_visibility' => homepage_visibility,
        'short_description' => short_description,
        'long_description' => long_description,
        'services' => services,
        _ => throw InvalidAttribute(attr),
      };
}

class ServicesModel extends BaseModel {
  static const schema = CollectionSchema('services', ServicesModel.fromJson, {
    'name': (type: StringAttr(50), required: true),
    'image_id': (type: ImageIdAttr(), required: true),
    'homepage_visibility': (type: BooleanAttr(true), required: false),
    'short_description': (type: StringAttr(2000), required: false),
    'long_description': (type: StringAttr(5000), required: false),
    'packages': (type: Many2ManyRelationAttr('packages'), required: false),
  });

  @override
  final String id;
  final String name;
  final String image_id;
  final bool? homepage_visibility;
  final String? short_description;
  final String? long_description;
  final List<PackagesModel>? packages;

  const ServicesModel(
    this.id,
    this.name,
    this.image_id,
    this.homepage_visibility,
    this.short_description,
    this.long_description,
    this.packages,
  );

  factory ServicesModel.fromJson(Map<String, dynamic> data) {
    return ServicesModel(
      data['\$id'],
      data['name'],
      data['image_id'],
      data['homepage_visibility'],
      data['short_description'],
      data['long_description'],
      data['packages']
          ?.map<PackagesModel>((m) => PackagesModel.fromJson(m))
          ?.toList(),
    );
  }

  @override
  dynamic getAttr(String attr) => switch (attr) {
        'id' => id,
        'name' => name,
        'image_id' => image_id,
        'homepage_visibility' => homepage_visibility,
        'short_description' => short_description,
        'long_description' => long_description,
        'packages' => packages,
        _ => throw InvalidAttribute(attr),
      };
}

class PackagePurchaseHistoryModel extends BaseModel {
  static const schema = CollectionSchema(
      'package_purchase_history', PackagePurchaseHistoryModel.fromJson, {
    'user_id': (type: StringAttr(30), required: true),
    'valid_from': (type: DateTimeAttr(), required: true),
    'valid_to': (type: DateTimeAttr(), required: true),
    'status': (
      type: EnumAttr(["active", "pending", "completed"]),
      required: true
    ),
    'package': (type: Many2OneRelationAttr('packages'), required: false),
    'remarks': (type: StringAttr(5000), required: false),
  });

  @override
  final String id;
  final String user_id;
  final DateTime valid_from;
  final DateTime valid_to;
  final String status;
  final PackagesModel? package;
  final String? remarks;

  const PackagePurchaseHistoryModel(
    this.id,
    this.user_id,
    this.valid_from,
    this.valid_to,
    this.status,
    this.package,
    this.remarks,
  );

  factory PackagePurchaseHistoryModel.fromJson(Map<String, dynamic> data) {
    return PackagePurchaseHistoryModel(
      data['\$id'],
      data['user_id'],
      DateTime.parse(data['valid_from']),
      DateTime.parse(data['valid_to']),
      data['status'],
      data['package'] != null ? PackagesModel.fromJson(data['package']) : null,
      data['remarks'],
    );
  }

  @override
  dynamic getAttr(String attr) => switch (attr) {
        'id' => id,
        'user_id' => user_id,
        'valid_from' => valid_from,
        'valid_to' => valid_to,
        'status' => status,
        'package' => package,
        'remarks' => remarks,
        _ => throw InvalidAttribute(attr),
      };
}

class ServicePurchaseHistoryModel extends BaseModel {
  static const schema = CollectionSchema(
      'service_purchase_history', ServicePurchaseHistoryModel.fromJson, {
    'user_id': (type: StringAttr(30), required: true),
    'valid_from': (type: DateTimeAttr(), required: true),
    'valid_to': (type: DateTimeAttr(), required: true),
    'active': (type: BooleanAttr(true), required: false),
    'service': (type: Many2OneRelationAttr('services'), required: false),
  });

  @override
  final String id;
  final String user_id;
  final DateTime valid_from;
  final DateTime valid_to;
  final bool? active;
  final ServicesModel? service;

  const ServicePurchaseHistoryModel(
    this.id,
    this.user_id,
    this.valid_from,
    this.valid_to,
    this.active,
    this.service,
  );

  factory ServicePurchaseHistoryModel.fromJson(Map<String, dynamic> data) {
    return ServicePurchaseHistoryModel(
      data['\$id'],
      data['user_id'],
      DateTime.parse(data['valid_from']),
      DateTime.parse(data['valid_to']),
      data['active'],
      data['service'] != null ? ServicesModel.fromJson(data['service']) : null,
    );
  }

  @override
  dynamic getAttr(String attr) => switch (attr) {
        'id' => id,
        'user_id' => user_id,
        'valid_from' => valid_from,
        'valid_to' => valid_to,
        'active' => active,
        'service' => service,
        _ => throw InvalidAttribute(attr),
      };
}

class UserDataModel extends BaseModel {
  static const schema = CollectionSchema('user_data', UserDataModel.fromJson, {
    'user_id': (type: StringAttr(30), required: true),
    'service_purchase_history': (
      type: One2ManyRelationAttr('service_purchase_history'),
      required: false
    ),
    'package_purchase_history': (
      type: One2ManyRelationAttr('package_purchase_history'),
      required: false
    ),
  });

  @override
  final String id;
  final String user_id;
  final List<ServicePurchaseHistoryModel>? service_purchase_history;
  final List<PackagePurchaseHistoryModel>? package_purchase_history;

  const UserDataModel(
    this.id,
    this.user_id,
    this.service_purchase_history,
    this.package_purchase_history,
  );

  factory UserDataModel.fromJson(Map<String, dynamic> data) {
    return UserDataModel(
      data['\$id'],
      data['user_id'],
      data['service_purchase_history']
          ?.map<ServicePurchaseHistoryModel>(
              (m) => ServicePurchaseHistoryModel.fromJson(m))
          ?.toList(),
      data['package_purchase_history']
          ?.map<PackagePurchaseHistoryModel>(
              (m) => PackagePurchaseHistoryModel.fromJson(m))
          ?.toList(),
    );
  }

  @override
  dynamic getAttr(String attr) => switch (attr) {
        'id' => id,
        'user_id' => user_id,
        'service_purchase_history' => service_purchase_history,
        'package_purchase_history' => package_purchase_history,
        _ => throw InvalidAttribute(attr),
      };
}

class PackageEnquiryModel extends BaseModel {
  static const schema =
      CollectionSchema('package_enquiry', PackageEnquiryModel.fromJson, {
    'user_id': (type: StringAttr(30), required: true),
    'enquiry_date': (type: DateTimeAttr(), required: true),
    'resolved': (type: BooleanAttr(null), required: true),
    'package': (type: Many2OneRelationAttr('packages'), required: false),
  });

  @override
  final String id;
  final String user_id;
  final DateTime enquiry_date;
  final bool resolved;
  final PackagesModel? package;

  const PackageEnquiryModel(
    this.id,
    this.user_id,
    this.enquiry_date,
    this.resolved,
    this.package,
  );

  factory PackageEnquiryModel.fromJson(Map<String, dynamic> data) {
    return PackageEnquiryModel(
      data['\$id'],
      data['user_id'],
      DateTime.parse(data['enquiry_date']),
      data['resolved'],
      data['package'] != null ? PackagesModel.fromJson(data['package']) : null,
    );
  }

  @override
  dynamic getAttr(String attr) => switch (attr) {
        'id' => id,
        'user_id' => user_id,
        'enquiry_date' => enquiry_date,
        'resolved' => resolved,
        'package' => package,
        _ => throw InvalidAttribute(attr),
      };
}

class ServiceEnquiryModel extends BaseModel {
  static const schema =
      CollectionSchema('service_enquiry', ServiceEnquiryModel.fromJson, {
    'user_id': (type: StringAttr(30), required: true),
    'enquiry_date': (type: DateTimeAttr(), required: true),
    'expected_delivery_date': (type: DateTimeAttr(), required: true),
    'status': (
      type: EnumAttr(["active", "pending", "completed"]),
      required: true
    ),
    'service': (type: Many2OneRelationAttr('services'), required: false),
    'remarks': (type: StringAttr(5000), required: false),
  });

  @override
  final String id;
  final String user_id;
  final DateTime enquiry_date;
  final DateTime expected_delivery_date;
  final String status;
  final ServicesModel? service;
  final String? remarks;

  const ServiceEnquiryModel(
    this.id,
    this.user_id,
    this.enquiry_date,
    this.expected_delivery_date,
    this.status,
    this.service,
    this.remarks,
  );

  factory ServiceEnquiryModel.fromJson(Map<String, dynamic> data) {
    return ServiceEnquiryModel(
      data['\$id'],
      data['user_id'],
      DateTime.parse(data['enquiry_date']),
      DateTime.parse(data['expected_delivery_date']),
      data['status'],
      data['service'] != null ? ServicesModel.fromJson(data['service']) : null,
      data['remarks'],
    );
  }

  @override
  dynamic getAttr(String attr) => switch (attr) {
        'id' => id,
        'user_id' => user_id,
        'enquiry_date' => enquiry_date,
        'expected_delivery_date' => expected_delivery_date,
        'status' => status,
        'service' => service,
        'remarks' => remarks,
        _ => throw InvalidAttribute(attr),
      };
}

class NotificationsModel extends BaseModel {
  static const schema =
      CollectionSchema('notifications', NotificationsModel.fromJson, {
    'image_id': (type: ImageIdAttr(), required: false),
    'title': (type: StringAttr(100), required: true),
    'creation_date': (type: DateTimeAttr(), required: true),
    'action_url': (type: StringAttr(2048), required: false),
  });

  @override
  final String id;
  final String? image_id;
  final String title;
  final DateTime creation_date;
  final String? action_url;

  const NotificationsModel(
    this.id,
    this.image_id,
    this.title,
    this.creation_date,
    this.action_url,
  );

  factory NotificationsModel.fromJson(Map<String, dynamic> data) {
    return NotificationsModel(
      data['\$id'],
      data['image_id'],
      data['title'],
      DateTime.parse(data['creation_date']),
      data['action_url'],
    );
  }

  @override
  dynamic getAttr(String attr) => switch (attr) {
        'id' => id,
        'image_id' => image_id,
        'title' => title,
        'creation_date' => creation_date,
        'action_url' => action_url,
        _ => throw InvalidAttribute(attr),
      };
}

class AdminUsersModel extends BaseModel {
  static const schema =
      CollectionSchema('admin_users', AdminUsersModel.fromJson, {
    'username': (type: StringAttr(50), required: true),
    'password': (type: StringAttr(50), required: true),
    'role': (type: EnumAttr(["MainAdmin", "SubAdmin"]), required: true),
  });

  @override
  final String id;
  final String username;
  final String password;
  final String role;

  const AdminUsersModel(
    this.id,
    this.username,
    this.password,
    this.role,
  );

  factory AdminUsersModel.fromJson(Map<String, dynamic> data) {
    return AdminUsersModel(
      data['\$id'],
      data['username'],
      data['password'],
      data['role'],
    );
  }

  @override
  dynamic getAttr(String attr) => switch (attr) {
        'id' => id,
        'username' => username,
        'password' => password,
        'role' => role,
        _ => throw InvalidAttribute(attr),
      };
}

CollectionSchema schemaById(String id) => switch (id) {
      'banners' => BannersModel.schema,
      'packages' => PackagesModel.schema,
      'services' => ServicesModel.schema,
      'package_purchase_history' => PackagePurchaseHistoryModel.schema,
      'service_purchase_history' => ServicePurchaseHistoryModel.schema,
      'user_data' => UserDataModel.schema,
      'package_enquiry' => PackageEnquiryModel.schema,
      'service_enquiry' => ServiceEnquiryModel.schema,
      'notifications' => NotificationsModel.schema,
      'admin_users' => AdminUsersModel.schema,
      _ => throw Exception('Invalid collection name'),
    };
