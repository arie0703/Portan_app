import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:por_app/CreateFolder.dart';
import 'package:por_app/FolderContent.dart';
import 'dart:io';


class WordFolder extends StatefulWidget {
  @override
  _WordFolderState createState() => _WordFolderState();
}

class _WordFolderState extends State<WordFolder> {

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
      stream: Firestore.instance.collection('wordfolders').where('user_id', isEqualTo: deviceId).snapshots(), //streamでデータの追加とかを監視する
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) { //データがないときの処理
          return const Center(
            child: SizedBox(),
          );


        }
        if (snapshot.hasError) { //
          return const Text('Something went wrong');
        }

        List<DocumentSnapshot> folders = snapshot.data!.documents;
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
                        return CreateFolder();
                      });
                },
                child: Text("add folder")
            ),
            Expanded(child:
              ListView.separated( // リストで表示
                itemCount: folders.length,
                separatorBuilder: (BuildContext context, int index) => Divider(),
                itemBuilder: (BuildContext context, int i) {
                  return ListTile(
                    title: Text(folders[i].data["title"]),
                    subtitle: Text(folders[i].data['number_of_words'].toString()),
                    leading: Icon(Icons.book),
                    onTap: () {
                      showModalBottomSheet(
                        //モーダルの背景の色、透過
                          backgroundColor: Colors.transparent,
                          //ドラッグ可能にする（高さもハーフサイズからフルサイズになる様子）
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            return FolderContent(folders[i].documentID);
                          });
                    },
                  );
                },
              // children: snapshot.data!.documents.map((doc) {
              //   return ListTile(
              //     title: Text(doc.data["title"]),
              //     subtitle: Text(doc.data['number_of_words'].toString()),
              //     leading: Icon(Icons.book),
              //     tileColor: Colors.white10,
              //     onTap: () {
              //       print(folders.documents[0].data["title"]);
              //     },
              //   );
              // }
              // ).toList(),

            ),

            )

        ]
        );
      },
    );
  }

}