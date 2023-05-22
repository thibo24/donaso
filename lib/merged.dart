import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of available cameras.
  final cameras = await availableCameras();

  // Initialize the first camera from the list.
  final firstCamera = cameras.first;

  runApp(MyApp(firstCamera: firstCamera));
}

class MyApp extends StatelessWidget {
  final CameraDescription firstCamera;

  const MyApp({required this.firstCamera});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camera Demo',
      theme: ThemeData.dark(),
      home: MainPage(camera: firstCamera),
    );
  }
}

class MainPage extends StatefulWidget {
  final CameraDescription camera;

  const MainPage({required this.camera});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late CameraController _cameraController;
  File? _image;

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  Future<void> _takePhoto() async {
    if (!_cameraController.value.isInitialized) {
      return;
    }

    final XFile imageFile = await _cameraController.takePicture();

    setState(() {
      _image = File(imageFile.path);
    });

    _cameraController.setFlashMode(FlashMode.off);
  }

  Future<void> _choosePhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _image?.delete(); // Delete the selected/taken photo when the app is closed.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_cameraController.value.isInitialized) {
      return Container();
    }

    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;

    return Scaffold(
      appBar: AppBar(title: const Text('Camera Demo')),
      body: Container(
        width: size.width,
        height: size.height,
        child: Center(
          child: Transform.scale(
            scale: _cameraController.value.aspectRatio / deviceRatio,
            child: AspectRatio(
              aspectRatio: _cameraController.value.aspectRatio,
              child: CameraPreview(_cameraController),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePhoto,
        child: const Icon(Icons.camera),
      ),
    );
  }
}
