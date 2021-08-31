import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:por_app/Words/WordCard.dart';
import 'package:por_app/getDeviceInfoFunc.dart';

class BookContent extends StatefulWidget {
  String bookId;
  String bookTitle;
  BookContent(this.bookId, this.bookTitle);
  @override
  _BookContentState createState() => _BookContentState();
}

class _BookContentState extends State<BookContent> {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          margin: EdgeInsets.only(top: 20),
          child: Column (
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close),
                        iconSize: 25,
                    ),
                    SizedBox(
                      width: 10
                    ),
                    Text(
                      widget.bookTitle,
                      style: TextStyle(
                        fontSize: 25
                      ),
                    ),

                  ],
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection('word_belongings').where('book_id', isEqualTo: widget.bookId).snapshots(), //streamでデータの追加とかを監視する
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) { //データがないときの処理
                      return const Center(
                        child: Text("単語はまだありません"),
                      );


                    }
                    if (snapshot.hasError) { //
                      return const Text('Something went wrong');
                    }

                    List<DocumentSnapshot> contents = snapshot.data!.documents;
                    return Expanded(
                        child: ListView( // リストで表示

                          children: snapshot.data!.documents.map((doc) {

                            return WordCard(doc.data['portuguese'], doc.data['japanese'], doc.data['word_id'], doc.documentID, widget.bookId, 1);
                          }
                          ).toList(),
                        )
                    );
                  },
                )
              ]

          )
      )
    );
  }
}