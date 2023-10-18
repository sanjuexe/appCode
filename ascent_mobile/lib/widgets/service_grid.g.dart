// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_grid.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$serviceEnquiryForHash() => r'a4a79841d467cd6d120d5ac0a4b72f007f4c5009';

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

/// See also [serviceEnquiryFor].
@ProviderFor(serviceEnquiryFor)
const serviceEnquiryForProvider = ServiceEnquiryForFamily();

/// See also [serviceEnquiryFor].
class ServiceEnquiryForFamily
    extends Family<AsyncValue<List<ServiceEnquiryModel>>> {
  /// See also [serviceEnquiryFor].
  const ServiceEnquiryForFamily();

  /// See also [serviceEnquiryFor].
  ServiceEnquiryForProvider call(
    String serviceId,
  ) {
    return ServiceEnquiryForProvider(
      serviceId,
    );
  }

  @override
  ServiceEnquiryForProvider getProviderOverride(
    covariant ServiceEnquiryForProvider provider,
  ) {
    return call(
      provider.serviceId,
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
  String? get name => r'serviceEnquiryForProvider';
}

/// See also [serviceEnquiryFor].
class ServiceEnquiryForProvider
    extends AutoDisposeFutureProvider<List<ServiceEnquiryModel>> {
  /// See also [serviceEnquiryFor].
  ServiceEnquiryForProvider(
    String serviceId,
  ) : this._internal(
          (ref) => serviceEnquiryFor(
            ref as ServiceEnquiryForRef,
            serviceId,
          ),
          from: serviceEnquiryForProvider,
          name: r'serviceEnquiryForProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$serviceEnquiryForHash,
          dependencies: ServiceEnquiryForFamily._dependencies,
          allTransitiveDependencies:
              ServiceEnquiryForFamily._allTransitiveDependencies,
          serviceId: serviceId,
        );

  ServiceEnquiryForProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.serviceId,
  }) : super.internal();

  final String serviceId;

  @override
  Override overrideWith(
    FutureOr<List<ServiceEnquiryModel>> Function(ServiceEnquiryForRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ServiceEnquiryForProvider._internal(
        (ref) => create(ref as ServiceEnquiryForRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        serviceId: serviceId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ServiceEnquiryModel>> createElement() {
    return _ServiceEnquiryForProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ServiceEnquiryForProvider && other.serviceId == serviceId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, serviceId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ServiceEnquiryForRef
    on AutoDisposeFutureProviderRef<List<ServiceEnquiryModel>> {
  /// The parameter `serviceId` of this provider.
  String get serviceId;
}

class _ServiceEnquiryForProviderElement
    extends AutoDisposeFutureProviderElement<List<ServiceEnquiryModel>>
    with ServiceEnquiryForRef {
  _ServiceEnquiryForProviderElement(super.provider);

  @override
  String get serviceId => (origin as ServiceEnquiryForProvider).serviceId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
