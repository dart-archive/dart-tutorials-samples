// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

printDailyNewsDigest() {
  var future = gatherNewsReports();
  future.then((content) => print(content));
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

// Imagine that this function is more complex and slow. :)
gatherNewsReports() {
  String path =
      'https://www.dartlang.org/f/dailyNewsDigest.txt';
  return HttpRequest.getString(path);
}
