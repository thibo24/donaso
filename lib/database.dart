import 'package:donaso/constant.dart';
import 'package:mongo_dart/mongo_dart.dart';

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

  Future<void> insertLocation(double latitude, double longitude) async {
    var collection = db.collection('location');
    var location = {
      'type': 'Point',
      'coordinates': [longitude, latitude]
    };

    await collection.insert(location);
  }

  Future<List<Map<String, dynamic>>> findLocationsNearby(
      double latitude, double longitude, double? maxDistance) async {
    var collection = db.collection('location');
    maxDistance ??= 1000;
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
}
