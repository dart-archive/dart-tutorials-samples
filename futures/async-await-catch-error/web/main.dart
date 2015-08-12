// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'dart:async';

Future printDailyNewsDigest() async {
  String path =
      'https://www.dartlang.org/samples-files/dailyNewsDigest.txt';
  try {
    String content = await HttpRequest.getString(path);
    print(content);
  } catch (e) {
    // ... handle error ...
  }
}

main() {
  printDailyNewsDigest();
  printWinningLotteryNumbers();
  printWeatherForecast();
  printBaseballScore();
}

printWinningLotteryNumbers() {
  print('Winning lotto numbers: [23, 63, 87, 26, 2]');
}

printWeatherForecast() {
  print('Tomorrow\'s forecast: 70F, sunny.');
}

printBaseballScore() {
  print('Baseball score: Red Sox 10, Yankees 0');
}
