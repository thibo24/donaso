import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/allCategory/allActivity.dart';
import 'package:flutter_application_2/maps.dart';
import 'package:flutter_application_2/profile/profileActivity.dart';
import 'package:flutter_application_2/profile/user.dart';
import 'camera/cameraActivity.dart';
import 'database.dart';

class AppLoader extends StatefulWidget {
  final Future<List<CameraDescription>> camerasFuture = availableCameras();
  final Database db;
  final User user;

  AppLoader({Key? key, required this.db, required this.user}) : super(key: key);

  @override
  _AppLoaderState createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader> {
  int selectedIndex = 0;

  void onPageSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([widget.camerasFuture]),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error occurred: ${snapshot.error}'),
            ),
          );
        } else {
          final cameras = snapshot.data![0] as List<CameraDescription>;
          final database = widget.db; // Utilisez la variable widget.db au lieu de snapshot.data![1]
          final firstCamera = cameras.first;

          if (selectedIndex == 0) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Camera App',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: CameraScreen(
                user: widget.user,
                camera: cameras[0],
                database: database,
                selectedIndex: selectedIndex,
                onPageSelected: onPageSelected, // Pass the callback function
              ),
            );
          } else if(selectedIndex == 1){
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Camera App',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: Maps(
                db: widget.db,
                selectedIndex: selectedIndex,
                onPageSelected: onPageSelected, user: widget.user, // Pass the callback function
              ),
            );
          }
          else if (selectedIndex == 2) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Camera App',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: AllScreen(
                database: database,
                selectedIndex: selectedIndex,
                onPageSelected: onPageSelected, // Pass the callback function
              ),
            );
          } else {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Camera App',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: profileActivity(
                database: database,
                selectedIndex: selectedIndex,
                onPageSelected: onPageSelected,
                user: widget.user, // Utilisez la variable widget.user au lieu de créer un nouvel utilisateur ici
              ),
            );
          }
        }
      },
    );
  }
}
