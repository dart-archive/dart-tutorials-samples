// Copyright (c) 2015, the Dart project authors.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';

Future<int> lastPositive(Stream<int> stream) async {
  var lastValue;
  await for (var value in stream) {
    if (value < 0) continue;
    lastValue = value;
  }
  return lastValue;
}

Future main() async {
  var data = [1, -2, 3, -4, 5, -6, 7, -8, 9, -10];
  var stream = Stream.fromIterable(data);
  var lastPos = await lastPositive(stream);
  print(lastPos); // 9
}
