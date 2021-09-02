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
        Text("終了！"),
        Text("正解数" + context.watch<QuizStatus>().correct.toString()),
        ElevatedButton(
            child: Text("RESTART"),
            onPressed: () {

              context.read<QuizStatus>().start();

            }
        ),

        Text("間違えた問題"),

        ElevatedButton(
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
            child: Text("間違えた問題をみるz")
        )
      ],
    );
  }
}