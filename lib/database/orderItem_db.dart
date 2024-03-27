import 'package:sqflite/sqflite.dart';
import 'package:nanopos/database/databse_service.dart';
import 'package:nanopos/models/table.dart';

class OrderItemDB {
  final tablename = 'OrderItems';

  Future<void> createTable(Database database) async {
    await database.execute("""
CREATE TABLE IF NOT EXISTS $tablename (
  "oi_id" INTEGER NOT NULL,
  "order_id_fk" INTEGER NOT NULL,
  "itemName" TEXT NOT NULL,
  "itemImage" TEXT NOT NULL,
  "quantity" INTEGER NOT NULL,
  "price" TEXT NOT NULL,
  "instruction" TEXT NOT NULL,
  "totalConvertPrice" TEXT NOT NULL,
  "created_at" INTEGER NOT NULL DEFAULT (cast(strftime('%s','now') as INTEGER)),
  "updated_at" INTEGER,
  PRIMARY KEY("oi_id"),
  FORIEGN KEY order_id_fk REFERENCES order(order_id)
)
""");
  }

  Future<int> create(
      {required int oi_id,
      required int order_id_fk,
      required String itemName,
      required String itemImage,
      required int quantity,
      required String totalConvertPrice,
      required String price,
      required int instruction}) async {
    final database = await DatabaseService().database;
    return await database.rawInsert(
      '''INSERT INTO $tablename (oi_id,order_id_fk,itemName,quantity,itemImage,price,instruction,totalConvertPrice,created_at) VALUES (?,?,?,?,?,?)''',
      [
        oi_id,
        order_id_fk,
        itemName,
        quantity,
        itemImage,
        price,
        instruction,
        totalConvertPrice,
        DateTime.now().millisecondsSinceEpoch
      ],
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
SELECT * FROM $tablename WHERE oi_id = ?
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

  Future<void> delete(int id) async {
    final database = await DatabaseService().database;
    await database
        .rawDelete('''DELETE FROM $tablename WHERE oi_id = ?''', [id]);
  }

  Future<void> truncateTable() async {
    final database = await DatabaseService().database;
    await database.rawDelete('DELETE FROM $tablename WHERE 1=1');
  }
}
