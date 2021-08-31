import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:por_app/Quiz/QuizStatus.dart';
import 'dart:math' as math;

class QuestionArea extends StatefulWidget {
  String portuguese;
  String japanese;
  List option;
  List shuffledIdx;
  QuestionArea(
      this.portuguese, this.japanese, this.option, this.shuffledIdx);
  @override
  _QuestionAreaState createState() => _QuestionAreaState();
}

class _QuestionAreaState extends State<QuestionArea> {





  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 4.0,
          margin: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(widget.portuguese),
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
                  if (context.read<QuizStatus>().currentQuestion < 10) {
                    if (widget.shuffledIdx[i] == 0) {
                      context.read<QuizStatus>().correctAnswer();
                    }
                    context.read<QuizStatus>().goNext();
                  } else {
                    if (widget.shuffledIdx[i] == 0) {
                      context.read<QuizStatus>().correctAnswer();
                    }
                    context.read<QuizStatus>().end();
                  }
                },
                child: Text(widget.option[widget.shuffledIdx[i]]),
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepOrangeAccent, //ボタンの背景色
                ),
              ),
            ),
          )

      ],
    );
  }
}
