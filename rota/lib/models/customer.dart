import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'lat_lng_converter.dart'; // Import the converter

part 'customer.freezed.dart';
part 'customer.g.dart';

@freezed
class Customer with _$Customer {
  const factory Customer({
    String? id,
    required String packageNumber,
    required String name,
    required String surname,
    required String phone,
    required String address,
    @LatLngConverter() required LatLng location, // Apply the converter
    @Default(false) bool deliverStatus,
    required int customerNumber,
  }) = _Customer;

  // Let freezed generate the fromJson method
  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
}