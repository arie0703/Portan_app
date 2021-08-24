import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:por_app/getDeviceInfoFunc.dart';

class WordCard extends StatefulWidget {
  String portuguese;
  String japanese;
  String cardId;
  WordCard(this.portuguese, this.japanese, this.cardId);
  @override
  _WordCardState createState() => _WordCardState();
}
class _WordCardState extends State<WordCard> {


  bool isPortuguese = true;

  void _changeText () {
    setState(() {
      if (isPortuguese) {
        isPortuguese = false;
      } else {
        isPortuguese = true;
      }
    });
  }



  Future _showSimpleDialog() async { // 単語帳に任意の単語を追加する処理
    String doc = Firestore.instance.collection('word_belongings').document().documentID;
    await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('単語帳に追加する'),
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('wordfolders').where('user_id', isEqualTo: deviceId).snapshots(), //streamでデータの追加とかを監視する
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) { //データがないときの処理
                  return const Center(
                    child: Text("単語帳がまだありません"),
                  );
                }
                if (snapshot.hasError) { //
                  return const Text('Something went wrong');
                }
                List<DocumentSnapshot> folders = snapshot.data!.documents;
                return Container(
                  width: double.maxFinite,
                  child: ListView(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: <Widget> [
                        for (int i = 0; i < folders.length; i++)
                          SimpleDialogOption(
                            child: ListTile(
                              leading: CircleAvatar(
                                  backgroundColor: Colors.orange.shade200,
                                  child: Icon(Icons.book)
                              ),
                              title: Text(folders[i].data['title']),
                            ),
                            onPressed: () async {
                              // Word_belongingにタップされた単語カードと選択された単語帳のデータを格納する
                              await Firestore.instance
                                  .collection('word_belongings') // コレクションID
                                  .document(doc) // ドキュメントID
                                  .setData({'folder_id': folders[i].documentID, 'word_id': widget.cardId, 'japanese': widget.japanese, 'portuguese': widget.portuguese, 'created_at': DateTime.now()});

                              // データを追加したら単語帳の単語数（number_of_words）を１増やす
                              await Firestore.instance
                                  .collection('wordfolders') // コレクションID
                                  .document(folders[i].documentID) // ドキュメントID
                                  .updateData({'number_of_words': folders[i].data['number_of_words'] + 1});
                              Navigator.pop(
                                context,
                                "user1",
                              );
                            },
                          ),

                      ]
                  )
                );



              }
            ),

          ],
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Card (
        elevation: 4.0,
        margin: const EdgeInsets.all(12.0),
        child: Stack (
            children: <Widget> [
              if (isPortuguese)
                InkWell(
                  onTap: () {
                    print(isPortuguese);
                    _changeText();

                  },
                  onLongPress: () {
                    _showSimpleDialog();
                    print("longpress");
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget> [
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
                    _showSimpleDialog();
                    print("longpress");
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget> [
                      Text(widget.japanese),
                      SizedBox(height: 100)
                    ],
                  ),
                ),


              IconButton (
                icon: const Icon(Icons.remove),
                onPressed: () {
                  debugPrint(widget.cardId);
                  showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: Text("Delete post"),
                        content: Text("Você vai apagar este post?"),
                        actions: <Widget>[
                          TextButton(
                            child: Text("Sim"),
                            onPressed: () {
                              Firestore.instance.collection('words').document(widget.cardId).delete();
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: Text("Cancel"),
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

            ]
        )
    );
  }
}