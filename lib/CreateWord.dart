import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:por_app/getDeviceInfoFunc.dart';

class CreateWord extends StatefulWidget {
  @override
  _CreateWordState createState() => _CreateWordState();
}
class _CreateWordState extends State<CreateWord> {

  String japanese = "";
  String portuguese = "";
  // TextEditingControllerで各テキストフィールドの挙動を調整できる。
  final japaneseController = TextEditingController();
  final portugueseController = TextEditingController();
  String doc = Firestore.instance.collection('words').document().documentID; //ランダム生成されるdocumentIDを事前に取得



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            margin: EdgeInsets.only(top: 64),

            child: Column(
                children: <Widget> [
                  TextField(
                    controller: japaneseController,
                    decoration: InputDecoration(
                        hintText: 'japanese',
                        suffixIcon: IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              japaneseController.clear();
                              japanese = "";
                            })
                    ),
                    onChanged: (text) {
                      japanese = text;
                    },
                  ),

                  TextField(
                    controller: portugueseController,
                    decoration: InputDecoration(
                        hintText: 'portuguese',
                        suffixIcon: IconButton( //押したら入力内容がクリアされる機能
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              portugueseController.clear();
                              portuguese = "";
                            })
                    ),

                    onChanged: (text) {
                      portuguese = text;
                    },
                  ),
                  ElevatedButton(
                    child: Text('Add'),
                    onPressed: () async{
                      await Firestore.instance
                          .collection('words') // コレクションID
                          .document(doc) // ドキュメントID
                          .setData({'japanese': japanese, 'portuguese': portuguese, 'user_id': deviceId, 'created_at': DateTime.now()}); // データ

                      Navigator.pop(context);

                    },
                  ),

                ]
            ),
        ),
    );
  }

}