import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WordBook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('words').orderBy('created_at', descending: false).snapshots(), //streamでデータの追加とかを監視する
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) { //データがないときの処理
          return const Center(
            child: const CircularProgressIndicator(), // ローディングエフェクト
          );


        }
        if (snapshot.hasError) { //
          return const Text('Something went wrong');
        }
        return ListView( // リストで表示
          children: snapshot.data!.documents.map((doc) {
                return Card (
                  elevation: 4.0,
                  margin: const EdgeInsets.all(12.0),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget> [
                      Text(doc.data["japanese"]),
                      SizedBox(
                        height: 100,
                        width: 150,
                      ),
                      Text(doc.data["portuguese"]),
                    ],
                  ),
                );
              }
          ).toList(),
        );
      },
    );
  }
}