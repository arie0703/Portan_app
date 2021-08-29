
import 'package:flutter/material.dart';
import 'package:por_app/Quiz/QuestionView.dart';
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
            margin: EdgeInsets.only(top: 64),
            child: Center (
              child: Column (
                children: <Widget>[
                  if (context.watch<QuizStatus>().isStarted)
                    QuestionView(widget.language)
                  else if (context.watch<QuizStatus>().isEnded)
                    Column (
                      children: [
                        Text("終了！"),
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