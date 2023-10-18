import 'package:appwrite/appwrite.dart';
import 'package:ascent_models/ascent_models.dart';
import 'package:ascent_utils/ascent_utils.dart';
import 'package:oxidized/oxidized.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'backend.g.dart';

Client buildClient(String endpoint, String projectId) {
  return Client().setEndpoint(endpoint).setProject(projectId);
}

@Riverpod(keepAlive: true)
String endpoint(EndpointRef ref) {
  throw UnimplementedError();
}

@Riverpod(keepAlive: true)
String projectId(ProjectIdRef ref) {
  throw UnimplementedError();
}

@Riverpod(keepAlive: true)
Client client(ClientRef ref) => throw UnimplementedError();

@Riverpod(keepAlive: true)
BackendRepository backendRepository(BackendRepositoryRef ref) =>
    BackendRepository(Databases(ref.watch(clientProvider)));

@Riverpod(keepAlive: true)
AccountRepository accountRepository(AccountRepositoryRef ref) =>
    AccountRepository(Account(ref.watch(clientProvider)));

final packagePurchaseHistoryProvider = FutureProvider.family.autoDispose(
  (ref, String userId) =>
      ref.watch(backendRepositoryProvider).packagePurchaseHistory(userId),
);

class AccountRepository {
  final Account _account;

  AccountRepository(this._account);

  Future<Option<UserAccountModel>> loggedInUser() async {
    try {
      final user = await _account.get();
      return Option.some(UserAccountModel(
        id: user.$id,
        name: user.name,
        phone: user.phone,
        email: user.email,
      ));
    } on AppwriteException catch (e) {
      if (e.type == 'general_unauthorized_scope') {
        return const Option.none();
      } else {
        rethrow;
      }
    }
  }

  Future<Result<T, String>> _wrapError<T extends Object>(
    Future<T> Function() f,
  ) async {
    try {
      final result = await f();
      return Result.ok(result);
    } on AppwriteException catch (e) {
      logger.e('Appwrite Error', error: e);
      if (e.type == 'user_blocked') {
        // marked as blocked on deletion of account
        logger.w(
            'Tried to use a user account which was already marked as deleted');
        return const Result.err(
            'Invalid credentials. Please check the email and password.');
      } else {
        return Result.err(e.message ?? 'An error occured');
      }
    } catch (e) {
      logger.e('Error on making appwrite request', error: e);
      rethrow;
    }
  }

  Future<Result<Unit, String>> login({
    required String email,
    required String password,
  }) async =>
      _wrapError(() =>
              _account.createEmailSession(email: email, password: password))
          .map((a) => unit);

  Future<void> logout() => _account.deleteSessions();

  Future<Result<Unit, String>> create({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    return _wrapError(() async {
      await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );

      return unit;
    });
  }

  Future<Result<Unit, String>> delete() async {
    return _wrapError(() async {
      await _account.updateStatus();
      // TODO(important): the account gets blocked but the session is not deleted.
      // This makes it impossible to login/create a new account after deleting
      // the old account:  https://github.com/appwrite/appwrite/issues/6061
      // Write an appwrite function that is triggered on a status change event

      // await logout();
      return unit;
    });
  }

  Future<Result<Unit, String>> updatePhone({
    required String phone,
    required String password,
  }) async {
    return _wrapError(() async {
      await _account.updatePhone(phone: phone, password: password);
      return unit;
    });
  }

  Future<Result<Unit, String>> updateEmail({
    required String email,
    required String password,
  }) async {
    return _wrapError(() async {
      await _account.updateEmail(email: email, password: password);
      return unit;
    });
  }

  Future<Result<Unit, String>> updateName(
    String name,
  ) async {
    return _wrapError(() async {
      await _account.updateName(name: name);
      return unit;
    });
  }

  static const _notifTimeKey = 'last_notification_read_time';

  Future<DateTime?> lastNotificationReadTime() async {
    final prefs = await _account.getPrefs();
    final date = prefs.data[_notifTimeKey];

    if (date == null) return null;

    return DateTime.parse(date);
  }

  Future<void> markNotificationRead() async {
    await _account.updatePrefs(prefs: {
      _notifTimeKey: DateTime.now().toIso8601String(),
    });
  }
}

class BackendRepository {
  final Databases _db;
  final String _databaseId;

  BackendRepository(
    this._db, {
    databaseId = appwriteDefaultDatabaseId,
  }) : _databaseId = databaseId;

  Future<List<T>> _list<T extends BaseModel>(
    CollectionSchema schema, {
    List<String>? queries,
  }) async {
    try {
      return await _db
          .listDocuments(
            databaseId: _databaseId,
            collectionId: schema.id,
            queries: queries,
          )
          .then((docList) => docList.documents)
          .then((docs) =>
              docs.map((d) => schema.modelFromJson(d.data) as T).toList());
    } catch (e) {
      logger.e(
        'Error listing documents from "${schema.id}" collection',
        error: e,
      );
      rethrow;
    }
  }

  Future<void> _create(
    CollectionSchema schema,
    Map<String, dynamic> data,
  ) async {
    try {
      await _db.createDocument(
        databaseId: _databaseId,
        collectionId: schema.id,
        documentId: ID.unique(),
        data: data,
      );
    } catch (e) {
      logger.e(
        'Error creating document in "${schema.id}" collection with data $data',
        error: e,
      );
      rethrow;
    }
  }

  Future<List<BannersModel>> banners() => _list(BannersModel.schema);

  Future<List<PackagesModel>> homepagePackages() async {
    final list = await _list<PackagesModel>(PackagesModel.schema);
    return list.where((p) => p.homepage_visibility ?? true).toList();
  }

  Future<List<ServicesModel>> services() => _list(ServicesModel.schema);

  Future<List<NotificationsModel>> notifications() =>
      _list(NotificationsModel.schema);

  Future<List<PackagePurchaseHistoryModel>> packagePurchaseHistory(
          String userId) =>
      _list(
        PackagePurchaseHistoryModel.schema,
        queries: [Query.equal('user_id', userId)],
      );

  Future<List<ServiceEnquiryModel>> serviceEnquiries(String userId) async =>
      _list(ServiceEnquiryModel.schema,
          queries: [Query.equal('user_id', userId)]);

  Future<void> createPackageEnquiry(
    String userId,
    String packageId,
    DateTime enquiryDate,
  ) async {
    final data = {
      'user_id': userId,
      'package': packageId,
      'valid_from': enquiryDate.toIso8601String(),
      'valid_to': enquiryDate.add(const Duration(days: 365)).toIso8601String(),
      'status': 'pending',
    };
    // NOTE: We use package purchase history here internally instead of package enquiry for historical reasons.
    await _create(PackagePurchaseHistoryModel.schema, data);
  }

  Future<void> createServiceEnquiry({
    required String userId,
    required String serviceId,
    required DateTime enquiryDate,
    required DateTime expectedDeliveryDate,
  }) async {
    final data = {
      'user_id': userId,
      'service': serviceId,
      'enquiry_date': enquiryDate.toIso8601String(),
      'expected_delivery_date': expectedDeliveryDate.toIso8601String(),
      'status': 'pending',
    };
    await _create(ServiceEnquiryModel.schema, data);
  }
}

extension PackagePurchaseHistoryExt on List<PackagePurchaseHistoryModel> {
  Option<PackagePurchaseHistoryModel> currentlyPurchasedPackage() {
    for (final purchase in this) {
      if (purchase.status == 'active') {
        return Option.some(purchase);
      }
    }
    return const Option.none();
  }

  bool hasExpiredPackage() => any((package) => package.status == 'completed');

  bool hasPendingPackage() => any((package) => package.status == 'pending');
}

extension NotificationsExt on List<NotificationsModel> {
  int countUnread(DateTime lastRead) {
    return where((n) => n.creation_date.isAfter(lastRead)).length;
  }
}
