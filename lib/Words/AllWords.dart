import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:por_app/Words/WordCard.dart';
import 'package:firebase_core/firebase_core.dart';


class AllWords extends StatefulWidget {
  @override
  _AllWordsState createState() => _AllWordsState();
}
class _AllWordsState extends State<AllWords> {

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('words').orderBy('created_at', descending: true).snapshots(), //streamでデータの追加とかを監視する
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) { //データがないときの処理
          return const Center(
            child: SizedBox(),
          );


        }
        if (snapshot.hasError) { //
          return const Text('Something went wrong');
        }
        return ListView( // リストで表示

          children: snapshot.data!.docs.map((doc) {
            Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
            return WordCard(data['portuguese'], data['japanese'], doc.id, "", "", 2);
          }
          ).toList(),
        );
      },
    );
  }
}