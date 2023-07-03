import 'dart:io';

import 'package:bcrypt/bcrypt.dart';
import 'package:flutter_application_2/allCategory/category.dart';
import 'package:flutter_application_2/profile/user.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'constant.dart';

class Database {
  late final Db db;

  Database._(this.db);

  Database(Function() connect);

  /// Connects to the database
  static Future<Database> connect() async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    return Database._(db);
  }

  /// Return everything in the collection
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
    await collection.insertOne({"name": params, "id": 10});
    print(await collection.find().toList());
  }

  /// Add an user to the database
  Future<void> addUser(String username, String password, String email,
      String phone, String? image) async {
    final collection = db.collection(userTable);
    String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
    final newUser = {
      '_id': ObjectId(),
      'username': username,
      'password': hashedPassword,
      'email': email,
      'phone': phone,
      'image': 'default.png',
      'points': 0,
    };

    await collection.insert(newUser);
  }

  /// Add a category to the database
  /// @param name of the category
  Future<Categorie> createCategory(String name) async {
    final collection = db.collection('wastes');
    final categoryDocument = await collection.findOne(where.eq('name', name));
    if (categoryDocument != null) {
      final category = Categorie(
          name: categoryDocument['name'],
          image: categoryDocument['image'],
          description: categoryDocument['description']);
      return category;
    }
    throw Exception('Category not found');
  }

  Future<List<Categorie>> createCategories() async {
    final collection = db.collection("wastes");
    final categories = <Categorie>[];
    final categoryDocuments = await collection.find().toList();
    for (var categoryDocument in categoryDocuments) {
      final category = Categorie(
        name: categoryDocument['name'],
        image: categoryDocument['image'],
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

  Future<bool> checkUserNameIsAvailable(String username) async {
    var collection = db.collection(userTable);
    var user = await collection.findOne(where.eq('username', username));
    if (user == null) {
      return true;
    }
    return false;
  }

  Future<bool> checkUserEmailIsAvailable(String email) async {
    var collection = db.collection(emailTable);
    var user = await collection.findOne(where.eq('email', email));
    if (user == null) {
      return true;
    }
    return false;
  }

  Future<bool> checkUser(String user, String password) async {
    List<Map<String, dynamic>> map =
        await selectSQL(userTable, "username", user);
    bool isUserValid = false;

    if (map.isNotEmpty) {
      map.forEach((element) {
        if (BCrypt.checkpw(password, element["password"])) {
          isUserValid = true;
        }
      });
    }

    return isUserValid;
  }

  Future<User> createUser(String username) async {
    var collection = db.collection(userTable);
    var user = await collection.findOne(where.eq('username', username));
    if (user == null) {
      throw Exception('User not found');
    }
    return User(
        username: user['username'],
        email: user['email'].toString(),
        nbPoints: user['points'],
        image: user['image']);
  }

  Future<List<Map<String, dynamic>>> findLocationsNearby(
      double latitude, double longitude, double? maxDistance) async {
    var collection = db.collection(locName);
    var query = {
      'coordinates': {
        '\$near': {
          '\$geometry': {
            'type': 'Point',
            'coordinates': [longitude, latitude]
          },
          '\$maxDistance': maxDistance
        }
      }
    };

    var result = await collection.find(query).toList();
    return result.map((doc) => doc as Map<String, dynamic>).toList();
  }

  Future<List<Map<String, dynamic>>> findLocationsNearbyByType(double longitude,
      double latitude, double maxDistance, String type) async {
    var map = await findLocationsNearby(latitude, longitude, maxDistance);
    var result = map.where((element) => element['type'] == type).toList();
    return result;
  }

  Future<void> insertLocation(double longitude, double latitude, String name,
      String description, String type) async {
    final collection = db.collection(locName);

    final document = {
      'coordinates': {
        'type': 'Point',
        'coordinates': [longitude, latitude]
      },
      'type': type,
      'name': name,
      'description': description,
    };

    await collection.insert(document);
  }

  Future<void> locations() async {
    var collection = db.collection(locName);
    await collection.createIndex(keys: {'coordinates': '2dsphere'});
  }

  Future<void> addUserGoogle(String email, String username) async {
    final collection = db.collection(userTable);
    final newUser = {
      '_id': ObjectId(),
      'username': username,
      'password': '',
      'email': email,
      'phone': '',
      'image': "default.png",
      'points': 0,
    };

    await collection.insert(newUser);
  }

  Future<bool> checkUserGoogle(String email) async {
    var collection = db.collection(userTable);
    var user = await collection.findOne(where.eq('email', email));
    print(user.toString());
    if (user != null) {
      return true;
    }
    return false;
  }

  /// @param username
  /// Delete user by username if exists
  Future<void> deleteAccount(String username) async {
    var collection = db.collection(userTable);
    var user = await collection.findOne(where.eq('username', username));
    if (user != null) {
      await collection.remove(where.eq('username', username));
      print('Account deleted successfully.');
    } else {
      print('Account not found.');
    }
  }

  /// @param user
  /// Update account information according to a user object
  Future<void> updateAccount(User user) async {
    var collection = db.collection(userTable);
    var dbUser = await collection.findOne(where.eq('username', user.username));
    if (dbUser != null) {
      var updateBuilder = modify;
      if (user.username != null) {
        updateBuilder.set('username', user.username);
      }
      if (user.email != null) {
        updateBuilder.set('email', user.email);
      }
      await collection.update(
          where.eq('username', user.username), updateBuilder);
    }
  }

  /// @param user
  /// @param image
  /// Update account image
  Future<void> updateImage(User user, String image) async {
    var collection = db.collection(userTable);
    var dbUser = await collection.findOne(where.eq('username', user.username));
    if (dbUser != null) {
      var updateBuilder = modify;
      updateBuilder.set('image', image);
      await collection.update(
          where.eq('username', user.username), updateBuilder);
    }
  }

  /// @param user
  /// @param nbPoints
  /// Update user points
  Future<void> addPoints(User user, int nbPoints) async {
    var collection = db.collection(userTable);
    var updateBuilder = modify;
    updateBuilder.set('points', nbPoints + user.nbPoints);
    await collection.update(where.eq('username', user.username), updateBuilder);
  }
}
