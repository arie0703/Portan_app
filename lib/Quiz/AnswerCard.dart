import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:por_app/getDeviceInfoFunc.dart';
import 'package:provider/provider.dart';
import 'package:por_app/Quiz/QuizStatus.dart';
import 'package:flutter_tts/flutter_tts.dart';



class AnswerCard extends StatefulWidget {
  String question;
  String answer;
  AnswerCard(this.question, this.answer);
  @override
  _AnswerCardState createState() => _AnswerCardState();
}
class _AnswerCardState extends State<AnswerCard> {

  final FlutterTts flutterTts = FlutterTts();

  Future<void> _speak(text) async {
    await flutterTts.setLanguage("pt-BR");
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);

    await flutterTts.speak(text);
  }

  Future _addWordToWordBook(portuguese, japanese) async {
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
                                    'japanese': japanese,
                                    'portuguese': portuguese,
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
            Text(widget.question),
            SizedBox(width:10),
            Icon(Icons.arrow_forward),
            SizedBox(width:10),
            Text(widget.answer,
              style: TextStyle(
                color: Colors.deepOrange
              ),
            )
          ],
        ),
        tileColor: Colors.black38,
        trailing: IconButton(
            onPressed: () async{
              if(context.read<QuizStatus>().selectedLanguage == 0) {
                _speak(widget.question);
              } else {
                _speak(widget.answer);
              }
            },
            icon: Icon(Icons.volume_up)
        ),
        onLongPress: () {
          if (context.read<QuizStatus>().selectedLanguage == 0) { // クイズのモードによって、questionとanswer,ポルトガル語と日本語が入れ替わるので注意
            _addWordToWordBook(widget.question, widget.answer);
          } else {
            _addWordToWordBook(widget.answer, widget.question);
          }
        },


      ),
    );
  }
}