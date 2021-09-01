import 'package:flutter/material.dart';
import 'package:por_app/Quiz/QuizView.dart';

class Quiz extends StatelessWidget {
  void _showOverlay(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return QuizView(0);
        },
      ),
    );
  }
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Text("単語クイズ"),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return QuizView(0);
                    },
                    fullscreenDialog: true,
                  ),
                );
              },
              child: Text("日本語　→　ポルトガル語")
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return QuizView(1);
                    },
                    fullscreenDialog: true,
                  ),
                );
              },
              child: Text("ポルトガル語　→　日本語")
          ),
        ],
      )
    );
  }
}