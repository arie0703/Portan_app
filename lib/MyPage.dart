import 'package:flutter/material.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [

            Card(
              child: Padding(
                padding: EdgeInsets.all(30.0),
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 50.0,
                    ),
                    Text("This is my page.")

                  ],
                ),
              )
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text("Yeah!",
                style: TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: 20,
                  color: Colors.white70,
                ),
              )
            )

          ],
        )
      )
    );
  }
}