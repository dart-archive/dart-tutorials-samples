// Copyright (c) 2015, the Dart project authors.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';

Future<int> sumStream(Stream<int> stream) async {
  var sum = 0;
  try {
    await for (var value in stream) {
      sum += value;
    }
  } catch (error) {
    return -1;
  }
  return sum;
}

Stream<int> countStream(int to) async* {
  for (var i = 1; i <= to; i++) {
    if (i == 4) {
      // ignore: only_throw_errors
      throw "Whoops!"; // Intentional error
    } else {
      yield i;
    }
  }
}

Future main() async {
  var stream = countStream(10);
  var sum = await sumStream(stream);
  print(sum); // -1
}
