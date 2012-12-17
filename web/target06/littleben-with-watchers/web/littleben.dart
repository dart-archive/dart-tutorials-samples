import 'dart:html';
import 'package:web_ui/watcher.dart' as watchers;

String currentTime;

void main() {
  window.setInterval(updateTime, 1000);
  updateTime();
}

void updateTime() {
  Date today = new Date.now();
  currentTime = formatTime(today.hour, today.minute, today.second);
  watchers.dispatch();
}

String formatTime(int h, int m, int s) {
  if (h > 12) { h = h - 12; }
  String minute = (m <= 9) ? '0$m' : '$m';
  String second = (s <= 9) ? '0$s' : '$s';
  return '$h:$minute:$second';
}