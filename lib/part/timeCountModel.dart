import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class TimeCount {
  String id;
  String title;
  DateTime startTime;
  DateTime finishTime;
  int deltaMinute;
  String updateDate;

  TimeCount(
      {this.id,
      @required this.title,
      @required this.startTime,
      this.finishTime,
      this.deltaMinute,
      @required this.updateDate});

  TimeCount.newTimeCount() {
    title = "";
    startTime = DateTime.now();
    updateDate = DateTime.now().toLocal().toString();
  }

  assignUUID() {
    id = Uuid().v4();
  }

  factory TimeCount.fromMap(Map<String, dynamic> json) => TimeCount(
      id: json["id"],
      title: json["title"],
      startTime: DateTime.parse(json["startTime"]).toLocal(),
      // DateTime型は文字列で保存されているため、DateTime型に変換し直す
      finishTime: DateTime.parse(json["finishTime"]).toLocal(),
      deltaMinute: json["deltaMinute"],
      updateDate: json["updateDate"]);

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "startTime": startTime.toLocal().toString(),
        // sqliteではDate型は直接保存できないため、文字列形式で保存する
        "finishTime": finishTime.toLocal().toString(),
        "deltaMinute": deltaMinute,
        "updateDate": updateDate
      };
}
