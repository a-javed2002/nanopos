import 'package:sqflite/sqflite.dart';
import 'package:nanopos/database/databse_service.dart';
import 'package:nanopos/models/table.dart';

class OrderDB {
  final tablename = 'order';

  Future<void> createTable(Database database) async {
    await database.execute("""
CREATE TABLE IF NOT EXISTS $tablename (
  "order_id" INTEGER NOT NULL,
  "orderSerialNo" TEXT NOT NULL,
  "orderDatetime" TEXT NOT NULL,
  "status" INTEGER NOT NULL,
  "statusName" TEXT NOT NULL,
  "totalCurrencyPrice" TEXT NOT NULL,
  "table_id_fk" INTEGER NOT NULL,
  "created_at" INTEGER NOT NULL DEFAULT (cast(strftime('%s','now') as INTEGER)),
  "updated_at" INTEGER,
  PRIMARY KEY("order_id"),
  FORIEGN KEY table_id_fk REFERENCES table(table_id)
)
""");
  }

  Future<int> create({required int order_id,required String orderSerialNo,required String orderDatetime,required int status,required String statusName,required String totalCurrencyPrice,required int table_id_fk}) async {
    final database = await DatabaseService().database;
    return await database.rawInsert(
      '''INSERT INTO $tablename (order_id,orderSerialNo,orderDatetime,status,statusName,totalCurrencyPrice,table_id_fk,created_at) VALUES (?,?,?,?,?,?)''',
      [order_id,orderSerialNo,orderDatetime,status,statusName,totalCurrencyPrice,table_id_fk, DateTime.now().millisecondsSinceEpoch],
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
SELECT * FROM $tablename WHERE order_id = ?
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
    await database.rawDelete('''DELETE FROM $tablename WHERE order_id = ?''',[id]);
  }

  Future<void> truncateTable() async {
    final database = await DatabaseService().database;
    await database.rawDelete('DELETE FROM $tablename WHERE 1=1');
  }
}
