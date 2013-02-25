import 'dart:async';
import 'package:web_ui/watcher.dart' as watchers;

String currentTime;

void main() {
  var oneSecond = new Duration(seconds:1);
  var timer = new Timer.repeating(oneSecond, updateTime);
  updateTime(timer);
}

void updateTime(Timer t) {
  DateTime today = new DateTime.now();
  currentTime = formatTime(today.hour, today.minute, today.second);
  watchers.dispatch();
}

String formatTime(int h, int m, int s) {
  if (h > 12) { h = h - 12; }
  String minute = (m <= 9) ? '0$m' : '$m';
  String second = (s <= 9) ? '0$s' : '$s';
  return '$h:$minute:$second';
}