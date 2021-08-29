import 'package:flutter/material.dart';
import 'package:por_app/Quiz/QuizView.dart';

class Quiz extends StatelessWidget {

  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Text("単語クイズ"),
          ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                    backgroundColor: Colors.black12,
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return QuizView(0);
                    });
              },
              child: Text("日本語　→　ポルトガル語")
          ),
          ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                    backgroundColor: Colors.black12,
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return QuizView(1);
                    });
              },
              child: Text("ポルトガル語　→　日本語")
          ),
        ],
      )
    );
  }
}