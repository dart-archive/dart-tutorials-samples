// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'dart:async';

void printDailyNewsDigest() {
  Future future = gatherNewsReports();
  future.then((content) => print(content)).catchError((e) => handleError(e));
}

void main() {
  printDailyNewsDigest();
  printWinningLotteryNumbers();
  printWeatherForecast();
  printBaseballScore();
}

void handleError(e) {
  print('handleError');
}

void printWinningLotteryNumbers() {
  print('Winning lotto numbers: [23, 63, 87, 26, 2]');
}

void printWeatherForecast() {
  print('Tomorrow\'s forecast: 70F, sunny.');
}

void printBaseballScore() {
  print('Baseball score: Red Sox 10, Yankees 0');
}

// Imagine that this function is more complex and slow. :)
Future gatherNewsReports() {
  String path = 'https://www.dartlang.org/f/dailyNewsDigest.txt';
  return HttpRequest.getString(path);
}
