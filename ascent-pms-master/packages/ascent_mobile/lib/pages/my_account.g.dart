// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_account.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$purchasedAndAdditionalServicesHash() =>
    r'87e06bcf0f6dc163db67b77fb84789ea212458c4';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [purchasedAndAdditionalServices].
@ProviderFor(purchasedAndAdditionalServices)
const purchasedAndAdditionalServicesProvider =
    PurchasedAndAdditionalServicesFamily();

/// See also [purchasedAndAdditionalServices].
class PurchasedAndAdditionalServicesFamily
    extends Family<AsyncValue<(List<ServicesModel>, List<ServicesModel>)?>> {
  /// See also [purchasedAndAdditionalServices].
  const PurchasedAndAdditionalServicesFamily();

  /// See also [purchasedAndAdditionalServices].
  PurchasedAndAdditionalServicesProvider call(
    String userId,
  ) {
    return PurchasedAndAdditionalServicesProvider(
      userId,
    );
  }

  @override
  PurchasedAndAdditionalServicesProvider getProviderOverride(
    covariant PurchasedAndAdditionalServicesProvider provider,
  ) {
    return call(
      provider.userId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'purchasedAndAdditionalServicesProvider';
}

/// See also [purchasedAndAdditionalServices].
class PurchasedAndAdditionalServicesProvider extends AutoDisposeFutureProvider<
    (List<ServicesModel>, List<ServicesModel>)?> {
  /// See also [purchasedAndAdditionalServices].
  PurchasedAndAdditionalServicesProvider(
    String userId,
  ) : this._internal(
          (ref) => purchasedAndAdditionalServices(
            ref as PurchasedAndAdditionalServicesRef,
            userId,
          ),
          from: purchasedAndAdditionalServicesProvider,
          name: r'purchasedAndAdditionalServicesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$purchasedAndAdditionalServicesHash,
          dependencies: PurchasedAndAdditionalServicesFamily._dependencies,
          allTransitiveDependencies:
              PurchasedAndAdditionalServicesFamily._allTransitiveDependencies,
          userId: userId,
        );

  PurchasedAndAdditionalServicesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    FutureOr<(List<ServicesModel>, List<ServicesModel>)?> Function(
            PurchasedAndAdditionalServicesRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PurchasedAndAdditionalServicesProvider._internal(
        (ref) => create(ref as PurchasedAndAdditionalServicesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<(List<ServicesModel>, List<ServicesModel>)?>
      createElement() {
    return _PurchasedAndAdditionalServicesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PurchasedAndAdditionalServicesProvider &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PurchasedAndAdditionalServicesRef on AutoDisposeFutureProviderRef<
    (List<ServicesModel>, List<ServicesModel>)?> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _PurchasedAndAdditionalServicesProviderElement
    extends AutoDisposeFutureProviderElement<
        (List<ServicesModel>, List<ServicesModel>)?>
    with PurchasedAndAdditionalServicesRef {
  _PurchasedAndAdditionalServicesProviderElement(super.provider);

  @override
  String get userId =>
      (origin as PurchasedAndAdditionalServicesProvider).userId;
}

String _$serviceEnquiryHash() => r'a8d33cb0bdb66078c0983c0d617cab621a5dc3b4';

/// See also [serviceEnquiry].
@ProviderFor(serviceEnquiry)
const serviceEnquiryProvider = ServiceEnquiryFamily();

/// See also [serviceEnquiry].
class ServiceEnquiryFamily
    extends Family<AsyncValue<List<ServiceEnquiryModel>>> {
  /// See also [serviceEnquiry].
  const ServiceEnquiryFamily();

  /// See also [serviceEnquiry].
  ServiceEnquiryProvider call(
    String userId,
  ) {
    return ServiceEnquiryProvider(
      userId,
    );
  }

  @override
  ServiceEnquiryProvider getProviderOverride(
    covariant ServiceEnquiryProvider provider,
  ) {
    return call(
      provider.userId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'serviceEnquiryProvider';
}

/// See also [serviceEnquiry].
class ServiceEnquiryProvider
    extends AutoDisposeFutureProvider<List<ServiceEnquiryModel>> {
  /// See also [serviceEnquiry].
  ServiceEnquiryProvider(
    String userId,
  ) : this._internal(
          (ref) => serviceEnquiry(
            ref as ServiceEnquiryRef,
            userId,
          ),
          from: serviceEnquiryProvider,
          name: r'serviceEnquiryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$serviceEnquiryHash,
          dependencies: ServiceEnquiryFamily._dependencies,
          allTransitiveDependencies:
              ServiceEnquiryFamily._allTransitiveDependencies,
          userId: userId,
        );

  ServiceEnquiryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    FutureOr<List<ServiceEnquiryModel>> Function(ServiceEnquiryRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ServiceEnquiryProvider._internal(
        (ref) => create(ref as ServiceEnquiryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ServiceEnquiryModel>> createElement() {
    return _ServiceEnquiryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ServiceEnquiryProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ServiceEnquiryRef
    on AutoDisposeFutureProviderRef<List<ServiceEnquiryModel>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _ServiceEnquiryProviderElement
    extends AutoDisposeFutureProviderElement<List<ServiceEnquiryModel>>
    with ServiceEnquiryRef {
  _ServiceEnquiryProviderElement(super.provider);

  @override
  String get userId => (origin as ServiceEnquiryProvider).userId;
}

String _$serviceEnquiryByStatusHash() =>
    r'cc1e05b875788fc3cf471a2aabc6da3b16cb2c41';

/// See also [serviceEnquiryByStatus].
@ProviderFor(serviceEnquiryByStatus)
const serviceEnquiryByStatusProvider = ServiceEnquiryByStatusFamily();

/// See also [serviceEnquiryByStatus].
class ServiceEnquiryByStatusFamily
    extends Family<AsyncValue<List<ServiceEnquiryModel>>> {
  /// See also [serviceEnquiryByStatus].
  const ServiceEnquiryByStatusFamily();

  /// See also [serviceEnquiryByStatus].
  ServiceEnquiryByStatusProvider call(
    String userId,
    String status,
  ) {
    return ServiceEnquiryByStatusProvider(
      userId,
      status,
    );
  }

  @override
  ServiceEnquiryByStatusProvider getProviderOverride(
    covariant ServiceEnquiryByStatusProvider provider,
  ) {
    return call(
      provider.userId,
      provider.status,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'serviceEnquiryByStatusProvider';
}

/// See also [serviceEnquiryByStatus].
class ServiceEnquiryByStatusProvider
    extends AutoDisposeFutureProvider<List<ServiceEnquiryModel>> {
  /// See also [serviceEnquiryByStatus].
  ServiceEnquiryByStatusProvider(
    String userId,
    String status,
  ) : this._internal(
          (ref) => serviceEnquiryByStatus(
            ref as ServiceEnquiryByStatusRef,
            userId,
            status,
          ),
          from: serviceEnquiryByStatusProvider,
          name: r'serviceEnquiryByStatusProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$serviceEnquiryByStatusHash,
          dependencies: ServiceEnquiryByStatusFamily._dependencies,
          allTransitiveDependencies:
              ServiceEnquiryByStatusFamily._allTransitiveDependencies,
          userId: userId,
          status: status,
        );

  ServiceEnquiryByStatusProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
    required this.status,
  }) : super.internal();

  final String userId;
  final String status;

  @override
  Override overrideWith(
    FutureOr<List<ServiceEnquiryModel>> Function(
            ServiceEnquiryByStatusRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ServiceEnquiryByStatusProvider._internal(
        (ref) => create(ref as ServiceEnquiryByStatusRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
        status: status,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ServiceEnquiryModel>> createElement() {
    return _ServiceEnquiryByStatusProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ServiceEnquiryByStatusProvider &&
        other.userId == userId &&
        other.status == status;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);
    hash = _SystemHash.combine(hash, status.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ServiceEnquiryByStatusRef
    on AutoDisposeFutureProviderRef<List<ServiceEnquiryModel>> {
  /// The parameter `userId` of this provider.
  String get userId;

  /// The parameter `status` of this provider.
  String get status;
}

class _ServiceEnquiryByStatusProviderElement
    extends AutoDisposeFutureProviderElement<List<ServiceEnquiryModel>>
    with ServiceEnquiryByStatusRef {
  _ServiceEnquiryByStatusProviderElement(super.provider);

  @override
  String get userId => (origin as ServiceEnquiryByStatusProvider).userId;
  @override
  String get status => (origin as ServiceEnquiryByStatusProvider).status;
}

String _$notificationsHash() => r'c530ba9b31e400b4f3fe50a1f188dcb4412b8aab';

/// See also [notifications].
@ProviderFor(notifications)
final notificationsProvider =
    AutoDisposeFutureProvider<(List<NotificationsModel>, DateTime?)>.internal(
  notifications,
  name: r'notificationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NotificationsRef
    = AutoDisposeFutureProviderRef<(List<NotificationsModel>, DateTime?)>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
