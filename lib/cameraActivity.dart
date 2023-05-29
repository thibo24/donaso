import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/database.dart';
import 'package:flutter_application_2/navigationBar.dart';
import 'package:flutter_application_2/borderPainter.dart';
import 'package:image_picker/image_picker.dart';

import 'AI.dart';

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;
  final Database database;
  final int selectedIndex;
  final Function(int) onPageSelected; // Callback function

  CameraScreen({required this.camera, required this.database, required this.selectedIndex, required this.onPageSelected});

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
      bottomNavigationBar: CustomBottomNavigationBar(selectedIndex: widget.selectedIndex, onItemSelected: widget.onPageSelected),
      body:
      Stack(
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
            top: MediaQuery.of(context).size.height * 0.1, // Ajustez cette valeur selon vos besoins
            left: 16,
            child: Visibility(
              visible: _isButtonVisible,
              child: FloatingActionButton(
                backgroundColor: Colors.black,
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
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.width * 0.8,
              child: CustomPaint(
                painter: BorderPainter(cornerSide: 30),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: _imageFile != null
                        ? Image.file(_imageFile!, fit: BoxFit.cover)
                        : Container(),
                  ),
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
                        scale: 1.3,
                        child: FloatingActionButton(
                          onPressed: _takePhoto,
                          backgroundColor: Colors.white,
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ), SizedBox(height: 30),
                      Container(
                        width: 90,
                        height: 5,
                        color: Colors.white,
                      )
                    ],
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width / 5),
                  FloatingActionButton(
                    onPressed: _openGallery,
                    backgroundColor: Colors.black,
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
