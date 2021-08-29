import 'package:flutter/material.dart';
import 'package:por_app/Quiz/QuizStatus.dart';
import 'package:por_app/Words/MyWords.dart';
import 'package:por_app/Books/MyBooks.dart';
import 'package:por_app/MyPage.dart';
import 'package:por_app/Quiz/Quiz.dart';
import 'package:por_app/Words/CreateWord.dart';
import 'package:por_app/getDeviceInfoFunc.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QuizStatus()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PorTan ポル単',
      // theme: ThemeData.light(),
      // darkTheme: ThemeData.dark(),
      // themeMode: ThemeMode.system, // 本体設定によってテーマを切り替える

      theme: ThemeData(
        brightness: Brightness.dark, // ダークモード
        primaryColor: Colors.black,
        accentColor: Colors.orangeAccent,
      ),

      home: MyHomePage(title: '単語帳'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static List<Widget> _pageList = <Widget>[
    MyWords(),
    MyBooks(),
    Quiz(),
    MyPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }







  @override
  void initState() {
    getDeviceUniqueId();
  }
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget> [
            ListTile(
              title: Text("マイページ"),
              trailing: Icon(Icons.person),
              onTap: () {
                _onItemTapped(3);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("My単語"),
              trailing: Icon(Icons.book),
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("単語帳"),
              trailing: Icon(Icons.list),
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("単語クイズ"),
              trailing: Icon(Icons.quiz),
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("トークルーム"),
              trailing: Icon(Icons.question_answer),
              // onTap: () {
              //   _onItemTapped();
              //   Navigator.pop(context);
              // },
            ),
          ]
        )
      ),
      body: ChangeNotifierProvider(
        create: (BuildContext context) => QuizStatus(),
        child: Center(
          child: _pageList.elementAt(_selectedIndex),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showModalBottomSheet(
            //モーダルの背景の色、透過
              backgroundColor: Colors.black12,
              //ドラッグ可能にする（高さもハーフサイズからフルサイズになる様子）
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                return CreateWord();
              });
          // ドキュメント作成
          // await Firestore.instance
          //     .collection('words') // コレクションID
          //     .document('example') // ドキュメントID
          //     .setData({'japanese': 'テスト', 'portuguese': "test", 'created_at': DateTime.now()}); // データ
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'MY単語',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: '単語帳',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz),
            label: 'クイズ',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
