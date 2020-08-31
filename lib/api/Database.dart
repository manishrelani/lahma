import 'dart:async';
import 'dart:io';
import 'package:lahma/model/local_product.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteDbProvider {
  SQLiteDbProvider._();

  static final SQLiteDbProvider db = SQLiteDbProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null)
      return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "ProductDB.db");
    return await openDatabase(
        path,
        version: 1,
        onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute(
              "CREATE TABLE Product ("
                  "id INTEGER PRIMARY KEY,"
                  "name TEXT,"
                  "qty INTEGER,"
                  "price DOUBLE,"
                  "image TEXT" ")"
          );
        });
  }


  Future<List<LocalProductModel>> getAllProducts() async {
    final db = await database;
    List<Map>
    results = await db.query(
        "Product", columns: LocalProductModel.columns, orderBy: "id ASC");

    List<LocalProductModel> products = new List();
    results.forEach((result) {
      LocalProductModel product = LocalProductModel.fromMap(result);
      products.add(product);
    });
    return products;
  }

  Future<LocalProductModel> getProductById(int id) async {
    final db = await database;
    var result = await db.query("Product", where: "id =?", whereArgs: [id]);
    return result.isNotEmpty ? LocalProductModel.fromMap(result.first) : null;
  }


  insert(LocalProductModel product) async {
    final db = await database;
    var maxIdResult = await db.rawQuery(
        "SELECT MAX(id)+1 as last_inserted_id FROM Product");

    var id = maxIdResult.first["last_inserted_id"];
    var result = await db.rawInsert(
        "INSERT Into Product (id, name, qty, price, image)"
            " VALUES (?, ?, ?, ?, ?)",
        [product.id, product.name, product.qty, product.price, product.image]
    );
    return result;
  }

  update(LocalProductModel product) async {
    final db = await database;
    var result = await db.update("Product", product.toMap(),
        where: "id = ?", whereArgs: [product.id]);
    return result;
  }

  delete(int id) async {
    final db = await database;
    db.delete("Product", where: "id = ?", whereArgs: [id]);
  }

  Future<int> getCount() async {
    //database connection
    Database db = await this.database;
    var result = await db.rawQuery('SELECT COUNT (*) from Product');
        int count = Sqflite.firstIntValue(result);
    return count;
  }

   deleteAll() async {
    //database connection
    Database db = await this.database;
    var result = await db.execute('DELETE FROM Product');


  }

}