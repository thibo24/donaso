import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';


import '../allCategory/category.dart';
import '../database.dart';
import '../navigationBar.dart';

class TfliteModel extends StatefulWidget {
  final File image;
  final Database db;
  final int selectedItem;
  final Function(int) onItemSelected;

  TfliteModel({Key? key, required this.image, required this.db, required this.selectedItem, required this.onItemSelected}) : super(key: key);

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
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: widget.selectedItem,
        onItemSelected: widget.onItemSelected,
      ),
      backgroundColor: Colors.white,
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
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
                          SizedBox(width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.25,),
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
                    SizedBox(height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.09),
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: Text(
                        "Description: ${categorie.description}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Center(child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      height: 4,
                      color: Colors.black,
                    )),
                    const SizedBox(height: 30),
                    Container(
                      foregroundDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white54,
                          width: 2,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      height: 100,
                      margin: const EdgeInsets.all(10),
                      child: Card(
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                child: const Text(
                                  "fhsjfsjlk jfsklfjkldsjkdkjf jkfsfjklsdjkljkfs fjjfkdsklffjk",
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                            Container(
                              width: 100,
                              height: 100,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQOvzEyO5_F9H51Htqm3Fc27z9lVxW1ZkogdQ&usqp=CAU",
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                  ],
                ));
          }
        },
      ),
    );
  }
}
