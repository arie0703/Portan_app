import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:por_app/Quiz/QuizStatus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:por_app/Quiz/QuestionArea.dart';
import 'dart:math' as math;

class QuestionView extends StatefulWidget {

  int language;
  QuestionView(this.language);
  @override
  _QuestionViewState createState() => _QuestionViewState();
}

class _QuestionViewState extends State<QuestionView> {

  // ランダム数字取得・レコード数取得のメソッドについてはリファクタリングの余地あり？
  // （もっとパフォーマンスの良いコードがかければ）

  List makeFourRandom(num) { // 単語テーブルのレコード数からランダムな数字を生成、その数字をインデックスとして使用。ランダムな単語を出力する

    var rand = new math.Random();


    List<int> list = [];

    while (list.length < 4) {
        int selected = rand.nextInt(num); // ランダムに数字を抽出
        if (list.contains(selected)) { //　重複しているなら次のループに
          continue;
        } else { // リストにランダムに選ばれた数字を入れる
          list.add(selected);
        }

    }

    return list;
  }

  Widget build(BuildContext context) {
    return Center(
        child: Column(
          children: [
            Text("第" + context.watch<QuizStatus>().currentQuestion.toString() + "問"),
            Text("正解数:" + context.watch<QuizStatus>().correct.toString()),
            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('words').snapshots(), //streamでデータの追加とかを監視する
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) { //データがないときの処理
                  return const Center(
                    child: Text("単語はまだありません"),
                  );


                }
                if (snapshot.hasError) { //
                  return const Text('Something went wrong');
                }

                List option = makeFourRandom(snapshot.data!.documents.length);
                int answerIdx = option[0]; //ランダムに選ばれた4つの数字のうち一番最初を問題文として利用することにする
                String portuguese = snapshot.data!.documents[answerIdx]
                    .data['portuguese'];
                print(context.read<QuizStatus>().currentQuestion.toString() + "問目");
                print(option);
                print("--------------------");

                //Stream Builder使っていると１問の表示につき、2回くらい描画が行われる（関数も2回発火されてパフォーマンスに影響？）

                List answerOption = [
                  snapshot.data!.documents[answerIdx]
                      .data['japanese'],
                  snapshot.data!.documents[option[1]]
                      .data['japanese'],
                  snapshot.data!.documents[option[2]]
                      .data['japanese'],
                  snapshot.data!.documents[option[3]]
                      .data['japanese'],
                ];

                List shuffledIdx = makeFourRandom(4);


                return QuestionArea(portuguese, "テスト", answerOption, shuffledIdx);

              },
            ),

          ],
        )




    );
  }

}