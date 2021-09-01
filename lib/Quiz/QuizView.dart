
import 'package:flutter/material.dart';
import 'package:por_app/Quiz/QuestionBuilder.dart';
import 'package:por_app/Quiz/QuizStatus.dart';
import 'package:provider/provider.dart';

class QuizView extends StatefulWidget {
  // 渡す値 is_started: boolean, current_question: int, correct: int
  int language;
  QuizView(this.language);
  @override
  _QuizViewState createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          margin: EdgeInsets.only(top: 10),
          child: Center (
            child: Column (
              children: <Widget>[
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              title: Text("終了する"),
                              content: Text("クイズを終了しますか？（データは保存されません）"),
                              actions: <Widget>[
                                TextButton(
                                  child: Text("Yes"),
                                  onPressed: () {
                                    context.read<QuizStatus>().quit();
                                    //最初の画面に戻る
                                    Navigator.of(context).popUntil((route) => route.isFirst);
                                  }
                                ),
                                TextButton(
                                  child: Text("Cancel"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          },
                        );

                      },
                      icon: Icon(Icons.close),
                      iconSize: 25,
                    ),
                  ],
                ),
                if (context.watch<QuizStatus>().isStarted)
                  QuestionBuilder(widget.language)
                else if (context.watch<QuizStatus>().isEnded)
                  Column (
                    children: [
                      Text("終了！"),
                      Text("正解数" + context.watch<QuizStatus>().correct.toString()),
                      ElevatedButton(
                          child: Text("RESTART"),
                          onPressed: () {
                            setState(() {
                              context.read<QuizStatus>().start();
                            });
                          }
                      )
                    ],
                  )

                else if (!context.watch<QuizStatus>().isStarted)
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            context.read<QuizStatus>().start();
                          });
                        },
                        child: Text("START")
                    ),

                Text("isEnded: " + context.watch<QuizStatus>().isEnded.toString()),
                Text("isStarted: " + context.watch<QuizStatus>().isStarted.toString()),
                Text("currentQuestion: " + context.watch<QuizStatus>().currentQuestion.toString()),
              ],
            ),
          ),
        )
    );
  }

}