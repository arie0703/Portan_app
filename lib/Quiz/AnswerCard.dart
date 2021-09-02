import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:por_app/getDeviceInfoFunc.dart';


class AnswerCard extends StatefulWidget {
  String portuguese;
  String japanese;
  AnswerCard(this.portuguese, this.japanese);
  @override
  _AnswerCardState createState() => _AnswerCardState();
}
class _AnswerCardState extends State<AnswerCard> {

  Future _addWordToWordBook() async {
    // 単語帳に任意の単語を追加する処理
    String doc =
        Firestore.instance.collection('word_belongings').document().documentID;
    await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('単語帳に追加する'),
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection('books')
                    .where('user_id', isEqualTo: deviceId)
                    .snapshots(), //streamでデータの追加とかを監視する
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    //データがないときの処理
                    return const Center(
                      child: Text("単語帳がまだありません"),
                    );
                  }
                  if (snapshot.hasError) {
                    //
                    return const Text('Something went wrong');
                  }
                  List<DocumentSnapshot> folders = snapshot.data!.documents;
                  return Container(
                      width: double.maxFinite,
                      child: ListView(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: <Widget>[
                            for (int i = 0; i < folders.length; i++)
                              SimpleDialogOption(
                                child: ListTile(
                                  leading: CircleAvatar(
                                      backgroundColor: Colors.orange.shade200,
                                      child: Icon(Icons.book)),
                                  title: Text(folders[i].data['title']),
                                ),
                                onPressed: () async {
                                  // Word_belongingにタップされた単語カードと選択された単語帳のデータを格納する
                                  await Firestore.instance
                                      .collection('word_belongings') // コレクションID
                                      .document(doc) // ドキュメントID
                                      .setData({
                                    'book_id': folders[i].documentID,
                                    'word_id': "",
                                    'japanese': widget.japanese,
                                    'portuguese': widget.portuguese,
                                    'created_at': DateTime.now()
                                  });

                                  // データを追加したら単語帳の単語数（number_of_words）を１増やす
                                  await Firestore.instance
                                      .collection('books') // コレクションID
                                      .document(
                                      folders[i].documentID) // ドキュメントID
                                      .updateData({
                                    'number_of_words':
                                    FieldValue.increment(1)
                                  });
                                  Navigator.pop(
                                    context,
                                    "user1",
                                  );
                                },
                              ),
                          ]));
                }),
          ],
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12),
      child: ListTile(
        title: Row(
          children: [
            Text(widget.portuguese),
            SizedBox(width:10),
            Icon(Icons.arrow_forward),
            SizedBox(width:10),
            Text(widget.japanese,
              style: TextStyle(
                color: Colors.deepOrange
              ),
            )
          ],
        ),
        tileColor: Colors.black38,
        trailing: IconButton(
          icon: Icon(Icons.add),
          onPressed: _addWordToWordBook,
        ),
      ),
    );
  }
}