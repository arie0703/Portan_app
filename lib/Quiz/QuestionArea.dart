import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:por_app/Quiz/QuizStatus.dart';
import 'package:flutter_tts/flutter_tts.dart';

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
  final FlutterTts flutterTts = FlutterTts();

  Future<void> _speak(text) async {
    await flutterTts.setLanguage("pt-BR");
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);

    await flutterTts.speak(text);
  }

  Widget build(BuildContext context) {

    String answer = widget.option[0];
    return Column(
      children: [
        Card(
          elevation: 4.0,
          margin: const EdgeInsets.all(12.0),
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(widget.question),
                  SizedBox(height: 100)
                ],
              ),
              if(context.read<QuizStatus>().selectedLanguage == 0)
                IconButton(
                    onPressed: () async{
                      _speak(widget.question);
                    },
                    icon: Icon(Icons.volume_up)
                )


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
                                  if (context.read<QuizStatus>().currentQuestion < context.read<QuizStatus>().numberOfQuestion) {
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
                                context.read<QuizStatus>().addWrongWords(widget.question, answer);
                                if (context.read<QuizStatus>().currentQuestion < context.read<QuizStatus>().numberOfQuestion ) {
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
                  primary: Colors.green, //ボタンの背景色
                ),
              ),
            ),
          )

      ],
    );
  }
}
