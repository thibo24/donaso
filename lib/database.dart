
import 'package:mongo_dart/mongo_dart.dart';
import 'constant.dart';

class Database {
  late final Db db;

  Database._(this.db);

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
}
