import 'dart:async';
import 'package:polymer/polymer.dart';
import 'dart:html';

void main() {
  query("#currenttime").model = new CurrentTime();;
}

class CurrentTime extends ObservableBase { 
  @observable String currentTime = 'Hello!';

  CurrentTime() {
    var oneSecond = new Duration(seconds:1);
    new Timer.periodic(oneSecond, updateTime);
    updateTime(null);
  }
  
  void updateTime(Timer _) {
    DateTime today = new DateTime.now();
    currentTime = formatTime(today.hour, today.minute, today.second);
    Observable.dirtyCheck();
  }
  
  String formatTime(int h, int m, int s) {
    if (h > 12) { h = h - 12; }
    String minute = (m <= 9) ? '0$m' : '$m';
    String second = (s <= 9) ? '0$s' : '$s';
    return '$h:$minute:$second';
  }
}
