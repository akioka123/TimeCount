import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class BOULD {
  String id;
  String yearMonth;
  String number;
  String attempt;
  String result;

  BOULD(
      {this.id,
      @required this.yearMonth,
      @required this.number,
      this.attempt,
      this.result});

  BOULD.newBOULD() {
    yearMonth = "";
    number = "";
  }

  assignUUID() {
    id = Uuid().v4();
  }

  factory BOULD.fromMap(Map<String, dynamic> json) => BOULD(
      id: json["id"],
      yearMonth: json["yearMonth"],
      number: json["number"],
      // DateTime型は文字列で保存されているため、DateTime型に変換し直す
      attempt: json["attempt"],
      result: json["result"]);

  Map<String, dynamic> toMap() => {
        "id": id,
        "yearMonth": yearMonth,
        "number": number,
        // sqliteではDate型は直接保存できないため、文字列形式で保存する
        "attempt": attempt,
        "result": result
      };
}
