import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/allActivity.dart';
import 'cameraActivity.dart';
import 'database.dart';

void main() async {
  runApp(StartPage());
}

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AppLoader(selectedIndex: 0,),
    );
  }
}

class AppLoader extends StatefulWidget {
  final Future<List<CameraDescription>> camerasFuture = availableCameras();
  final Future<Database> databaseFuture = Database.connect();
  final int selectedIndex;

  AppLoader({Key? key, required this.selectedIndex}) : super(key: key);

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
      future: Future.wait([widget.camerasFuture, widget.databaseFuture]),
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
          final database = snapshot.data![1] as Database;
          final firstCamera = cameras.first;

          if (selectedIndex == 0) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Camera App',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: CameraScreen(
                camera: cameras[0],
                database: database,
                selectedIndex: selectedIndex,
                onPageSelected: onPageSelected, // Pass the callback function
              ),
            );
          } else if (selectedIndex == 2) {
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
            return Container();
          }
        }
      },
    );
  }
}