import 'package:flutter/material.dart';
import 'package:por_app/Inquiry/CreateMessage.dart';
import 'package:por_app/Inquiry/Messages.dart';
// import 'package:url_launcher/url_launcher.dart';
// メーラーでお問い合わせできるようにもしたい（一旦保留）

class Inquiry extends StatefulWidget {
  @override
  _InquiryState createState() => _InquiryState();
}
class _InquiryState extends State<Inquiry> {

  Widget build(BuildContext context) {
    return Container(
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
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return CreateMessage();

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
    );
  }
}