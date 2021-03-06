
import 'package:flutter/material.dart';
import 'package:por_app/Quiz/QuestionBuilder.dart';
import 'package:por_app/Quiz/QuizStatus.dart';
import 'package:provider/provider.dart';
import 'package:por_app/Quiz/Result.dart';
import 'package:por_app/Quiz/StartView.dart';

class QuizView extends StatefulWidget {
  int language;
  QuizView(this.language);
  @override
  _QuizViewState createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Center (
            child: Column (
              children: <Widget>[
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (context.read<QuizStatus>().isStarted) {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: Text("終了する"),
                                content: Text("クイズを終了しますか？（データは保存されません）"),
                                actions: <Widget>[
                                  TextButton(
                                      child: Text("はい"),
                                      onPressed: () {
                                        context.read<QuizStatus>().quit();
                                        //最初の画面に戻る
                                        Navigator.of(context).popUntil((
                                            route) => route.isFirst);
                                      }
                                  ),
                                  TextButton(
                                    child: Text("キャンセル"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                          context.read<QuizStatus>().quit();
                        }


                      },
                      icon: Icon(Icons.close),
                      iconSize: 25,
                    ),
                  ],
                ),
                if (context.watch<QuizStatus>().isStarted)
                  QuestionBuilder()
                else if (context.watch<QuizStatus>().isEnded)
                  Result()

                else if (!context.watch<QuizStatus>().isStarted)
                  StartView(widget.language)

                // デバッグ用
                // Text("isEnded: " + context.watch<QuizStatus>().isEnded.toString()),
                // Text("isStarted: " + context.watch<QuizStatus>().isStarted.toString()),
                // Text("currentQuestion: " + context.watch<QuizStatus>().currentQuestion.toString()),
                // Text("selectedLanguage: " + context.watch<QuizStatus>().selectedLanguage.toString()),
              ],
            ),
          ),
        )
    );
  }

}