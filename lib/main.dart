import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:palmmemo/add_word.dart';
import 'package:palmmemo/constants.dart' as Const;
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
      title: Const.TITLE_PALM_MEMO,
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
  String meaning = Const.MSG_CLICK_SHOW;
  AudioPlayer audioPlayer;
  bool isLearned = false;

  @override
  void initState() {
    super.initState();

    audioPlayer = AudioPlayer();
    _loadWordList();
  }

  @override
  void dispose() {
    closeDb(getDatabase());
    super.dispose();
  }

  void _loadWordList() {
    getWords(getDatabase()).then((value) => {
          setState(() {
            // random list
            value.shuffle();
            print("size is ${value.length}");
            wordList = value;
          })
        });
  }

  // todo add done view
  void _nextWord() {
    if (wordList.isNullOrEmpty) {
      return;
    }

    setState(() {
      wordList.removeAt(0);
      meaning = Const.MSG_CLICK_SHOW;
      isLearned = true;
    });
  }

  void _addWord() async {
    // todo calc max radius
    final isAdded = await Navigator.push(
        context,
        RevealRoute(
            page: AddWordPage(),
            maxRadius: kIsWeb ? 4500 : 1500,
            centerAlignment: Alignment.bottomRight));

    if (isAdded) {
      _loadWordList();
    }
  }

  void _showAnswer() {
    setState(() {
      meaning = wordList[0].mean;
    });
  }

  void _speakWord() async {
    String audioUrl =
        'https://tts.baidu.com/text2audio?tex=${wordList[0].word}&cuid=baike&lan=ZH&ie=utf-8&ctp=1&pdt=301&vol=9&rate=32&per=5';
    await audioPlayer.play(audioUrl);
  }

  Widget cardWithTextView(String text, bool isWord) {
    return Card(
        color: isWord ? Colors.blue : Colors.green,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  .apply(color: Colors.white),
            ),
            isWord
                ? Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                        margin: EdgeInsets.all(20),
                        child: IconButton(
                            icon: Icon(Icons.volume_up, color: Colors.white),
                            onPressed: _speakWord)))
                : Container()
          ],
        ),
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ));
  }

  Widget answerCardView() {
    return Container(
        width: double.infinity,
        child: GestureDetector(
            onTap: _showAnswer, child: cardWithTextView(meaning, false)));
  }

  Widget wordCardView() {
    return Container(
        width: double.infinity,
        child: cardWithTextView(wordList[0].word, true));
  }

  Widget centerTextView(String text) {
    return Center(
        child: Text(text,
            style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 20)));
  }

  Widget emptyView() {
    return centerTextView("Click add button to add your word");
  }

  Widget doneView() {
    return centerTextView("Congratulations, you're done");
  }

  Widget memoView() {
    return Column(children: <Widget>[
      Expanded(child: wordCardView(), flex: 1),
      Expanded(child: answerCardView(), flex: 1)
    ]);
  }

  void onEventKey(RawKeyEvent event) async {
    if (event.runtimeType.toString() == 'RawKeyDownEvent') {
      if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
        _nextWord();
      }
      if (event.isKeyPressed(LogicalKeyboardKey.space)) {
        _showAnswer();
      }
      if (event.isKeyPressed(LogicalKeyboardKey.comma)) {
        _speakWord();
      }
    }
  }

  Widget mainView() {
    if (wordList.isNullOrEmpty) {
      if (isLearned) {
        return doneView();
      } else {
        return emptyView();
      }
    } else {
      return memoView();
    }
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
        body: RawKeyboardListener(
          focusNode: FocusNode(),
          onKey: onEventKey,
          autofocus: true,
          child: mainView(),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: _addWord,
            backgroundColor: Colors.green,
            child: Icon(Icons.add)));
  }
}
