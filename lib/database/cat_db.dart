import 'package:nanopos/models/cat.dart';
import 'package:sqflite/sqflite.dart';
import 'package:nanopos/database/databse_service.dart';

class CatDB {
  final tablename = 'cats';

  Future<void> createTable(Database database) async {
    await database.execute("""
CREATE TABLE IF NOT EXISTS $tablename (
  "cat_id" INTEGER NOT NULL,
  "cat_name" TEXT NOT NULL,
  "created_at" INTEGER NOT NULL DEFAULT (cast(strftime('%s','now') as INTEGER)),
  "updated_at" INTEGER,
  PRIMARY KEY("cat_id")
)
""");
  }

  Future<int> create({required int cat_id,required String cat_name}) async {
    final database = await DatabaseService().database;
    return await database.rawInsert(
      '''INSERT INTO $tablename (cat_id,cat_name,created_at) VALUES (?,?,?)''',
      [cat_id,cat_name, DateTime.now().millisecondsSinceEpoch],
    );
  }

  Future<List<Cat>> fetchAll() async {
    final database = await DatabaseService().database;
    final todos = await database.rawQuery(
        '''SELECT * FROM $tablename ORDER BY COALESCE(updated_at,created_at)''');
    return todos.map((todo) => Cat.fromSqfliteDatabase(todo)).toList();
  }

  Future<Cat> fetchById(int id) async {
    final database = await DatabaseService().database;
    final todo = await database.rawQuery('''
SELECT * FROM $tablename WHERE cat_id = ?
''', [id]);
    return Cat.fromSqfliteDatabase(todo.first);
  }

  Future<int> update({required int id,String? cat_name}) async{
    final database = await DatabaseService().database;

    return await database.update(tablename, {
      if(cat_name!=null) 'cat_name':cat_name,
      'updated_at':DateTime.now().microsecondsSinceEpoch,
    },where: 'cat_id = ?',conflictAlgorithm: ConflictAlgorithm.rollback,whereArgs: [id]);
  }

  Future<void> delete(int id)async{
    final database = await DatabaseService().database;
    await database.rawDelete('''DELETE FROM $tablename WHERE cat_id = ?''',[id]);
  }

  Future<void> truncateTable() async {
    final database = await DatabaseService().database;
    await database.rawDelete('DELETE FROM $tablename');
  }
}
