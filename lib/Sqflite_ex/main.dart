import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:storagetool/Sqflite_ex/Sqloperation.dart';

void main(){
  runApp(MaterialApp(
    home: Screen1(),
    debugShowCheckedModeBanner: false,
  ));
}

class Screen1 extends StatefulWidget {
  const Screen1({Key? key}) : super(key: key);

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  bool isLoading =true;
  List<Map<String,dynamic>>datas=[];

  void refreshdata()async{
    final data=await SqlHelper.getItems();
    setState(() {
      datas=data;

    });
  }
@override
  void initState() {
   reassemble();
    super.initState();
  }
  final title_controller=TextEditingController();
  final  description_controller=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sqflite Demo"),
      ),
      body: isLoading?Center(child: CircularProgressIndicator()):ListView.builder(itemBuilder: (context,int)
          {
            return ListView.builder(
              itemCount: datas.length,
              itemBuilder: (context,index){
              return Card(
                child: ListTile(
                  title: Text(datas[int]["title"]),
                  subtitle: Text(datas[int]["description"]),
                ),
              );
            });
          }
      ),
      floatingActionButton: FloatingActionButton(
      onPressed: ()=>showform(null),
      child: Icon(CupertinoIcons.add),
      ),
    );
  }

 void showform(int ? id ) async{
    if(id!=null){
      //id == null create new id !=null update
      final existing_data=datas.firstWhere((element) => element[id]==id);
      title_controller.text=existing_data["title"];
      description_controller.text=existing_data["description"];
    }
    showModalBottomSheet(context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (context)=>Container(
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: title_controller,
                decoration: InputDecoration(
                  hintText: "Title"
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: description_controller,
                decoration: InputDecoration(
                  hintText: "Description"
                ),
              ),
              ElevatedButton(onPressed: ()async{
                if(id==null){
                  await createitem();
                }
                if(id ! ==null){
                  //await updateItem();
                }

              }, child: Text(id==null?"Create new":"Update"))
            ],
          ),
        ),
    );
 }

 Future<void> createitem() async{
    await SqlHelper.create_item(title_controller.text,description_controller.text);
    refreshdata();
 }
}
