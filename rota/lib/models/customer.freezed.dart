// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Customer _$CustomerFromJson(Map<String, dynamic> json) {
  return _Customer.fromJson(json);
}

/// @nodoc
mixin _$Customer {
  String? get id => throw _privateConstructorUsedError;
  String get packageNumber => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get surname => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  @LatLngConverter()
  LatLng get location =>
      throw _privateConstructorUsedError; // Apply the converter
  bool get deliverStatus => throw _privateConstructorUsedError;
  int get customerNumber => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CustomerCopyWith<Customer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerCopyWith<$Res> {
  factory $CustomerCopyWith(Customer value, $Res Function(Customer) then) =
      _$CustomerCopyWithImpl<$Res, Customer>;
  @useResult
  $Res call(
      {String? id,
      String packageNumber,
      String name,
      String surname,
      String phone,
      String address,
      @LatLngConverter() LatLng location,
      bool deliverStatus,
      int customerNumber});
}

/// @nodoc
class _$CustomerCopyWithImpl<$Res, $Val extends Customer>
    implements $CustomerCopyWith<$Res> {
  _$CustomerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? packageNumber = null,
    Object? name = null,
    Object? surname = null,
    Object? phone = null,
    Object? address = null,
    Object? location = null,
    Object? deliverStatus = null,
    Object? customerNumber = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      packageNumber: null == packageNumber
          ? _value.packageNumber
          : packageNumber // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      surname: null == surname
          ? _value.surname
          : surname // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LatLng,
      deliverStatus: null == deliverStatus
          ? _value.deliverStatus
          : deliverStatus // ignore: cast_nullable_to_non_nullable
              as bool,
      customerNumber: null == customerNumber
          ? _value.customerNumber
          : customerNumber // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CustomerImplCopyWith<$Res>
    implements $CustomerCopyWith<$Res> {
  factory _$$CustomerImplCopyWith(
          _$CustomerImpl value, $Res Function(_$CustomerImpl) then) =
      __$$CustomerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String packageNumber,
      String name,
      String surname,
      String phone,
      String address,
      @LatLngConverter() LatLng location,
      bool deliverStatus,
      int customerNumber});
}

/// @nodoc
class __$$CustomerImplCopyWithImpl<$Res>
    extends _$CustomerCopyWithImpl<$Res, _$CustomerImpl>
    implements _$$CustomerImplCopyWith<$Res> {
  __$$CustomerImplCopyWithImpl(
      _$CustomerImpl _value, $Res Function(_$CustomerImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? packageNumber = null,
    Object? name = null,
    Object? surname = null,
    Object? phone = null,
    Object? address = null,
    Object? location = null,
    Object? deliverStatus = null,
    Object? customerNumber = null,
  }) {
    return _then(_$CustomerImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      packageNumber: null == packageNumber
          ? _value.packageNumber
          : packageNumber // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      surname: null == surname
          ? _value.surname
          : surname // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LatLng,
      deliverStatus: null == deliverStatus
          ? _value.deliverStatus
          : deliverStatus // ignore: cast_nullable_to_non_nullable
              as bool,
      customerNumber: null == customerNumber
          ? _value.customerNumber
          : customerNumber // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomerImpl implements _Customer {
  const _$CustomerImpl(
      {this.id,
      required this.packageNumber,
      required this.name,
      required this.surname,
      required this.phone,
      required this.address,
      @LatLngConverter() required this.location,
      this.deliverStatus = false,
      required this.customerNumber});

  factory _$CustomerImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerImplFromJson(json);

  @override
  final String? id;
  @override
  final String packageNumber;
  @override
  final String name;
  @override
  final String surname;
  @override
  final String phone;
  @override
  final String address;
  @override
  @LatLngConverter()
  final LatLng location;
// Apply the converter
  @override
  @JsonKey()
  final bool deliverStatus;
  @override
  final int customerNumber;

  @override
  String toString() {
    return 'Customer(id: $id, packageNumber: $packageNumber, name: $name, surname: $surname, phone: $phone, address: $address, location: $location, deliverStatus: $deliverStatus, customerNumber: $customerNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.packageNumber, packageNumber) ||
                other.packageNumber == packageNumber) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.surname, surname) || other.surname == surname) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.deliverStatus, deliverStatus) ||
                other.deliverStatus == deliverStatus) &&
            (identical(other.customerNumber, customerNumber) ||
                other.customerNumber == customerNumber));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, packageNumber, name, surname,
      phone, address, location, deliverStatus, customerNumber);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerImplCopyWith<_$CustomerImpl> get copyWith =>
      __$$CustomerImplCopyWithImpl<_$CustomerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerImplToJson(
      this,
    );
  }
}

abstract class _Customer implements Customer {
  const factory _Customer(
      {final String? id,
      required final String packageNumber,
      required final String name,
      required final String surname,
      required final String phone,
      required final String address,
      @LatLngConverter() required final LatLng location,
      final bool deliverStatus,
      required final int customerNumber}) = _$CustomerImpl;

  factory _Customer.fromJson(Map<String, dynamic> json) =
      _$CustomerImpl.fromJson;

  @override
  String? get id;
  @override
  String get packageNumber;
  @override
  String get name;
  @override
  String get surname;
  @override
  String get phone;
  @override
  String get address;
  @override
  @LatLngConverter()
  LatLng get location;
  @override // Apply the converter
  bool get deliverStatus;
  @override
  int get customerNumber;
  @override
  @JsonKey(ignore: true)
  _$$CustomerImplCopyWith<_$CustomerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
