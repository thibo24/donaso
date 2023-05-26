import 'package:flutter_application_2/category.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'constant.dart';

class Database {
  late final Db db;

  Database._(this.db);

  Database(Function() connect);

  static Future<Database> connect() async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    return Database._(db);
  }

  Future<List<Map<String, dynamic>>> getAllFromCollection(
      String collectionName) async {
    var collection = db.collection(collectionName);
    return collection.find().toList();
  }

  Future<void> writeCollection(String collectionName, String params) async {
    var collection = db.collection(collectionName);
    if (collection == null) {
      await db.createCollection(collectionName);
    }
    //Pas besoin d'id, celui-ci est généré automatiquement
    await collection.insertOne({"name": params, "id": 10});
    print(await collection.find().toList());
  }

  Future<void> addUser(String username, String password, String email,
      String firstName, String lastName, String phone) async {
    final collection = db.collection('user');
    final newUser = {
      '_id': ObjectId(),
      'username': username,
      'password': password,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phone,
      'points': 0,
    };

    await collection.insert(newUser);
  }

  Future<Categorie> createCategory(String name) async {
    final collection = db.collection('category');
    final categoryDocument = await collection.findOne(where.eq('name', name));
    if (categoryDocument != null) {
      final category = Categorie(
        name: categoryDocument['name'],
        image: categoryDocument['imageLink'],
        description: categoryDocument['description']
      );
      return category;
    }
    throw Exception('Category not found');
  }

  Future<List<Categorie>> createCategories() async {
    final collection = db.collection('category');
    final categories = <Categorie>[];
    final categoryDocuments = await collection.find().toList();
    for (var categoryDocument in categoryDocuments) {
      final category = Categorie(
        name: categoryDocument['name'],
        image: categoryDocument['imageLink'],
        description: categoryDocument['description'],
      );
      categories.add(category);
    }
    return categories;
  }



  Future<List<Map<String, dynamic>>> selectSQL(
      String collectionName, String key, String value) {
    var collection = db.collection(collectionName);
    return collection.find(where.eq(key, value)).toList();
  }

  Future<bool> checkUser(String username) async {
    var collection = db.collection('user');
    var user = await collection.findOne(where.eq('username', username));
    if (user == null) {
      return true;
    }
    return false;
  }


}