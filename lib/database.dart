import 'package:donaso/constant.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:bcrypt/bcrypt.dart';

class Database {
  late final Db db;

  Database._(this.db);

  Database(Function() connect);

  static Future<Database> connect() async {
    var db = await Db.create(mangoUrl);
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
      String firstName, String lastName, String phone, String? image) async {
    final collection = db.collection(userTable);
    String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
    final newUser = {
      '_id': ObjectId(),
      'username': username,
      'password': hashedPassword,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phone,
      'image': '',
      'points': 0,
    };

    await collection.insert(newUser);
  }

  Future<List<Map<String, dynamic>>> selectSQL(
      String collectionName, String key, String value) {
    var collection = db.collection(collectionName);
    return collection.find(where.eq(key, value)).toList();
  }

  Future<bool> checkUserIsAvailable(String username) async {
    var collection = db.collection(userTable);
    var user = await collection.findOne(where.eq('username', username));
    if (user == null) {
      return true;
    }
    return false;
  }

  Future<bool> checkUser(String user, String password) async {
    List<Map<String, dynamic>> map = await selectSQL("user", "username", user);
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

  Future<List<Map<String, dynamic>>> findLocationsNearby(
      double longitude, double latitude, double? maxDistance) async {
    var collection = db.collection(locName);
    maxDistance ??= 1000;
    var query = {
      'location': {
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

  Future<List<Map<String, dynamic>>> findLocationsNearbyByType(
      double longitude, double latitude, String type) async {
    var map = await findLocationsNearby(longitude, latitude, 10000);
    var result = map.where((element) => element['type'] == type).toList();
    return result;
  }

  Future<void> insertLocation(double longitude, double latitude, String name,
      String description, String type) async {
    final collection = db.collection(locName);

    final document = {
      'location': {
        'type': 'Point',
        'coordinates': [longitude, latitude]
      },
      'type': type,
      'name': name,
      'description': description,
    };

    await collection.insert(document);
  }

  Future<void> location() async {
    var collection = db.collection(locName);
    await collection.createIndex(keys: {'coordinates': '2dsphere'});
  }

  Future<void> addUserGoogle(
      String email, String firstName, String lastName, String username) async {
    final collection = db.collection(userTable);
    final newUser = {
      '_id': ObjectId(),
      'username': email,
      'password': '',
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': '',
      'image': null,
      'points': 0,
    };

    await collection.insert(newUser);
  }

  bool checkUserGoogle(String email) {
    var collection = db.collection(userTable);
    var user = collection.findOne(where.eq('username', email));
    if (user == null) {
      return true;
    }
    return false;
  }
}
