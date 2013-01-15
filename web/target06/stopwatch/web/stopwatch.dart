import 'dart:html';
import 'package:web_ui/watcher.dart' as watchers;

String counter='00:00';
Stopwatch mywatch = new Stopwatch();

ButtonElement stopButton;
ButtonElement startButton;
ButtonElement resetButton;

void main() {
  startButton = query("#startbutton");
  stopButton = query("#stopbutton");
  stopButton.disabled = true;
  resetButton = query("#resetbutton");
  resetButton.disabled = true;
}

void startwatch() {
  mywatch.start();
  window.setInterval(updateTime, 1000);
  startButton.disabled = true;
  stopButton.disabled = false;
  resetButton.disabled = true;
}

void stopwatch() {
  mywatch.stop();
  startButton.disabled = false;
  resetButton.disabled = false;
  stopButton.disabled = true;
}

void resetwatch() {
  mywatch.reset();
  counter = '00:00';
  resetButton.disabled = true;
}

void updateTime() {
  var s = mywatch.elapsedMilliseconds~/1000;
  var m = 0;
  
  if (s >= 60) { m = s ~/ 60; s = s % 60; }
    
  String minute = (m <= 9) ? '0$m' : '$m';
  String second = (s <= 9) ? '0$s' : '$s';
  counter = '$minute:$second';
  watchers.dispatch();
}