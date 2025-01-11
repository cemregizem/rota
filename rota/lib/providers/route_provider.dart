import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

final routeProvider = FutureProvider.family<List<LatLng>, Map<String, LatLng>>(
  // I used FutureProvider to handle async. data (API call)
  (ref, locations) async {

    try {
      final userLocation = locations['userLocation']!;
      final customerLocation = locations['customerLocation']!;
      final apiKey = '5b3ce3597851110001cf62487d173d127c0941f4b9f7c383c13ac08a';

      final url =
          'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=${userLocation.longitude},${userLocation.latitude}&end=${customerLocation.longitude},${customerLocation.latitude}';

      final response = await http.get(Uri.parse(url));
   

      if (response.statusCode == 200) {
        print('API Response: Success');
        final data = json.decode(response.body);

        if (data['features'] != null &&
            data['features'].isNotEmpty &&
            data['features'][0]['geometry']['coordinates'] != null) {
          final coordinates =
              data['features'][0]['geometry']['coordinates'] as List;


         return coordinates
              .map((point) => LatLng(point[1], point[0]))
              .toList();

        } else {
          throw Exception('Invalid data format in API response.');
        }

      } else {
        throw Exception('API Error: ${response.body}');
      }

    } catch (e) {
      print('Error in routeProvider: $e');
      rethrow;
    }
  },
);
