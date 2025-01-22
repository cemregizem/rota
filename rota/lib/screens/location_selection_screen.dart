import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

//Kullanıcının adres için haritadan lokasyon seçtiği ekran
class LocationSelectorScreen extends StatefulWidget {
  const LocationSelectorScreen({super.key});

  @override
  LocationSelectorScreenState createState() => LocationSelectorScreenState();
}

class LocationSelectorScreenState extends State<LocationSelectorScreen> {
  LatLng selectedLocation = LatLng(38.457891491766354, 27.21305095847274);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Location')),
      body: FlutterMap(
        options: MapOptions(
          center: selectedLocation,
          zoom: 15.0,
          onTap: (tapPosition, point) {
            setState(() {
              selectedLocation = point;
            });
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: selectedLocation,
                width: 80.0,
                height: 80.0,
                builder: (ctx) => const Icon(
                  Icons.location_pin,
                  size: 40.0,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, selectedLocation);
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
