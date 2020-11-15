import 'package:flutter/material.dart';
import 'package:palmmemo/database.dart';
import 'package:palmmemo/model/word.dart';

var wordController;
var meanController;

class AddWordPage extends StatefulWidget {
  @override
  _AddWordState createState() => _AddWordState();
}

class _AddWordState extends State<AddWordPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onAddPressed() {
    String word = wordController.text;
    String mean = meanController.text;

    if (word.isEmpty || mean.isEmpty) {
      return;
    }

    insertWord(getDatabase(), Word(word, mean));

    final snackBar = SnackBar(content: Text('Add Success'));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  void dispose() {
    super.dispose();
    closeDb(getDatabase());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Palm Memo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(title: Text('Add Word')),
            body: Container(
                width: double.infinity,
                height: double.infinity,
                color: Color.fromRGBO(0, 184, 67, 1),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      WordForm(),
                      MeanForm(),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
                        child: FlatButton(
                          onPressed: _onAddPressed,
                          textColor: Colors.white,
                          color: Colors.blue,
                          child: Text("ADD"),
                        ),
                      )
                    ]))));
  }
}

class WordForm extends StatefulWidget {
  @override
  _WordFormState createState() => _WordFormState();
}

class _WordFormState extends State<WordForm> {
  @override
  void initState() {
    wordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    wordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          decoration: new InputDecoration(
              border: new OutlineInputBorder(
                  borderSide: new BorderSide(color: Colors.teal)),
              labelText: "word",
              hintText: "enter your word"),
          controller: wordController,
        ));
  }
}

class MeanForm extends StatefulWidget {
  @override
  _MeanFormState createState() => _MeanFormState();
}

class _MeanFormState extends State<MeanForm> {
  @override
  void initState() {
    meanController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    meanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          decoration: new InputDecoration(
              border: new OutlineInputBorder(
                  borderSide: new BorderSide(color: Colors.teal)),
              labelText: "word meaning",
              hintText: "enter word meaning"),
          controller: meanController,
        ));
  }
}
