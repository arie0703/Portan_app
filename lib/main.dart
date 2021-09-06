import 'package:flutter/material.dart';
import 'package:por_app/Quiz/QuizStatus.dart';
import 'package:por_app/Words/MyWords.dart';
import 'package:por_app/Books/MyBooks.dart';
import 'package:por_app/Books/CreateBook.dart';
import 'package:por_app/Words/AllWords.dart';
import 'package:por_app/Quiz/ModeSelection.dart';
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
        accentColor: Colors.green,
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
  int _selectedNavContent = 0;
  int _selectedPage = 0;

  static List<Widget> _pageList = <Widget>[
    AllWords(),
    MyBooks(),
    ModeSelection(),
    MyWords(),
  ];

  static List<Widget> _titleList = <Widget> [
    Text("みんなの単語"),
    Text("単語帳"),
    Text("クイズ"),
    Text("My単語"),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedPage = index;
      if (index < 3) {
        _selectedNavContent = index;
      }
    });
  }


  @override
  void initState() {
    getDeviceUniqueId();
  }
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: _titleList[_selectedPage],
        actions: [
          if(_selectedPage == 0 || _selectedPage == 3)
            IconButton(
              icon: const Icon(Icons.help),
              tooltip: 'ヒント',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: Text("ヒント"),
                      content: Container(
                        height: 130,
                        child: Column(
                          children: [
                            Text("単語カードをタップするとポルトガル語と日本語の表示が切り替わります。"),
                            Text("長押しすると、単語カードを単語帳に追加することができます。"),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text("OK"),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          if(_selectedPage == 1)
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: '単語帳を追加',
              onPressed: () {
                showModalBottomSheet(
                    backgroundColor: Colors.black12,
                    context: context,
                    builder: (BuildContext context) {
                      return CreateBook();
                    });
              },
            ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget> [
            ListTile(
              title: Text("My単語"),
              trailing: Icon(Icons.person),
              onTap: () {
                _onItemTapped(3);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("みんなの単語"),
              trailing: Icon(Icons.list),
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("単語帳"),
              trailing: Icon(Icons.book),
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("クイズ"),
              trailing: Icon(Icons.quiz),
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
          ]
        )
      ),
      body: ChangeNotifierProvider(
        create: (BuildContext context) => QuizStatus(),
        child: Center(
          child: _pageList.elementAt(_selectedPage),
        ),
      ),

      floatingActionButton: Visibility(
        visible: (_selectedPage == 0),
        child: FloatingActionButton(
          onPressed: () async {
            showModalBottomSheet(
                backgroundColor: Colors.black12,
                context: context,
                builder: (BuildContext context) {
                  return CreateWord();
                });
          },
          tooltip: '単語を追加',
          child: Icon(Icons.add),
        ),
      ),

      bottomNavigationBar: Visibility(
        visible: (_selectedPage < 3),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'みんなの単語',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: '単語帳',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.quiz),
              label: 'クイズ',
            ),
          ],
          currentIndex: _selectedNavContent,
          selectedItemColor: Colors.lightGreenAccent,
          onTap: _onItemTapped,
        ),
      )// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
