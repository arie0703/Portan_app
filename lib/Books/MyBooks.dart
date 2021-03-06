import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:por_app/Books/BookContent.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:por_app/VariableState.dart';


class MyBooks extends StatefulWidget {
  @override
  _MyBooksState createState() => _MyBooksState();
}

class _MyBooksState extends State<MyBooks> {

  String deviceId = "";
  Future<String> getDeviceUniqueId() async {
    var deviceIdentifier = 'unknown';
    var deviceInfo = DeviceInfoPlugin();

    if(Platform.isAndroid) {
      var androidInfo = await deviceInfo.androidInfo;
      deviceIdentifier = androidInfo.androidId!;
    } else if(Platform.isIOS) {
      var iosInfo = await deviceInfo.iosInfo;
      deviceIdentifier = iosInfo.identifierForVendor!;
    }

    setState(() => deviceId = deviceIdentifier);
    return deviceId;
  }

  @override
  void initState() {
    getDeviceUniqueId(); // ページが読み込まれたら端末IDを取得する
  }
  Widget build(BuildContext context) {
    final paddingTop = context.read<VariableState>().paddingTop;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('books').where('user_id', isEqualTo: deviceId).snapshots(), //streamでデータの追加とかを監視する
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
        return ListView.separated( // リストで表示
                itemCount: books.length,
                separatorBuilder: (BuildContext context, int index) => Divider(),
                itemBuilder: (BuildContext context, int i) {
                  Map<String, dynamic> data = books[i].data()! as Map<String, dynamic>;
                  return ListTile(
                    title: Text(data["title"]),
                    subtitle: Text(data["number_of_words"].toString()),
                    leading: Icon(Icons.book),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              title: Text("単語帳を削除"),
                              content: Text("単語帳を削除しますか？"),
                              actions: <Widget>[
                                TextButton(
                                  child: Text("はい"),
                                  onPressed: () {
                                    // for(int i = 0; i < folders[i].data["number_of_words"]; ++i) {
                                    //
                                    //   Firestore.instance
                                    //       .collection('word_belongings')
                                    //       .document()
                                    //       .delete();
                                    // } belongingも削除したい
                                    FirebaseFirestore.instance
                                        .collection('books')
                                        .doc(books[i].id)
                                        .delete();



                                    Navigator.pop(context);
                                  },
                                ),
                                TextButton(
                                  child: Text("キャンセル"),
                                  onPressed: () {
                                    print(FirebaseFirestore.instance
                                        .collection('word_belongings')
                                        .where('book_id', isEqualTo: books[i].id).get());
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    onTap: () {
                      showModalBottomSheet(
                        //モーダルの背景の色、透過
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            return BookContent(books[i].id, data['title'], paddingTop);
                          });
                    },
                  );
                },

            );


      },
    );
  }

}