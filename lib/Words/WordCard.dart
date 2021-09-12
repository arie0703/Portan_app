import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:por_app/getDeviceInfoFunc.dart';
import 'package:flutter_tts/flutter_tts.dart';

class WordCard extends StatefulWidget {
  String portuguese;
  String japanese;
  String cardId;
  String belongingId;
  String bookId;
  int mode; // マイ単語からなら0, 単語帳からなら1, それ以外なら2
  WordCard(
      this.portuguese, this.japanese, this.cardId, this.belongingId, this.bookId, this.mode);
  @override
  _WordCardState createState() => _WordCardState();
}

class _WordCardState extends State<WordCard> {
  bool isPortuguese = true;
  final FlutterTts flutterTts = FlutterTts();

  void _changeText() {
    setState(() {
      if (isPortuguese) {
        isPortuguese = false;
      } else {
        isPortuguese = true;
      }
    });
  }

  Future getCountWordsFromWordBook(book_id) async {
    await FirebaseFirestore.instance
        .collection('books') // コレクションID
        .doc(
        book_id) // ドキュメントID
        .update({
      'number_of_words':
      FirebaseFirestore.instance.collection('word_belongings').where('folder_id', isEqualTo: book_id).get()
    });
  }

  Future _addWordToWordBook() async {
    // 単語帳に任意の単語を追加する処理
    String doc =
        FirebaseFirestore.instance.collection('word_belongings').doc().id;
    await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('単語帳に追加する'),
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
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
                  List<DocumentSnapshot> folders = snapshot.data!.docs;
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
                                  title: Text(folders[i].get('title')),
                                ),
                                onPressed: () async {
                                  // Word_belongingにタップされた単語カードと選択された単語帳のデータを格納する
                                  await FirebaseFirestore.instance
                                      .collection('word_belongings') // コレクションID
                                      .doc(doc) // ドキュメントID
                                      .set({
                                    'book_id': folders[i].id,
                                    'word_id': widget.cardId,
                                    'japanese': widget.japanese,
                                    'portuguese': widget.portuguese,
                                    'created_at': DateTime.now()
                                  });

                                  // データを追加したら単語帳の単語数（number_of_words）を１増やす
                                  await FirebaseFirestore.instance
                                      .collection('books') // コレクションID
                                      .doc(
                                          folders[i].id) // ドキュメントID
                                      .update({
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


  Future<void> _speak(text) async {
    await flutterTts.setLanguage("pt-BR");
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);

    await flutterTts.speak(text);
  }


  Widget build(BuildContext context) {
    return Card(
        elevation: 4.0,
        margin: const EdgeInsets.all(12.0),
        child: Stack(children: <Widget>[
          if (isPortuguese)
            InkWell(
              onTap: () {
                print(isPortuguese);
                _changeText();
              },
              onLongPress: () {
                _addWordToWordBook();
                print("longpress");
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(widget.portuguese),
                  SizedBox(height: 100)
                ],
              ),
            )
          else
            InkWell(
              onTap: () {
                print(isPortuguese);
                _changeText();
              },
              onLongPress: () {
                _addWordToWordBook();
                print("longpress");
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(widget.japanese),
                  SizedBox(height: 100)
                ],
              ),
            ),
          Row(
            children: [
              if (widget.mode < 2)
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    debugPrint(widget.cardId);
                    showDialog(
                      context: context,
                      builder: (_) {
                        if (widget.mode == 0) //　マイ単語から遷移してきた時の処理
                          return AlertDialog(
                            title: Text("単語を削除"),
                            content: Text("単語を削除しますか？"),
                            actions: <Widget>[
                              TextButton(
                                child: Text("はい"),
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection('words')
                                      .doc(widget.cardId)
                                      .delete();
                                  Navigator.pop(context);
                                },
                              ),
                              TextButton(
                                child: Text("キャンセル"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        else
                          return AlertDialog(
                            title: Text("単語帳から削除"),
                            content: Text("単語帳からこの単語を削除しますか？"),
                            actions: <Widget>[
                              TextButton(
                                child: Text("はい"),
                                onPressed: () async {
                                  FirebaseFirestore.instance
                                      .collection('word_belongings')
                                      .doc(widget.belongingId)
                                      .delete();

                                  FirebaseFirestore.instance
                                      .collection('books') // コレクションID
                                      .doc(
                                      widget.bookId) // ドキュメントID
                                      .update({
                                    'number_of_words':
                                    FieldValue.increment(-1)
                                  });
                                  // getCountWordsFromWordBook(widget.folderId)
                                  Navigator.pop(context);
                                },
                              ),
                              TextButton(
                                child: Text("キャンセル"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );

                      },
                    );
                  },
                ),
              if (isPortuguese)
                IconButton(
                    onPressed: () async{
                      _speak(widget.portuguese);
                    },
                    icon: Icon(Icons.volume_up)
                )
            ],
          ),

           // 単語帳から遷移してきた時の処理
        ]));
  }
}
