import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'database.dart';

class Maps extends StatefulWidget {
  String username;
  Database db;
  Maps({Key? key, required this.username, required this.db}) : super(key: key);

  @override
  MapsState createState() => MapsState();
}

class MapsState extends State<Maps> {
  late GoogleMapController mapController;
  final double maxDistance = 1000; // Distance maximale en mètres
  late Position position;
  LatLng? userLocation;

  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Permissions denied');
      }
    }
    position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    double latitude = position.latitude;
    double longitude = position.longitude;

    // Rechercher les positions à proximité
    List<Map<String, dynamic>> nearbyLocations =
        await widget.db.findLocationsNearby(latitude, longitude, maxDistance);

    // Ajouter des marqueurs pour les positions à proximité
    setState(() {
      markers.clear();
      for (var location in nearbyLocations) {
        double lat = location['coordinates'][1];
        double lng = location['coordinates'][0];
        LatLng position = LatLng(lat, lng);

        markers.add(Marker(
          markerId: MarkerId(position.toString()),
          position: position,
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 12.0,
        ),
        markers: markers,
      ),
    );
  }
}
