import 'package:nanopos/models/item.dart';
import 'package:sqflite/sqflite.dart';
import 'package:nanopos/database/databse_service.dart';

class ItemDB {
  final tablename = 'Items';

  Future<void> createTable(Database database) async {
    await database.execute("""
CREATE TABLE IF NOT EXISTS $tablename (
  "item_id" INTEGER NOT NULL,
  "cat_id_fk" INTEGER NOT NULL,
  "item_name" TEXT NOT NULL,
  "description" TEXT NOT NULL,
  "item_image" TEXT NOT NULL,
  "item_price" TEXT NOT NULL,
  "created_at" INTEGER NOT NULL DEFAULT (cast(strftime('%s','now') as INTEGER)),
  "updated_at" INTEGER,
  PRIMARY KEY("item_id")
)
""");
  }

  Future<int> create(
      {
        required int item_id,
        required int cat_id_fk,
      required String item_name,
      required String description,
      required String cover,
      required String thumb,
      required String preview,
      required String item_price}) async {
    final database = await DatabaseService().database;
    return await database.rawInsert(
      '''INSERT INTO $tablename (item_id,cat_id_fk,item_name,description,cover,thumb,preview,item_price,created_at) VALUES (?,?,?,?,?,?,?,?,?)''',
      [
        item_id,
        cat_id_fk,
        item_name,
        description,
        cover,
        thumb,
        preview,
        item_price,
        DateTime.now().millisecondsSinceEpoch
      ],
    );
  }

  Future<List<Item>> fetchAll() async {
    final database = await DatabaseService().database;
    final todos = await database.rawQuery(
        '''SELECT * FROM $tablename ORDER BY COALESCE(updated_at,created_at)''');
    return todos.map((todo) => Item.fromSqfliteDatabase(todo)).toList();
  }

  Future<Item> fetchById(int id) async {
    final database = await DatabaseService().database;
    final todo = await database.rawQuery('''
SELECT * FROM $tablename WHERE item_id = ?
''', [id]);
    return Item.fromSqfliteDatabase(todo.first);
  }

  // Future<int> update({required int id,String? title}) async{
  //   final database = await DatabaseService().database;

  //   return await database.update(tablename, {
  //     if(title!=null) 'title':title,
  //     'updated_at':DateTime.now().microsecondsSinceEpoch,
  //   },where: 'id = ?',conflictAlgorithm: ConflictAlgorithm.rollback,whereArgs: [id]);
  // }

  Future<void> delete(int id) async {
    final database = await DatabaseService().database;
    await database
        .rawDelete('''DELETE FROM $tablename WHERE item_id = ?''', [id]);
  }

  Future<void> truncateTable() async {
    final database = await DatabaseService().database;
    await database.rawDelete('DELETE FROM $tablename WHERE 1=1');
  }
}
