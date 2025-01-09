import 'package:latlong2/latlong.dart';

class Customer {
  final String id;
  final String packageNumber;
  final String name;
  final String surname;
  final String phone;
  final String address;
  final LatLng location;

  Customer({
    required this.id,
    required this.packageNumber,
    required this.name,
    required this.surname,
    required this.phone,
    required this.address,
    required this.location,
  });

  // Convert a customer from a Map (data from Firebase)
  factory Customer.fromMap(String id, Map<String, dynamic> data) {
    final locationData = data['location'] ?? {};
    final latitude = locationData['latitude'] ?? 0.0;
    final longitude = locationData['longitude'] ?? 0.0;

    return Customer(
      id: id,
      packageNumber: data['packageNumber'] ?? '',
      name: data['name'] ?? '',
      surname: data['surname'] ?? '',
      phone: data['phone'] ?? '',
      address: data['address'] ?? '',
      location: LatLng(latitude, longitude),  // Convert latitude & longitude to LatLng
    );
  }

  // Convert customer to a Map for saving to Firebase
  Map<String, dynamic> toMap() {
    return {
      'packageNumber':packageNumber,
      'name': name,
      'surname': surname,
      'phone': phone,
      'address': address,
      'location': {  // Store location as latitude and longitude
        'latitude': location.latitude,
        'longitude': location.longitude,
      },
    };
  }
}
