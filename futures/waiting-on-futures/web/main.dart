// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

void main() {
  Future
      .wait([expensiveA(), expensiveB(), expensiveC()])
      .then((List responses) => chooseBestResponse(responses))
      .catchError((e) => handleError(e));
}

Future expensiveA() => new Future.value('from expensiveA');
Future expensiveB() => new Future.value('from expensiveB');
Future expensiveC() => new Future.value('from expensiveC');

void doSomethingWith(value) {
  print(value);
}

void chooseBestResponse(List responses) {
  print(responses[1]);
}

void handleError(e) {
  print('error handled');
}
