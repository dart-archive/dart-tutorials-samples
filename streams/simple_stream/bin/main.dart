// Copyright (c) 2015, the Dart project authors.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';

Future<int> sumStream(Stream<int> stream) async {
  var sum = 0;
  await for (var value in stream) {
    sum += value;
  }
  return sum;
}

Stream<int> countStream(int to) async* {
  for (var i = 1; i <= to; i++) {
    yield i;
  }
}

Future main() async {
  var stream = countStream(10);
  var sum = await sumStream(stream);
  print(sum); // 55
}
