import 'package:flutter/material.dart';
import 'package:sql_notes_app/Model/notes_model.dart';

import 'db_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  DBHelper? dbHelper;
  late Future<List<NotesModel>> notesList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper=DBHelper();
    loadData();
  }

  loadData() async {
    notesList=dbHelper!.getNotesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes SQL"),
        centerTitle: true,
      ),
      body: Column(
        children: [
           Expanded(
             child: FutureBuilder(future: notesList, builder: (context,AsyncSnapshot<List<NotesModel>> snapshot){

               if(snapshot.hasData){
                 return ListView.builder(
                     reverse: false,
                     shrinkWrap: true,
                     itemCount: snapshot.data?.length,
                     itemBuilder: (context,index){
                       return InkWell(
                         onTap: (){
                            dbHelper!.updateQuantity(
                              NotesModel(
                                id: snapshot.data![index].id,
                                  title:"First  Flutter Note",
                                  age: 11,
                                  description: 'lem me talk you tommorow',
                                  email: "jdpadvani@gmail.com")
                            );
                            setState(() {
                              notesList=dbHelper!.getNotesList();
                            });
                            
                         },
                         child: Dismissible(
                           direction: DismissDirection.startToEnd,
                           background: Container(
                             child: Icon(Icons.delete),
                           ),
                           onDismissed: (DismissDirection direction){
                                  setState(() {
                                    dbHelper!.deleteProduct(snapshot.data![index].id!);
                                    notesList=dbHelper!.getNotesList();
                                    snapshot.data!.remove(snapshot.data![index]);
                                  });
                           },
                           key: ValueKey<int>(snapshot.data![index].id!),
                           child: Card(
                             child: ListTile(
                               contentPadding: EdgeInsets.all(0),
                               title: Text(snapshot.data![index].title.toString()),
                               subtitle: Text(snapshot.data![index].description.toString()),
                               trailing: Text(snapshot.data![index].age.toString()),
                             ),
                           ),
                         ),
                       );
                     });
               }
               else{
                 return CircularProgressIndicator();
               }

             
             
             }),
           )
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        dbHelper!.insert(NotesModel(title: 'Second Note',
            age: 22,
            description: 'This is my second sql App',
            email: "jdpadvani@gmail.com")
        ).then((value){
          print("data added");
          setState(() {
            notesList=dbHelper!.getNotesList();
          });
        }).onError((error, stackTrace){
          print(error.toString());
        });
      },
      child: Icon(Icons.add),
      ),
    );
  }
}
