import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/database.dart';
import 'package:flutter_application_2/navigationBar.dart';
import 'package:image_picker/image_picker.dart';

import 'AI.dart';

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
      home: AppLoader(),
    );
  }
}

class AppLoader extends StatelessWidget {
  final Future<List<CameraDescription>> camerasFuture = availableCameras();
  final Future<Database> databaseFuture = Database.connect();

  AppLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([camerasFuture, databaseFuture]),
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
          return Home(
            camera: firstCamera,
            database: database,
          );
        }
      },
    );
  }
}


class Home extends StatelessWidget {
  final CameraDescription camera;
  final Database database;
  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  Home({required this.camera, required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Camera App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CameraScreen(camera: camera, database: database),
      navigatorObservers: [routeObserver],
    );
  }
}

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;
  final Database database;

  CameraScreen({required this.camera, required this.database});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;
  late Future<void> _initializeCameraControllerFuture;
  File? _imageFile;
  bool _isButtonVisible = true;
  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameraController = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeCameraControllerFuture = _cameraController.initialize();
  }

  void _goBack(bool isFlashOn) {
    setState(() {
      _isFlashOn = isFlashOn;
      _cameraController.setFlashMode(_isFlashOn ? FlashMode.torch : FlashMode.off);
    });
  }

  Future<void> _takePhoto() async {
    try {
      await _initializeCameraControllerFuture;

      final image = await _cameraController.takePicture();
      final imageSize = await File(image.path).length();

      setState(() {
        _imageFile = File(image.path);
      });
    } catch (e) {
      print(e);
    }
    _cameraController.setFlashMode(FlashMode.off);
  }

  Future<void> _openGallery() async {
    _cameraController.setFlashMode(FlashMode.off);
    final imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        _imageFile = File(imageFile.path);
      });
    }
  }

  void _sendToAI() async {
    if (_imageFile != null) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TfliteModel(image: _imageFile!, db: widget.database),
        ),
      );

      // Éteindre le flash lorsque vous revenez à l'écran de la caméra
      _isFlashOn = false;
      _cameraController.setFlashMode(FlashMode.off);
    }
  }

  void _clearImage() {
    setState(() {
      _imageFile = null;
    });
    _goBack(_isFlashOn);
  }


  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DoNaSo'),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
      body: Stack(
        children: [
          Positioned.fill(
            child: _imageFile != null
                ? Image.file(_imageFile!, fit: BoxFit.cover)
                : FutureBuilder<void>(
              future: _initializeCameraControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the Future is complete, display the preview.
                  return CameraPreview(_cameraController);
                } else {
                  // Otherwise, display a loading indicator.
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: Visibility(
              visible: _isButtonVisible,
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _isFlashOn = !_isFlashOn;
                    _cameraController.setFlashMode(_isFlashOn ? FlashMode.torch : FlashMode.off);
                  });
                },
                child: _isFlashOn ? Icon(Icons.flash_on) : Icon(Icons.flash_off),
              ),
            ),
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8, // Largeur du cadre (80% de l'écran)
              height: MediaQuery.of(context).size.width * 0.8, // Hauteur du cadre (80% de l'écran)
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2), // Bordure blanche
                borderRadius: BorderRadius.circular(20), // Bords arrondis
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20), // Bords arrondis pour l'image
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: _imageFile != null
                      ? Image.file(_imageFile!, fit: BoxFit.cover)
                      : Container(),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Visibility(
              visible: _imageFile == null,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                  children: [
                    Transform.scale(
                      scale: 1.3, // Définir la valeur d'échelle pour agrandir le bouton (1.0 représente la taille normale)
                      child: FloatingActionButton(
                        onPressed: _takePhoto,
                        child: Icon(Icons.camera),
                      ),
                    ), SizedBox(height: 30),// Marge entre les deux boutons
                  Container(
                    width: 32, // Largeur de la ligne blanche
                    height: 2, // Hauteur de la ligne blanche
                    color: Colors.white, // Couleur de la ligne blanche
                  )]),
                  SizedBox(width: MediaQuery.of(context).size.width / 4),
                  FloatingActionButton(
                    onPressed: _openGallery,
                    child: Icon(Icons.photo_library),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: Visibility(
              visible: _imageFile != null,
              child: FloatingActionButton(
                onPressed: _clearImage,
                child: Icon(Icons.arrow_back),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Visibility(
              visible: _imageFile != null,
              child: FloatingActionButton(
                onPressed: _sendToAI,
                child: Icon(Icons.chevron_right),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
