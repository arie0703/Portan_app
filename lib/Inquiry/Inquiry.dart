import 'package:flutter/material.dart';
import 'package:por_app/Inquiry/CreateMessage.dart';
import 'package:por_app/Inquiry/Messages.dart';
// import 'package:url_launcher/url_launcher.dart';
// メーラーでお問い合わせできるようにもしたい（一旦保留）

class Inquiry extends StatefulWidget {
  double mediaQueryPaddingTop;
  Inquiry(this.mediaQueryPaddingTop);
  @override
  _InquiryState createState() => _InquiryState();
}
class _InquiryState extends State<Inquiry> {




  @override

  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size);
    print(MediaQuery.of(context).padding);
    return Scaffold(
      body: Container(
          margin: EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
                Text(
                    "不具合等ございましたらご連絡ください。"
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 200,
                  height: 40,
                  child: ElevatedButton(
                    child: Text("お問い合わせをする"),
                    onPressed: () {
                      BuildContext mainContext = context;
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return CreateMessage(
                                widget.mediaQueryPaddingTop
                            );
                          });
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.green
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("問い合わせ履歴"),
                ),
                Messages(),
              ],
            ),
          )
      )
    );
  }
}

