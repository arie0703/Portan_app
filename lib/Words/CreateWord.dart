import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:por_app/getDeviceInfoFunc.dart';

class CreateWord extends StatefulWidget {
  @override
  BuildContext context;
  CreateWord(this.context);
  _CreateWordState createState() => _CreateWordState();
}
class _CreateWordState extends State<CreateWord> {


  String japanese = "";
  String portuguese = "";
  // TextEditingControllerで各テキストフィールドの挙動を調整できる。
  final japaneseController = TextEditingController();
  final portugueseController = TextEditingController();
  String doc = FirebaseFirestore.instance.collection('words').doc().id; //ランダム生成されるdocumentIDを事前に取得

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.only( //
              top: MediaQuery.of(widget.context).padding.top,
            ),
            child: Column(
                children: <Widget> [
                  Text(
                    "単語を追加",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Text("追加した単語は他のユーザーにも公開されます"),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: TextFormField(
                            controller: portugueseController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'ポルトガル語',
                                focusedBorder:OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.green, width: 2.0),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                suffixIcon: IconButton( //押したら入力内容がクリアされる機能
                                    icon: Icon(Icons.remove, color: Colors.grey),
                                    onPressed: () {
                                      portugueseController.clear();
                                      portuguese = "";
                                    })
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'ポルトガル語を入力してください';
                              }
                              if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                                return '半角英字で入力してください';
                              }
                              if (value.length > 15) {
                                return '15文字以内で入力してください';
                              }
                              return null;
                            },

                            onChanged: (text) {
                              portuguese = text;
                            },
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: TextFormField(
                            controller: japaneseController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: '日本語',
                                focusedBorder:OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.green, width: 2.0),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                suffixIcon: IconButton(
                                    icon: Icon(Icons.remove, color: Colors.grey),
                                    onPressed: () {
                                      japaneseController.clear();
                                      japanese = "";
                                    })
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                print(value);
                                return '日本語を入力してください';
                              }
                              if (!RegExp(r'^[亜-熙ぁ-んァ-ヶゔヴー]+$').hasMatch(value)) {
                                return '日本語で入力してください';
                              }
                              if (value.length > 15) {
                                return '15文字以内で入力してください';
                              }

                              return null;
                            },
                            onChanged: (text) {
                              japanese = text;
                            },
                          ),
                        ),

                        SizedBox(
                          width: 250,
                          height: 50,
                          child: ElevatedButton(
                            child: Text('追加'),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.green
                            ),
                            onPressed: () async{
                              if (_formKey.currentState!.validate()) {
                                await FirebaseFirestore.instance
                                    .collection('words') // コレクションID
                                    .doc(doc) // ドキュメントID
                                    .set({'japanese': japanese, 'portuguese': portuguese, 'user_id': deviceId, 'created_at': DateTime.now()}); // データ

                                Navigator.pop(context);
                              }


                            },
                          ),
                        ),
                      ],
                    )
                  ),


                ]
            ),
        ),
    );
  }

}