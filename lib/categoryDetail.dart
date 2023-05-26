import 'package:flutter/material.dart';
import 'category.dart';
import 'database.dart';

class categoryDetail extends StatefulWidget {
  final Categorie categorie;
  final Database db;

  categoryDetail({Key? key, required this.categorie, required this.db}) : super(key: key);

  @override
  _categoryDetailState createState() => _categoryDetailState();
}

class _categoryDetailState extends State<categoryDetail> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Image Classification"),
        ),
        body: Container(
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
                    .height * 0.12),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    "Confidence: ${widget.categorie.description}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            )));
  }
}
