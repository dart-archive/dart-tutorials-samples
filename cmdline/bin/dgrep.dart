// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library dgrep;

import 'dart:io';
import 'package:args/args.dart';
import 'dart:async';

const USAGE =
    'usage: dart dgrep.dart [-rnS] patterns file_or_directory';
const RECURSIVE = 'recursive';
const LINE_NUMBER = 'line-number';
const FOLLOW_LINKS = 'follow-links';

ArgResults argResults;

void printMatch(File file, List lines, int i) {
  StringBuffer sb = new StringBuffer();
  if (argResults[RECURSIVE]) sb.write('${file.path}:');
  if (argResults[LINE_NUMBER]) sb.write('${i + 1}:');
  sb.write(lines[i]);
  print(sb.toString());
}

Future searchFile(File file, searchTerms) async {
  try {
    var lines = await file.readAsLines();
    for (var i = 0; i < lines.length; i++) {
      bool found = false;
      for (var j = 0; j < searchTerms.length && !found; j++) {
        if (lines[i].contains(searchTerms[j])) {
          printMatch(file, lines, i);
          found = true;
        }
      }
    }
  } catch (e) {
    print(e);
  }
}

main(List<String> arguments) async {
  final parser = new ArgParser()
    ..addFlag(RECURSIVE, negatable: false, abbr: 'r')
    ..addFlag(LINE_NUMBER, negatable: false, abbr: 'n')
    ..addFlag(FOLLOW_LINKS, negatable: false, abbr: 'S');

  argResults = parser.parse(arguments);

  if (argResults.rest.length < 2) {
    print(USAGE);
    exit(1);
  }

  final searchPath = argResults.rest.last;
  final searchTerms =
      argResults.rest.sublist(0, argResults.rest.length - 1);

  if (await FileSystemEntity.isDirectory(searchPath)) {
    final startingDir = new Directory(searchPath);
    await for (var entity in startingDir.list(
        recursive: argResults[RECURSIVE],
        followLinks: argResults[FOLLOW_LINKS])) {
      if (entity is File) {
        searchFile(entity, searchTerms);
      }
    }
  } else {
    searchFile(new File(searchPath), searchTerms);
  }
}
