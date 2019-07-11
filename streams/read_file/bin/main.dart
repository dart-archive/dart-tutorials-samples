// Copyright (c) 2015, the Dart project authors.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

Future main(List<String> args) async {
  if (args.isEmpty) {
    print("Requires a filepath as the first argument");
    return;
  }

  var file = File(args[0]);
  var lines =
      utf8.decoder.bind(file.openRead()).transform(const LineSplitter());
  await for (var line in lines) {
    if (!line.startsWith('#')) {
      print(line);
    }
  }
}
