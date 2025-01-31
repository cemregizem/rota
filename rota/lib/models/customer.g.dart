// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerImpl _$$CustomerImplFromJson(Map<String, dynamic> json) =>
    _$CustomerImpl(
      id: json['id'] as String?,
      packageNumber: json['packageNumber'] as String,
      name: json['name'] as String,
      surname: json['surname'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      location: const LatLngConverter()
          .fromJson(json['location'] as Map<String, dynamic>),
      deliverStatus: json['deliverStatus'] as bool? ?? false,
      customerNumber: (json['customerNumber'] as num).toInt(),
    );

Map<String, dynamic> _$$CustomerImplToJson(_$CustomerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'packageNumber': instance.packageNumber,
      'name': instance.name,
      'surname': instance.surname,
      'phone': instance.phone,
      'address': instance.address,
      'location': const LatLngConverter().toJson(instance.location),
      'deliverStatus': instance.deliverStatus,
      'customerNumber': instance.customerNumber,
    };
