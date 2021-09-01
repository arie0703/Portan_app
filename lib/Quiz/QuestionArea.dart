import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:por_app/Quiz/QuizStatus.dart';
import 'dart:math' as math;

class QuestionArea extends StatefulWidget {
  String question;
  List option;
  List shuffledIdx;
  QuestionArea(
      this.question, this.option, this.shuffledIdx);
  @override
  _QuestionAreaState createState() => _QuestionAreaState();
}

class _QuestionAreaState extends State<QuestionArea> {





  Widget build(BuildContext context) {

    String answer = widget.option[0];
    return Column(
      children: [
        Card(
          elevation: 4.0,
          margin: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(widget.question),
              SizedBox(height: 100)
            ],
          )
        ),
        for (int i = 0; i < widget.shuffledIdx.length; i++)
          Container(
            margin: EdgeInsets.all(10),
            child: SizedBox(
              // 5.SizedBoxで囲んでwidth/heightをつける
              width: 300,
              height: 60,
              child: ElevatedButton(
                onPressed: () {


                  if (widget.shuffledIdx[i] == 0) { // 正解だったら
                      showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: Text("正解！"),
                            content: Text("やったね！"),
                            actions: <Widget>[
                              TextButton(
                                child: Text("OK"),
                                onPressed: () {
                                  context.read<QuizStatus>().correctAnswer();
                                  Navigator.pop(context);
                                  if (context.read<QuizStatus>().currentQuestion < 10) {
                                    context.read<QuizStatus>().goNext();
                                  } else {
                                    context.read<QuizStatus>().end();
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      );

                  } else {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: Text("残念！"),
                          content: Text('正解は"' + answer + '"です！'),
                          actions: <Widget>[
                            TextButton(
                              child: Text("OK"),
                              onPressed: () {
                                Navigator.pop(context);
                                if (context.read<QuizStatus>().currentQuestion < 10) {
                                  context.read<QuizStatus>().goNext();
                                } else {
                                  context.read<QuizStatus>().end();
                                }
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }



                },
                child: Text(widget.option[widget.shuffledIdx[i]]),
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange, //ボタンの背景色
                ),
              ),
            ),
          )

      ],
    );
  }
}
