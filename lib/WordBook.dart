import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WordBook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('words').orderBy('created_at', descending: true).snapshots(), //streamでデータの追加とかを監視する
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
                  child: Column (
                    children: <Widget> [
                      Row (
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget> [
                          IconButton (
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              debugPrint(doc.documentID);
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
                                          Firestore.instance.collection('words').document(doc.documentID).delete();
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
                        ],
                      ),
                      Row(
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

                    ]
                  )
                );
              }
          ).toList(),
        );
      },
    );
  }
}