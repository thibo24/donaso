import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/profile/user.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'dart:ui' as ui;
import 'database.dart';
import 'navigationBar.dart';

class Maps extends StatefulWidget {
  User user;
  Database db;
  int selectedIndex;
  Function(int) onPageSelected;

  Maps(
      {Key? key,
      required this.user,
      required this.db,
      required this.selectedIndex,
      required this.onPageSelected})
      : super(key: key);

  @override
  MapsState createState() => MapsState();
}

class MapsState extends State<Maps> {
  late GoogleMapController mapController;
  final double maxDistance = 10000; // Distance maximale en mètres
  Position? position;
  Set<Marker> markers = {};
  Location location = Location();
  BitmapDescriptor? basicBin;
  BitmapDescriptor? recyclingBin;
  BitmapDescriptor? compostBin;
  @override
  void initState() {
    super.initState();
    requestLocationPermission();
    loadbasicBin();
  }

  BitmapDescriptor getMarkerIcon(String binType) {
    if (binType == 'Type 1') {
      return recyclingBin ?? BitmapDescriptor.defaultMarker;
    } else if (binType == 'Type 2') {
      return compostBin ?? BitmapDescriptor.defaultMarker;
    } else {
      return basicBin ?? BitmapDescriptor.defaultMarker;
    }
  }

  Future<void> getMarkers() async {
    if (position == null) return;

    var collection = await widget.db.findLocationsNearby(
      position!.longitude,
      position!.latitude,
      maxDistance,
    );
    setState(() {
      markers.clear();
      for (var location in collection) {
        var coordinates = location['location']?['coordinates'];
        if (coordinates != null && coordinates.length >= 2) {
          markers.add(
            Marker(
              markerId: MarkerId(location['_id'].toString()),
              position: LatLng(coordinates[1], coordinates[0]),
              icon: getMarkerIcon(location['type'] ?? ''),
              infoWindow: InfoWindow(
                title: location['name'] ?? '',
                snippet: location['description'] ?? '',
              ),
            ),
          );
        }
      }
      print(markers.length);
    });
  }

  Future<void> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (permission == LocationPermission.denied || !isLocationServiceEnabled) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Non autorisé");
      }
      if (!isLocationServiceEnabled) {
        throw Exception("Service de localisation désactivé");
      }
    }
  }

  Future<void> loadbasicBin() async {
    try {
      print("Chargement de l'icône du marqueur");
      print(markers.length);
      final Uint8List markerBasicBin = await getBytesFromAsset(
        'assets/images/recycling-bin-3.png',
        100,
      );
      final Uint8List markerRecycleBin = await getBytesFromAsset(
        'assets/images/recycling-bin-2.png',
        100,
      );
      final Uint8List markerCompostBin = await getBytesFromAsset(
        'assets/images/recycling-bin.png',
        100,
      );
      setState(() {
        basicBin = BitmapDescriptor.fromBytes(markerBasicBin);
        recyclingBin = BitmapDescriptor.fromBytes(markerRecycleBin);
        compostBin = BitmapDescriptor.fromBytes(markerCompostBin);
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

  Future<Position> getCurrentLocation() async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationServiceEnabled) {
      throw Exception("Services de localisation désactivés");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Non autorisé");
      }
    }

    Position currentPosition = await Geolocator.getCurrentPosition();
    setState(() {
      position = currentPosition;
    });
    if (markers.isEmpty) {
      getMarkers();
    }

    return currentPosition;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: widget.selectedIndex,
        onItemSelected: widget.onPageSelected,
      ),
      body: FutureBuilder<Position>(
        future: getCurrentLocation(),
        builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
          if (snapshot.hasData) {
            final position = snapshot.data!;
            return GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(position.latitude, position.longitude),
                zoom: 12.0,
              ),
              zoomControlsEnabled: false,
              buildingsEnabled: true,
              markers: markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                  'Impossible de récupérer la position actuelle: ${snapshot.error}'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
