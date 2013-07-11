import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';
import 'package:observe/observe.dart';

class TuteStopwatch extends PolymerElement with ObservableMixin {
  @observable String counter='00:00';
  
  Stopwatch mywatch = new Stopwatch();
  
  ButtonElement stopButton;
  ButtonElement startButton;
  ButtonElement resetButton;
  
  void inserted() {
    startButton = getShadowRoot("tute-stopwatch").query('.startbutton');
    stopButton = getShadowRoot("tute-stopwatch").query('.stopbutton');
    resetButton = getShadowRoot("tute-stopwatch").query('.resetbutton');
        
    stopButton.disabled = true;
    resetButton.disabled = true;
  }
  
  void startwatch(Event e, var detail, Node target) {
    print("hello");
    mywatch.start();
    var oneSecond = new Duration(seconds:1);
    new Timer.periodic(oneSecond, updateTime);
    startButton.disabled = true;
    stopButton.disabled = false;
    resetButton.disabled = true;
  }
  
  void stopwatch(Event e, var detail, Node target) {
    mywatch.stop();
    startButton.disabled = false;
    resetButton.disabled = false;
    stopButton.disabled = true;
  }
  
  void resetwatch(Event e, var detail, Node target) {
    mywatch.reset();
    counter = '00:00';
    resetButton.disabled = true;
  }
  
  void updateTime(Timer _) {
    var s = mywatch.elapsedMilliseconds~/1000;
    var m = 0;
    
    if (s >= 60) { m = s ~/ 60; s = s % 60; }
      
    String minute = (m <= 9) ? '0$m' : '$m';
    String second = (s <= 9) ? '0$s' : '$s';
    counter = '$minute:$second';
  }
}