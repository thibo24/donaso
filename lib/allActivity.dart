import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'category.dart';
import 'database.dart';
import 'navigationBar.dart';

class AllScreen extends StatefulWidget {
  final Database database;
  final int selectedIndex;
  final Function(int) onPageSelected; // Callback function
  late Future<List<Categorie>> _categorieFuture;

  AllScreen(
      {required this.database,
      required this.selectedIndex,
      required this.onPageSelected});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<AllScreen> {
  @override
  void initState() {
    super.initState();
    widget._categorieFuture = widget.database.createCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All categories"),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
          selectedIndex: widget.selectedIndex,
          onItemSelected: widget.onPageSelected),
      body: FutureBuilder<List<Categorie>>(
        future: widget._categorieFuture, // Utiliser le Future pour la catégorie
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
            return ListView.builder(
              itemCount: categorie.length,
              itemBuilder: (BuildContext context, int index) {
                final category = categorie[index];
                return Container(
                  width: 200, // Largeur souhaitée pour la Card
                  child: Card(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              category.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Image.network(
                              category.image,
                              width: 100,
                              height: 100,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );

          }
        },
      ),
    );
  }
}
