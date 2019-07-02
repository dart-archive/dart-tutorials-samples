// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

void main() {
  expensiveA()
      .then((aValue) => expensiveB())
      .then((bValue) => expensiveC())
      .then((cValue) => doSomethingWith(cValue));
}

Future<String> expensiveA() => Future.value('from expensiveA');
Future<String> expensiveB() => Future.value('from expensiveB');
Future<String> expensiveC() => Future.value('from expensiveC');

void doSomethingWith(value) {
  querySelector('#output').appendText(value);
}
