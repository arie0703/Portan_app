import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WordCard extends StatefulWidget {
  String portuguese;
  String japanese;
  String cardId;
  WordCard(this.portuguese, this.japanese, this.cardId);
  @override
  _WordCardState createState() => _WordCardState();
}
class _WordCardState extends State<WordCard> {


  bool isPortuguese = true;

  void _changeText () {
    setState(() {
      if (isPortuguese) {
        isPortuguese = false;
      } else {
        isPortuguese = true;
      }
    });
  }
  Widget build(BuildContext context) {
    return Card (
        elevation: 4.0,
        margin: const EdgeInsets.all(12.0),
        child: Stack (
            children: <Widget> [
              if (isPortuguese)
                InkWell(
                  onTap: () {
                    print(isPortuguese);
                    _changeText();

                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget> [
                      Text(widget.portuguese),
                      SizedBox(height: 100)
                    ],
                  ),
                )
              else
                InkWell(
                  onTap: () {
                    print(isPortuguese);
                    _changeText();

                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget> [
                      Text(widget.japanese),
                      SizedBox(height: 100)
                    ],
                  ),
                ),


              IconButton (
                icon: const Icon(Icons.remove),
                onPressed: () {
                  debugPrint(widget.cardId);
                  showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: Text("Delete post"),
                        content: Text("Você vai apagar este post?"),
                        actions: <Widget>[
                          TextButton(
                            child: Text("Sim"),
                            onPressed: () {
                              Firestore.instance.collection('words').document(widget.cardId).delete();
                              Navigator.pop(context);
                            },
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
              ),

            ]
        )
    );
  }
}