import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

class TfliteModel extends StatefulWidget {
  final File image;

  TfliteModel({Key? key, required this.image}) : super(key: key);

  @override
  _TfliteModelState createState() => _TfliteModelState();
}

class _TfliteModelState extends State<TfliteModel> {
  late List _results;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadModel();
    imageClassification();
  }

  Future loadModel() async {
    Tflite.close();
    String? res = await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/labels.txt",
    );
    print("Models loading status: $res");
  }

  Future imageClassification() async {
    final List? recognitions = await Tflite.runModelOnImage(
      path: widget.image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _results = recognitions!;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Classification"),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  //child: Image.file(widget.image),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: _results.map((result) {
                      return Card(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: Text(
                            "${result['label']} - ${result['confidence'].toStringAsFixed(2)}",
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                )
              ],
            ),
    );
  }
}
