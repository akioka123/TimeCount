import 'dart:io';

import 'package:TimeCount/part/timeCountModel.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'part/const.dart';
import 'part/dbProvider.dart';
import 'part/sampleBloc.dart';
import 'part/timeCountBloc.dart';

void main() {
  runApp(TimeCountApp());
}

class TimeCountApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [const Locale("en", "US"), const Locale("ja", "JP")],
      title: 'TimeCountApp',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(title: 'Time Counter'),
    );
  }
}

class HomePage extends StatefulWidget {
  final String title;
  HomePage({Key key, this.title}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _startTime;
  DateTime _finishTime;
  String _title = "";
  final TextEditingController _textEditingController =
      new TextEditingController();

  @override
  void initState() {
    DBProvider.db.database;
    _textEditingController.addListener(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
          widget.title,
          style: TextStyle(fontSize: 30.0),
        )),
        body: Padding(
            padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  maxLength: 10,
                  maxLengthEnforced: false,
                  onChanged: _handleText,
                  controller: _textEditingController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '計測する行動を入力',
                      labelText: '行動'),
                ),
                _startTime != null
                    ? Text(DateFormat(DATETIME_FORMAT)
                        .format(_startTime)
                        .toString())
                    : Text(""),
                _finishTime != null
                    ? Text(DateFormat(DATETIME_FORMAT)
                        .format(_finishTime)
                        .toString())
                    : Text(""),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                        elevation: 16,
                        child: Text(
                          "START",
                        ),
                        textColor: ButtonTextColor,
                        color: ButtonBackColor,
                        onPressed: () {
                          _startTimeCount();
                        }),
                    Padding(padding: EdgeInsets.only(left: 50.0)),
                    RaisedButton(
                        elevation: 16,
                        child: Text(
                          "FINISH",
                        ),
                        textColor: ButtonTextColor,
                        color: ButtonBackColor,
                        onPressed: () {
                          _finishTimeCount();
                        }),
                  ],
                )
              ],
            )));
  }

  void _handleText(String title) {
    setState(() {
      _title = title;
    });
  }

  void _startTimeCount() {
    String now = DateTime.now().toUtc().toIso8601String();
    setState(() {
      _startTime = DateTime.parse(now).toLocal();
    });
    DBProvider.db.createTimeCount(TimeCount(
        title: _title,
        startTime: _startTime,
        updateDate: DateFormat(DATETIME_FORMAT).format(_startTime)));
  }

  void _finishTimeCount() async {
    String now = DateTime.now().toUtc().toIso8601String();
    _textEditingController.clear();
    setState(() {
      _finishTime = DateTime.parse(now).toLocal();
    });
    Duration delta = _finishTime.difference(_startTime);
    print(_title + ":" + delta.inMinutes.toString());
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      _finishTime = null;
      _startTime = null;
    });
  }
}
