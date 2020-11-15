import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:palmmemo/add_word.dart';
import 'package:palmmemo/database.dart';
import 'package:palmmemo/extension.dart';
import 'package:palmmemo/model/word.dart';
import 'package:palmmemo/revel_route.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Palm Memo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Palm Memo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({this.title}) : super();

  final String title;

  @override
  State createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Word> wordList;

  @override
  void initState() {
    super.initState();

    getWords(getDatabase()).then((value) => {
          setState(() {
            // random list
            value.shuffle();
            wordList = value;
          })
        });
  }

  @override
  void dispose() {
    closeDb(getDatabase());
    super.dispose();
  }

  // todo add done view
  void _nextWord() {
    if (wordList.isNullOrEmpty) {
      return;
    }

    setState(() {
      wordList.removeAt(0);
    });
  }

  void _addWord() {
    // todo calc max radius
    Navigator.push(
        context,
        RevealRoute(
            page: AddWordPage(),
            maxRadius: kIsWeb ? 4500 : 1500,
            centerAlignment: Alignment.bottomRight));
  }

  Widget wordCardView(String text, bool isAnswer) {
    return Container(
        width: double.infinity,
        child: Card(
            color: isAnswer ? Colors.blue : Colors.green,
            child: Center(
                child: Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  .apply(color: Colors.white),
            )),
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            )));
  }

  Widget emptyView() {
    return Center(
        child: Text("Current no word in list, click add button to add word"));
  }

  Widget memoView() {
    return Column(children: <Widget>[
      Expanded(child: wordCardView(wordList[0].word, false), flex: 1),
      Expanded(child: wordCardView(wordList[0].mean, true), flex: 1)
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title), actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.navigate_next,
                color: Colors.white,
              ),
              onPressed: _nextWord)
        ]),
        body: wordList.isNullOrEmpty ? emptyView() : memoView(),
        floatingActionButton: FloatingActionButton(
            onPressed: _addWord,
            backgroundColor: Colors.green,
            child: Icon(Icons.add)));
  }
}
