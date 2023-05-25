import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/category.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

import 'database.dart';

class TfliteModel extends StatefulWidget {
  final File image;
  final Database db;

  TfliteModel({Key? key, required this.image, required this.db}) : super(key: key);

  @override
  _TfliteModelState createState() => _TfliteModelState();
}

class _TfliteModelState extends State<TfliteModel> {
  late List<dynamic> _results;
  late String _imagePath;
  late String _title;
  late Future<Categorie> _categorieFuture; // Utiliser un Future pour l'initialisation de la catégorie
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadModel();
    _categorieFuture = initializeCategorie(); // Appeler la fonction d'initialisation de la catégorie
  }

  Future<void> loadModel() async {
    Tflite.close();
    String? res = await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/labels.txt",
    );
    print("Models loading status: $res");
  }

  Future<Categorie> initializeCategorie() async {
    final List<dynamic>? recognitions = await Tflite.runModelOnImage(
      path: widget.image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    print("bbbbb");
    print(recognitions?[0]["label"].toString());

    if (recognitions != null) {
      return widget.db.createCategory(recognitions[0]["label"]);
    }

    throw Exception('Failed to initialize category');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Classification"),
      ),
      body: FutureBuilder<Categorie>(
        future: _categorieFuture, // Utiliser le Future pour la catégorie
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Failed to load category'),
            );
          } else {
            final categorie = snapshot.data!;
            return Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  //child: Image.file(widget.image),
                ),
                SingleChildScrollView(
                  child: Row(
                    children: [
                      SizedBox(width: MediaQuery.of(context).size.width * 0.25,),
                      Card(
                        child: Container(
                          height: 120.0,
                          width: 120.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  categorie.image),
                              fit: BoxFit.fill,
                            ),
                            shape: BoxShape.rectangle,
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Card(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: Text(
                            categorie.name,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.12),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    "Confidence: ${categorie.description}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ));
          }
        },
      ),
    );
  }
}
