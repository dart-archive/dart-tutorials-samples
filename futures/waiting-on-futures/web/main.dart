// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

final output = querySelector('#output');

void main() {
  Future.wait([expensiveA(), expensiveB(), expensiveC()])
      .then((List responses) => chooseBestResponse(responses))
      .catchError((e) => handleError(e));
}

Future<String> expensiveA() => Future.value('from expensiveA');
Future<String> expensiveB() => Future.value('from expensiveB');
Future<String> expensiveC() => Future.value('from expensiveC');

void chooseBestResponse(List responses) {
  output.appendText(responses[1]);
}

void handleError(e) {
  output.appendText('handle error: $e');
}
