import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:por_app/getDeviceInfoFunc.dart';

class Messages extends StatefulWidget {

  @override
  _MessagesState createState() => _MessagesState();

}

class _MessagesState extends State<Messages> {


  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('inquiries').where('user_id', isEqualTo: deviceId).snapshots(), //streamでデータの追加とかを監視する
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) { //データがないときの処理
          return const Center(
            child: SizedBox(),
          );


        }
        if (snapshot.hasError) { //
          return const Text('Something went wrong');
        }

        List<DocumentSnapshot> books = snapshot.data!.docs;
        return Expanded(
          child: ListView( // リストで表示
            children: snapshot.data!.docs.map((doc) {
              Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(data["title"]),
                      subtitle: Text(data["content"]),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: Text("メッセージを削除"),
                                content: Text("削除しますか？"),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text("yes"),
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection('inquiries')
                                          .doc(doc.id)
                                          .delete();



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
                    ),
                  ),
                  if(data['reply'] != null) // 返答を表示
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: ListTile(
                      title: Text("運営からの返答"),
                      subtitle: Text(data['reply']),
                      leading: Icon(Icons.person),
                    ),
                  )

                ],
              );
            }
            ).toList(),

          ),
        );


      },
    );
  }
}