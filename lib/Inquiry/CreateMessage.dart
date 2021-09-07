import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:por_app/getDeviceInfoFunc.dart';

class CreateMessage extends StatefulWidget {

  @override
  _CreateMessageState createState() => _CreateMessageState();

}

class _CreateMessageState extends State<CreateMessage> {

  String title = "";
  String content = "";
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  String doc = FirebaseFirestore.instance.collection('inquiries').doc().id; //ランダム生成されるdocumentIDを事前に取得
  final _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              "お問い合わせ",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: titleController,
                        decoration: InputDecoration(
                            hintText: 'お問い合わせ内容',
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
                            return 'お問い合わせ内容を入力してください';
                          }
                          return null;
                        },
                        onChanged: (text) {
                          title = text;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: contentController,
                        decoration: InputDecoration(
                            hintText: 'メッセージ',
                            border: OutlineInputBorder(),
                            focusedBorder:OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.green, width: 2.0),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            suffixIcon: IconButton(
                                icon: Icon(Icons.remove, color: Colors.grey),
                                onPressed: () {
                                  contentController.clear();
                                  content = "";
                                })
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'お問い合わせ内容を入力してください';
                          }
                          return null;
                        },
                        onChanged: (text) {
                          content = text;
                        },
                      ),
                    )
                  ],
                )

            ),

            SizedBox(
              width: 200,
              height: 40,
              child: ElevatedButton(
                  child: Text('送信'),
                  onPressed: () async{
                    if (_formKey.currentState!.validate()) {
                      await FirebaseFirestore.instance
                          .collection('inquiries') // コレクションID
                          .doc(doc) // ドキュメントID
                          .set({'title': title, 'user_id': deviceId, 'content': content, 'reply': null, 'created_at': DateTime.now()}); // データ

                      Navigator.pop(context);
                    }

                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.green
                  )
              ),
            ),

          ],
        ),
      ),
    );
  }
}