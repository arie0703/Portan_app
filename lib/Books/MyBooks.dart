import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:por_app/Books/CreateBook.dart';
import 'package:por_app/Books/BookContent.dart';
import 'dart:io';


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
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('books').where('user_id', isEqualTo: deviceId).snapshots(), //streamでデータの追加とかを監視する
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) { //データがないときの処理
          return const Center(
            child: SizedBox(),
          );


        }
        if (snapshot.hasError) { //
          return const Text('Something went wrong');
        }

        List<DocumentSnapshot> books = snapshot.data!.documents;
        return Column(

          children: <Widget> [
            ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    //モーダルの背景の色、透過
                      backgroundColor: Colors.black12,
                      //ドラッグ可能にする（高さもハーフサイズからフルサイズになる様子）
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                        return CreateBook();
                      });
                },
                child: Text("単語帳を追加")
            ),
            Expanded(child:
              ListView.separated( // リストで表示
                itemCount: books.length,
                separatorBuilder: (BuildContext context, int index) => Divider(),
                itemBuilder: (BuildContext context, int i) {
                  return ListTile(
                    title: Text(books[i].data["title"]),
                    subtitle: Text(books[i].data["number_of_words"].toString()),
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
                                  child: Text("yes"),
                                  onPressed: () {
                                    // for(int i = 0; i < folders[i].data["number_of_words"]; ++i) {
                                    //
                                    //   Firestore.instance
                                    //       .collection('word_belongings')
                                    //       .document()
                                    //       .delete();
                                    // } belongingも削除したい
                                    Firestore.instance
                                        .collection('books')
                                        .document(books[i].documentID)
                                        .delete();



                                    Navigator.pop(context);
                                  },
                                ),
                                TextButton(
                                  child: Text("Cancel"),
                                  onPressed: () {
                                    print(Firestore.instance
                                        .collection('word_belongings')
                                        .where('book_id', isEqualTo: books[i].documentID).getDocuments());
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
                          //ドラッグ可能にする（高さもハーフサイズからフルサイズになる様子）
                          context: context,
                          builder: (BuildContext context) {
                            return BookContent(books[i].documentID);
                          });
                    },
                  );
                },

            ),

            )

        ]
        );
      },
    );
  }

}