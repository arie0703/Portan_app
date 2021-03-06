import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:por_app/Words/WordCard.dart';
import 'package:por_app/getDeviceInfoFunc.dart';

class BookContent extends StatefulWidget {
  String bookId;
  String bookTitle;
  double paddingTop;
  BookContent(this.bookId, this.bookTitle, this.paddingTop);
  @override
  _BookContentState createState() => _BookContentState();
}

class _BookContentState extends State<BookContent> {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.only(top: widget.paddingTop),
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
                  stream: FirebaseFirestore.instance.collection('word_belongings').where('book_id', isEqualTo: widget.bookId).snapshots(), //streamでデータの追加とかを監視する
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) { //データがないときの処理
                      return const Center(
                        child: Text("単語はまだありません"),
                      );


                    }
                    if (snapshot.hasError) { //
                      return const Text('Something went wrong');
                    }

                    List<DocumentSnapshot> contents = snapshot.data!.docs;
                    return Expanded(
                        child: ListView( // リストで表示

                          children: snapshot.data!.docs.map((doc) {
                            Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
                            return WordCard(data['portuguese'], data['japanese'], data['word_id'], doc.id, widget.bookId, 1);
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