import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:palmmemo/constants.dart' as Const;
import 'package:palmmemo/extension.dart';
import 'package:flutter/services.dart';

var wordController;
var meanController;

class AddWordPage extends StatefulWidget {
  @override
  _AddWordState createState() => _AddWordState();
}

class _AddWordState extends State<AddWordPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isAdded = false;

  void _showSuccess() {
    final snackBar = SnackBar(content: Text('Add Success'));
    _scaffoldKey.currentState.showSnackBar(snackBar);

    isAdded = true;
  }

  void _showError(String error) {
    final snackBar = SnackBar(content: Text("Failed to add user: $error"));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void _addWord() {
    CollectionReference words =
        FirebaseFirestore.instance.collection(Const.DATABASE_NAME);
    words
        .add({
          Const.COLUMN_WORD: wordController.text,
          Const.COLUMN_MEAN: meanController.text
        })
        .then((value) => _showSuccess())
        .catchError((error) => _showError(error));
  }

  void _onAddPressed() {
    String word = wordController.text;
    String mean = meanController.text;

    if (word.isEmpty || mean.isEmpty) {
      return;
    }

    _addWord();
  }

  void onEventKey(RawKeyEvent event) async {
    if (event.runtimeType.toString() == 'RawKeyDownEvent') {
      if (event.isKeyPressed(LogicalKeyboardKey.tab)) {
        context.nextEditableTextFocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop(isAdded);
          return true;
        },
        child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text(Const.TITLE_ADD_WORD),
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(isAdded),
              ),
            ),
            body: RawKeyboardListener(
                focusNode: FocusNode(),
                onKey: onEventKey,
                autofocus: true,
                child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    // color: Color.fromRGBO(0, 184, 67, 1),
                    color: Colors.white,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          WordForm(),
                          MeanForm(),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                            child: FlatButton(
                              onPressed: _onAddPressed,
                              child: Text('Add',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .apply(color: Colors.blue)),
                            ),
                          )
                        ])))));
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
          textInputAction: TextInputAction.next,
          onEditingComplete: () => context.nextEditableTextFocus(),
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
