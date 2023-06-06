import 'package:flutter/material.dart';
import 'package:flutter_application_2/allCategory/categoryDetail.dart';
import 'category.dart';
import '../database.dart';
import '../navigationBar.dart';

class AllScreen extends StatefulWidget {
  late Database database;
  final int selectedIndex;
  final Function(int) onPageSelected; // Callback function
  late Future<List<Categorie>> _categorieFuture;

  AllScreen({
    required this.database,
    required this.selectedIndex,
    required this.onPageSelected,
  }) {
    _categorieFuture = _createCategories();
  }

  Future<List<Categorie>> _createCategories() async {
    try {
      return await database.createCategories();
    } catch (error) {
      print('Failed to load categories: $error');
      return Future.error('Failed to load categories');
    }
  }

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<AllScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: widget.selectedIndex,
        onItemSelected: widget.onPageSelected,
      ),
      body: FutureBuilder<List<Categorie>>(
        future: widget._categorieFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: ElevatedButton(
                onPressed: () async {
                  setState(() {
                    widget._categorieFuture = widget._createCategories();
                  });
                },
                child: const Text('Failed to load categories. Retry'),
              ),
            );
          } else {
            final categories = snapshot.data!;
            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (BuildContext context, int index) {
                final category = categories[index];
                return InkWell(
                  onTap: () {
                    print("Catégorie cliquée : ${category.name}");
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) {
                        return categoryDetail(
                          categorie: category,
                          db: widget.database,
                          selectedIndex: widget.selectedIndex,
                          onItemSelected: widget.onPageSelected,
                        );
                      },
                    ));
                  },
                  child: SizedBox(
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
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Image.asset(
                                'assets/images/categoryPicture/'+category.image,
                                width: 100,
                                height: 100,
                              ),
                            ],
                          ),
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
