import 'package:flutter/material.dart';
import 'package:por_app/Quiz/QuestionBuilder.dart';
import 'package:por_app/Quiz/QuizStatus.dart';
import 'package:por_app/Quiz/WrongAnswers.dart';
import 'package:provider/provider.dart';
import 'package:por_app/Words/WordCard.dart';

class Result extends StatelessWidget {


  Widget build(BuildContext context) {
    List wrongs = context.read<QuizStatus>().wrongWords;

    return Column (
      children: [
        Text(
            "結果",
          style: TextStyle(
            fontSize: 24,
          )
        ),
        Container(
          margin: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  context.watch<QuizStatus>().correct.toString(),
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.yellow
                  )
              ),
              SizedBox(width: 10),
              Text("問正解！"),
            ],
          )
        ),



        SizedBox(
          width: 260,
          height: 50,
          child: ElevatedButton(
              child: Text("スタート画面へ"),
              onPressed: () {

                context.read<QuizStatus>().quit();

              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green
              ),
          ),
        ),
        SizedBox(
          height: 10
        ),
        SizedBox(
          width: 260,
          height: 50,
          child: ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  //モーダルの背景の色、透過
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return WrongAnswers();
                    });
              },
              child: Text("間違えた問題をチェック"),
              style: ElevatedButton.styleFrom(
                  primary: Colors.green,

              ),
          ),
        ),

      ],
    );
  }
}