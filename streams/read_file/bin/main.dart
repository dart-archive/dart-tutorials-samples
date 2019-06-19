// Copyright (c) 2015, the Dart project authors.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:async';
import 'dart:convert';

Future main(List<String> args) async {
  if (args.isEmpty) {
    print("Requires a filepath as the first argument");
    return;
  }

  var file = new File(args[0]);
  var lines =
      file.openRead().transform(utf8.decoder).transform(const LineSplitter());
  await for (var line in lines) {
    if (!line.startsWith('#')) {
      print(line);
    }
  }
}
