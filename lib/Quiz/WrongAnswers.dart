import 'package:flutter/material.dart';
import 'package:por_app/Quiz/AnswerCard.dart';
import 'package:por_app/Quiz/QuizStatus.dart';
import 'package:provider/provider.dart';

class WrongAnswers extends StatelessWidget {
  Widget build(BuildContext context) {
    List wrongs = context.read<QuizStatus>().wrongWords;
    return Scaffold(
        body: Container(
            margin: EdgeInsets.only(top: 20),
            child: Column (
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close),
                        iconSize: 25,
                      ),
                      SizedBox(
                          width: 10
                      ),
                      Text(
                        "間違えた単語",
                        style: TextStyle(
                            fontSize: 18
                        ),
                      ),

                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Text("長押しで単語帳に追加できます"),
                    ],
                  ),

                  Expanded(child:
                    ListView.builder(
                      itemCount: wrongs.length,
                      itemBuilder: (BuildContext context, int i) {
                        return AnswerCard(wrongs[i][0], wrongs[i][1]);
                      }
                  )
                  ),
                ]

            )
        )
    );
  }
}