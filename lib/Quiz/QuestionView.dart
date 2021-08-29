import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:por_app/Quiz/QuizStatus.dart';

class QuestionView extends StatefulWidget {

  int language;
  QuestionView(this.language);
  @override
  _QuestionViewState createState() => _QuestionViewState();
}

class _QuestionViewState extends State<QuestionView> {

  Widget build(BuildContext context) {
    return Center(
        child: Column(
          children: [
            Text("第" + context.watch<QuizStatus>().currentQuestion.toString() + "問"),
            Text("正解数:" + context.watch<QuizStatus>().correct.toString()),
            ElevatedButton(
              onPressed: () {
                if (context.read<QuizStatus>().currentQuestion < 11) {
                  context.read<QuizStatus>().correctAnswer();
                } else {
                  context.read<QuizStatus>().end();
                }


              },
              child: Text("next"),
            ),
          ],
        )




    );
  }

}