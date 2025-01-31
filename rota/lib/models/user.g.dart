// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      name: json['name'] as String,
      surname: json['surname'] as String,
      licensePlate: json['licensePlate'] as String,
      packageCount: (json['packageCount'] as num?)?.toInt() ?? 0,
      deliveredPackageCount:
          (json['deliveredPackageCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'surname': instance.surname,
      'licensePlate': instance.licensePlate,
      'packageCount': instance.packageCount,
      'deliveredPackageCount': instance.deliveredPackageCount,
    };
