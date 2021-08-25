import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:por_app/WordCard.dart';
import 'package:por_app/getDeviceInfoFunc.dart';

class FolderContent extends StatefulWidget {
  String folderId;
  FolderContent(this.folderId);
  @override
  _FolderContentState createState() => _FolderContentState();
}

class _FolderContentState extends State<FolderContent> {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          margin: EdgeInsets.only(top: 64),
          child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('word_belongings').where('folder_id', isEqualTo: widget.folderId).snapshots(), //streamでデータの追加とかを監視する
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
            return ListView( // リストで表示

              children: snapshot.data!.documents.map((doc) {

                  return WordCard(doc.data['portuguese'], doc.data['japanese'], doc.data['word_id'], doc.documentID, widget.folderId, 1);
                }
              ).toList(),
            );
          },
        )
      )
    );
  }
}