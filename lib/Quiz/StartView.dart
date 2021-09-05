import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:por_app/Quiz/QuestionBuilder.dart';
import 'package:por_app/Quiz/QuizStatus.dart';
import 'package:por_app/Quiz/WrongAnswers.dart';
import 'package:provider/provider.dart';
import 'package:por_app/Words/WordCard.dart';

class StartView extends StatelessWidget {
  int language;
  StartView(this.language);

  int number = 10;

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
              "単語クイズ",
            style: TextStyle(
              fontSize: 20
            )
          ),
          Text("問題数を入力してね！（最大100問）"),
          SizedBox(height: 20),
          TextField(
            controller: TextEditingController(text: "10"),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: '問題数を設定（デフォルトは10）',
              focusedBorder:OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.green, width: 2.0),
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            onChanged: (text) {
              number = int.parse(text);
            },
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          SizedBox(height: 15),
          SizedBox(
            width: 280,
            height: 50,
            child: ElevatedButton(
                onPressed: () {
                  if (number <= 100 && number >= 1) {
                    context.read<QuizStatus>().start(language, number);
                  } else {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: Text("エラー"),
                            content: Text("1~100の数字を入力してください。"),
                            actions: <Widget>[
                              TextButton(
                                child: Text("Yes"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        }
                        );
                  }
                },
                child: Text("START"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                )
            ),
          )
        ],
      ),
    );
  }
}