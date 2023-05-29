import 'package:donaso/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'dart:ui' as ui;

class Maps extends StatefulWidget {
  String username;
  Database db;

  Maps({Key? key, required this.username, required this.db}) : super(key: key);

  @override
  MapsState createState() => MapsState();
}

class MapsState extends State<Maps> {
  late GoogleMapController mapController;
  final double maxDistance = 10000000000; // Distance maximale en mètres
  late Position position;
  Set<Marker> markers = {};
  Location location = Location();
  BitmapDescriptor? basicBin;
  BitmapDescriptor? glassBin;
  BitmapDescriptor? Bin;

  @override
  void initState() {
    super.initState();
    requestLocationPermission();
    loadbasicBin();
    getCurrentLocation();
  }

  Future<void> getMarkers() async {
    var collection = await widget.db.findLocationsNearby(
      position.longitude,
      position.latitude,
    );
    setState(() {
      markers.clear();
      for (var location in collection) {
        var coordinates = location['location']['coordinates'];
        markers.add(
          Marker(
            markerId: MarkerId(location['_id'].toString()),
            position: LatLng(coordinates[1], coordinates[0]),
            icon: basicBin!,
            infoWindow: InfoWindow(
              title: location['description'],
              snippet: location['description'],
            ),
          ),
        );
      }
      print(markers.length);
    });
  }

  Future<void> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("non autorisé");
        // L'utilisateur a refusé l'autorisation de localisation
      }
    }
  }

  Future<void> loadbasicBin() async {
    try {
      final Uint8List markerIconData = await getBytesFromAsset(
        'assets/images/recyling-bin.png',
        100,
      );
      setState(() {
        basicBin = BitmapDescriptor.fromBytes(markerIconData);
      });
    } catch (e) {
      print('Erreur lors du chargement de l\'icône du marqueur : $e');
    }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Les services de localisation sont désactivés
      // Demandez à l'utilisateur de les activer
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // L'utilisateur a refusé l'autorisation de localisation
        return;
      }
    }

    Position currentPosition = await Geolocator.getCurrentPosition();
    setState(() {
      position = currentPosition;
    });

    getMarkers();
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
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
      ),
    );
  }
}
