// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
@HtmlImport('tute_stopwatch.html')
library tute_stopwatch;

import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart' show HtmlImport;

@PolymerRegister('tute-stopwatch')
class TuteStopwatch extends PolymerElement {

  @Property(observer: 'updateTime')
  String counter = '00:00';

  TuteStopwatch.created() : super.created();

  Stopwatch mywatch = new Stopwatch();
  Timer mytimer;

  ButtonElement stopButton;
  ButtonElement startButton;
  ButtonElement resetButton;

  @override
  void attached() {
    super.attached();
    startButton = $['startButton'];
    stopButton = $['stopButton'];
    resetButton = $['resetButton'];

    stopButton.disabled = true;
    resetButton.disabled = true;
  }

  @override
  void detached() {
    super.detached();
    mytimer.cancel();
  }

  @reflectable
  void start([_, __]) {
    mywatch.start();
    var oneSecond = new Duration(seconds:1);
    mytimer = new Timer.periodic(oneSecond, updateTime);
    startButton.disabled = true;
    stopButton.disabled = false;
    resetButton.disabled = true;
  }

  @reflectable
  void stop([_, __]) {
    mywatch.stop();
    mytimer.cancel();
    startButton.disabled = false;
    resetButton.disabled = false;
    stopButton.disabled = true;
  }

  @reflectable
  void reset([_, __]) {
    mywatch.reset();
    counter = '00:00';
    notifyPath('counter', counter);
    resetButton.disabled = true;
  }

  @reflectable
  void updateTime([_, __]) {
    var s = mywatch.elapsedMilliseconds ~/ 1000;
    var m = 0;

    // The operator ~/ divides and returns an integer.
    if (s >= 60) {
      m = s ~/ 60;
      s = s % 60;
    }

    String minute = (m <= 9) ? '0$m' : '$m';
    String second = (s <= 9) ? '0$s' : '$s';
    counter = '$minute:$second';
    notifyPath('counter', counter);
  }
}
