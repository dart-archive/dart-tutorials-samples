// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'dart:async';

Future printDailyNewsDigest() async {
  try {
    String news = await gatherNewsReports();
    print(news);
  } catch (e) {
    // ... handle error ...
  }
}

void main() {
  printDailyNewsDigest();
  printWinningLotteryNumbers();
  printWeatherForecast();
  printBaseballScore();
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
Future gatherNewsReports() async {
  String path = 'https://www.dartlang.org/f/dailyNewsDigest.txt';
  String content = await HttpRequest.getString(path);
  return content;
}
