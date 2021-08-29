import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:por_app/getDeviceInfoFunc.dart';

class CreateBook extends StatefulWidget {
  @override
  _CreateBookState createState() => _CreateBookState();
}
class _CreateBookState extends State<CreateBook> {

  String title = "";
  // TextEditingControllerで各テキストフィールドの挙動を調整できる。
  final titleController = TextEditingController();
  final portugueseController = TextEditingController();
  String doc = Firestore.instance.collection('words').document().documentID; //ランダム生成されるdocumentIDを事前に取得



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 64),
        child: Column(
            children: <Widget> [
              Text("単語帳を作成"),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                    hintText: 'Title',
                    suffixIcon: IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          titleController.clear();
                          title = "";
                        })
                ),
                onChanged: (text) {
                  title = text;
                },
              ),

              ElevatedButton(
                child: Text('Add'),
                onPressed: () async{
                  await Firestore.instance
                      .collection('books') // コレクションID
                      .document(doc) // ドキュメントID
                      .setData({'title': title, 'user_id': deviceId, 'number_of_words': 0, 'created_at': DateTime.now()}); // データ

                  Navigator.pop(context);

                },
              ),

            ]
        ),
      ),
    );
  }

}