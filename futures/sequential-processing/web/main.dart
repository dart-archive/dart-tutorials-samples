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

Future expensiveA() => Future.value('from expensiveA');
Future expensiveB() => Future.value('from expensiveB');
Future expensiveC() => Future.value('from expensiveC');

void doSomethingWith(value) {
  querySelector('#output').appendText(value);
}
