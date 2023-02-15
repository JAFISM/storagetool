import 'package:sqflite/sqflite.dart' as sql;///as keyword => type cast

class SqlHelper{
 static  Future<sql.Database>db() async{
   return sql.openDatabase("mydatabase.db",
     version: 1,
     onCreate: (sql.Database database,int version)async{
     await createTable(database);
     }
   );
 }

  static createTable(sql.Database database) async {
   await database.execute(
     """
     'CREATE TABLE items(
      id INTEGER PRIMARY AUTOINCREMENT NOT NULL,
      title VARCHAR, 
      description VARCHAR,
     )
      """);
  }

  static Future<List<Map<String,dynamic>>>getItems() async{
   final db= await SqlHelper.db();
   return db.query("items");
  }

 static Future<int> create_item(String title, String description) async{
   final db=await SqlHelper.db();
   final data={"title":title,"description":description};
   final id=await db.insert("items", data);
   return id;
 }

}