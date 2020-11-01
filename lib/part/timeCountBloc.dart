import 'dart:async';

import 'package:bloc/bloc.dart';

import 'dbProvider.dart';
import 'timeCountModel.dart';

class TimeCountBloc {
  final _timeCountController = StreamController<List<TimeCount>>();
  Stream<List<TimeCount>> get timeCountStream => _timeCountController.stream;

  getTimeCounts() async {
    _timeCountController.sink.add(await DBProvider.db.getAllTimeCounts());
  }

  TimeCountBloc() {
    getTimeCounts();
  }

  dispose() {
    _timeCountController.close();
  }

  create(TimeCount timeCount) {
    timeCount.assignUUID();
    DBProvider.db.createTimeCount(timeCount);
    getTimeCounts();
  }

  update(TimeCount timeCount) {
    DBProvider.db.updateTimeCount(timeCount);
    getTimeCounts();
  }

  delete(String id) {
    DBProvider.db.deleteTimeCount(id);
    getTimeCounts();
  }
}
