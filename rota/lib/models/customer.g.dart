// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerImpl _$$CustomerImplFromJson(Map<String, dynamic> json) =>
    _$CustomerImpl(
      id: json['id'] as String?,
      packageNumber: json['packageNumber'] as String?,
      name: json['name'] as String?,
      surname: json['surname'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      location: _$JsonConverterFromJson<Map<String, dynamic>, LatLng>(
          json['location'], const LatLngConverter().fromJson),
      deliverStatus: json['deliverStatus'] as bool? ?? false,
      customerNumber: (json['customerNumber'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$CustomerImplToJson(_$CustomerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'packageNumber': instance.packageNumber,
      'name': instance.name,
      'surname': instance.surname,
      'phone': instance.phone,
      'address': instance.address,
      'location': _$JsonConverterToJson<Map<String, dynamic>, LatLng>(
          instance.location, const LatLngConverter().toJson),
      'deliverStatus': instance.deliverStatus,
      'customerNumber': instance.customerNumber,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
