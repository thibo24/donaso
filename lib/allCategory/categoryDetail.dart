import 'package:flutter/material.dart';
import 'category.dart';
import '../database.dart';
import '../navigationBar.dart';

class categoryDetail extends StatefulWidget {
  final Categorie categorie;
  final Database db;
  final int selectedIndex;
  final Function(int) onItemSelected;

  categoryDetail({Key? key, required this.categorie, required this.db, required this.selectedIndex, required this.onItemSelected}) : super(key: key);

  @override
  _categoryDetailState createState() => _categoryDetailState();
}

class _categoryDetailState extends State<categoryDetail> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CustomBottomNavigationBar(
          selectedIndex: widget.selectedIndex,
          onItemSelected: widget.onItemSelected,
        ),
        backgroundColor: Colors.white,
        body: Container(
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
                                  widget.categorie.image),
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
                            widget.categorie.name,
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
                    "Description: ${widget.categorie.description}",
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
            )));
  }
}
