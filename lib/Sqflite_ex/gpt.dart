import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
void main(){
  runApp(MaterialApp(home: MyHomePage(title: ""),));
}
class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Database _database;

  final _nameController = TextEditingController();
  final _ageController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  void _initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'my_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE people(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)',
        );
      },
      version: 1,
    );
  }

  void _insertData() async {
    final name = _nameController.text;
    final age = int.parse(_ageController.text);
    await _database.insert(
      'people',
      {'name': name, 'age': age},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> _getData() async {
    final List<Map<String, dynamic>> data = await _database.query('people');
    return data;
  }
  void _deleteData(int id) async {
    print('Deleting item with ID: $id');
    await _database.delete('people', where: 'id = ?', whereArgs: [id]);
  }
  // void _editData(int id, String name, int age) async {
  //   await _database.update(
  //     'people',
  //     {'name': name, 'age': age},
  //     where: 'id = ?',
  //     whereArgs: [id],
  //   );
  //   setState(() {
  //     _editingItemId = null;
  //     _nameController.text = '';
  //     _ageController.text = '';
  //   });
  // }
  //
  // void _setEditingItem(int id, String name, int age) {
  //   setState(() {
  //     _editingItemId = id;
  //     _nameController.text = name;
  //     _ageController.text = age.toString();
  //   });
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(hintText: 'Name'),
            ),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(hintText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: _insertData,
              child: Text('Save'),
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _getData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: data?.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(data![index]['name']),
                          subtitle: Text('Age: ${data[index]['age']}'),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              print('Deleting item with ID: ${data[index]['id']}');
                              _deleteData(data[index]['id']);
                            },
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {});
              },
              child: Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }
}
