import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';


//StreamProvider listens to location updates continuously, ensuring the map updates when your location changes.
//Using StreamProvider to manage real time data
final locationProvider = StreamProvider<Position>((ref) async* {
  // Request location permissions
  LocationPermission permission = await Geolocator.checkPermission(); //checks current location permission status
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission(); //if permission is denied request permission using
    if (permission == LocationPermission.denied) {
      throw Exception('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw Exception('Location permissions are permanently denied');
  }

  //yield*, başka bir iterable veya stream’den gelen değerleri kendi üretiyormuş gibi dışarı aktarmak için kullanılır.
  //The yield  can be used only in generators functions.
  //return gibi ama fonksiyonu terminate etmiyor
  yield* Geolocator.getPositionStream( //Starts a stream that listens to location updates from the device.
    locationSettings: LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100, // Minimum distance in meters to trigger an update
    ),
  );
});
