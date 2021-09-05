import 'package:flutter/material.dart';
import 'package:por_app/Quiz/QuizView.dart';
import 'package:provider/provider.dart';
import 'package:por_app/Quiz/QuizStatus.dart';

class ModeSelection extends StatelessWidget {
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10),
            child: Text(
              "モードを選んでね！",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),


          SizedBox(

            width: 300,
            height: 60,
            child: ElevatedButton(
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
                child: Text("ポルトガル語　→　日本語"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green, //ボタンの背景色
                ),
            ),

          ),

          SizedBox(
            height: 10,
          ),
          SizedBox(

              width: 300,
              height: 60,
              child: ElevatedButton(
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
                  child: Text("日本語　→　ポルトガル語"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green, //ボタンの背景色
                  ),
              )
          ),


        ],
      )
    );
  }
}