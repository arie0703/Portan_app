import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:por_app/Words/WordCard.dart';
import 'dart:io';


class MyWords extends StatefulWidget {
  @override
  _MyWordsState createState() => _MyWordsState();
}
class _MyWordsState extends State<MyWords> {
  String deviceId = ""; // 機種特有のID

  // WordBookはアプリ起動時に一番最初に開かれる画面である
  // それゆえに、アプリ起動時にdeviceIdの値を更新する処理が間に合わないので、ここでgetDeviceInfoFuncの関数を記述
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
      stream: Firestore.instance.collection('words').orderBy('created_at', descending: true).where('user_id', isEqualTo: deviceId).snapshots(), //streamでデータの追加とかを監視する
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

          children: snapshot.data!.documents.map((doc) {

                return WordCard(doc.data['portuguese'], doc.data['japanese'], doc.documentID, "", "", 0);
              }
          ).toList(),
        );
      },
    );
  }
}