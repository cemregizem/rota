// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_delivered_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$customerDeliverStatusHash() =>
    r'12335cc0b7d2772c76223d22a456362099fb00c6';

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

/// See also [customerDeliverStatus].
@ProviderFor(customerDeliverStatus)
const customerDeliverStatusProvider = CustomerDeliverStatusFamily();

/// See also [customerDeliverStatus].
class CustomerDeliverStatusFamily extends Family<AsyncValue<void>> {
  /// See also [customerDeliverStatus].
  const CustomerDeliverStatusFamily();

  /// See also [customerDeliverStatus].
  CustomerDeliverStatusProvider call({
    required Customer customer,
  }) {
    return CustomerDeliverStatusProvider(
      customer: customer,
    );
  }

  @override
  CustomerDeliverStatusProvider getProviderOverride(
    covariant CustomerDeliverStatusProvider provider,
  ) {
    return call(
      customer: provider.customer,
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
  String? get name => r'customerDeliverStatusProvider';
}

/// See also [customerDeliverStatus].
class CustomerDeliverStatusProvider extends AutoDisposeFutureProvider<void> {
  /// See also [customerDeliverStatus].
  CustomerDeliverStatusProvider({
    required Customer customer,
  }) : this._internal(
          (ref) => customerDeliverStatus(
            ref as CustomerDeliverStatusRef,
            customer: customer,
          ),
          from: customerDeliverStatusProvider,
          name: r'customerDeliverStatusProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$customerDeliverStatusHash,
          dependencies: CustomerDeliverStatusFamily._dependencies,
          allTransitiveDependencies:
              CustomerDeliverStatusFamily._allTransitiveDependencies,
          customer: customer,
        );

  CustomerDeliverStatusProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.customer,
  }) : super.internal();

  final Customer customer;

  @override
  Override overrideWith(
    FutureOr<void> Function(CustomerDeliverStatusRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CustomerDeliverStatusProvider._internal(
        (ref) => create(ref as CustomerDeliverStatusRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        customer: customer,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _CustomerDeliverStatusProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CustomerDeliverStatusProvider && other.customer == customer;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, customer.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CustomerDeliverStatusRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `customer` of this provider.
  Customer get customer;
}

class _CustomerDeliverStatusProviderElement
    extends AutoDisposeFutureProviderElement<void>
    with CustomerDeliverStatusRef {
  _CustomerDeliverStatusProviderElement(super.provider);

  @override
  Customer get customer => (origin as CustomerDeliverStatusProvider).customer;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
