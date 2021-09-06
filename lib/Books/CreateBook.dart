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
  String doc = FirebaseFirestore.instance.collection('words').doc().id; //ランダム生成されるdocumentIDを事前に取得
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
            children: <Widget> [
              Text(
                "単語帳を作成",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                        hintText: 'タイトル',
                        border: OutlineInputBorder(),
                        focusedBorder:OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.green, width: 2.0),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        suffixIcon: IconButton(
                            icon: Icon(Icons.remove, color: Colors.grey),
                            onPressed: () {
                              titleController.clear();
                              title = "";
                            })
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '単語帳のタイトルを入力してください';
                      }
                      if (value.length > 15) {
                        return '15文字以内で入力してください';
                      }
                      return null;
                    },
                    onChanged: (text) {
                      title = text;
                    },
                  ),
                )

              ),


              SizedBox(
                width: 200,
                height: 40,
                child: ElevatedButton(
                  child: Text('追加'),
                  onPressed: () async{
                    if (_formKey.currentState!.validate()) {
                      await FirebaseFirestore.instance
                          .collection('books') // コレクションID
                          .doc(doc) // ドキュメントID
                          .set({'title': title, 'user_id': deviceId, 'number_of_words': 0, 'created_at': DateTime.now()}); // データ

                      Navigator.pop(context);
                    }

                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green
                  )
                ),
              ),

            ]
        ),
      ),
    );
  }

}