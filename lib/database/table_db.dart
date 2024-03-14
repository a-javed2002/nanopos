import 'package:sqflite/sqflite.dart';
import 'package:nanopos/database/databse_service.dart';
import 'package:nanopos/models/table.dart';

class TableDB {
  final tablename = 'table';

  Future<void> createTable(Database database) async {
    await database.execute("""
CREATE TABLE IF NOT EXISTS $tablename (
  "table_id" INTEGER NOT NULL,
  "name" TEXT NOT NULL,
  "size" INTEGER NOT NULL,
  "order" INTEGER NOT NULL,
  "active" INTEGER NOT NULL,
  "created_at" INTEGER NOT NULL DEFAULT (cast(strftime('%s','now') as INTEGER)),
  "updated_at" INTEGER,
  PRIMARY KEY("table_id")
)
""");
  }

  Future<int> create({required int table_id,required String name,required int size,required int order,required int active}) async {
    final database = await DatabaseService().database;
    return await database.rawInsert(
      '''INSERT INTO $tablename (table_id,name,size,order,active,created_at) VALUES (?,?,?,?,?,?)''',
      [table_id,name,size,order,active, DateTime.now().millisecondsSinceEpoch],
    );
  }

  Future<List<Table>> fetchAll() async {
    final database = await DatabaseService().database;
    final todos = await database.rawQuery(
        '''SELECT * FROM $tablename ORDER BY COALESCE(updated_at,created_at)''');
    return todos.map((todo) => Table.fromSqfliteDatabase(todo)).toList();
  }

  Future<Table> fetchById(int id) async {
    final database = await DatabaseService().database;
    final todo = await database.rawQuery('''
SELECT * FROM $tablename WHERE table_id = ?
''', [id]);
    return Table.fromSqfliteDatabase(todo.first);
  }

  // Future<int> update({required int id,String? title}) async{
  //   final database = await DatabaseService().database;

  //   return await database.update(tablename, {
  //     if(title!=null) 'title':title,
  //     'updated_at':DateTime.now().microsecondsSinceEpoch,
  //   },where: 'id = ?',conflictAlgorithm: ConflictAlgorithm.rollback,whereArgs: [id]);
  // }

  Future<void> delete(int id)async{
    final database = await DatabaseService().database;
    await database.rawDelete('''DELETE FROM $tablename WHERE table_id = ?''',[id]);
  }

  Future<void> truncateTable() async {
    final database = await DatabaseService().database;
    await database.rawDelete('DELETE FROM $tablename WHERE 1=1');
  }
}
