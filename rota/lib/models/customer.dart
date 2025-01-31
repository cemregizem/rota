import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
//dart run build_runner build --delete-conflicting-outputs ile
part 'customer.freezed.dart';
part 'customer.g.dart';

//freezed kütüphanesi, Customer nesnesi için özel bir _Customer sınıfı oluşturur.
//_Customer private olduğu için doğrudan çağrılmaz.bu yüzden factory ile bi nesne oluşturulur.
//Customer nesneleri immutable olur.
//copyWith gibi fonksiyonlar kullanarak yeni nesne türetebiliriz
@freezed
class Customer with _$Customer {
  
  const factory Customer({
     String? id,
     String? packageNumber,
     String? name,
     String? surname,
     String? phone,
     String? address,
    @LatLngConverter() LatLng? location,
    @Default(false) bool deliverStatus,
    int? customerNumber,
  }) = _Customer;



  factory Customer.fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);

    /// Initial empty customer instance with default values
  static Customer initial() =>  Customer(
        id: '',
        packageNumber: '',
        name: '',
        surname: '',
        phone: '',
        address: '',
        location: LatLng(0.0, 0.0), // Location is nullable
        customerNumber: 0, // Set a default number
      );
}


/// LatLng sınıfı JSON dönüşümlerini desteklemiyor o yüzden JsonConverter kullandık.
class LatLngConverter implements JsonConverter<LatLng, Map<String, dynamic>> {
  const LatLngConverter();

  @override
  LatLng fromJson(Map<String, dynamic> json) {
    return LatLng(json['latitude'] ?? 0.0, json['longitude'] ?? 0.0);
  }

  @override
  Map<String, dynamic> toJson(LatLng object) {
    return {
      'latitude': object.latitude,
      'longitude': object.longitude,
    };
  }
}
