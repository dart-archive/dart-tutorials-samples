// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library dgrep;

import 'dart:io';
import 'package:args/args.dart';

const usage = 'usage: dart dgrep.dart [-rnS] patterns file_or_directory';
const recursive = 'recursive';
const lineNumber = 'line-number';
const followLinks = 'follow-links';

ArgResults argResults;

void printMatch(File file, List lines, int i) {
  final sb = StringBuffer();
  if (argResults[recursive]) sb.write('${file.path}:');
  if (argResults[lineNumber]) sb.write('${i + 1}:');
  sb.write(lines[i]);
  print(sb.toString());
}

Future searchFile(File file, List<String> searchTerms) async {
  try {
    var lines = await file.readAsLines();
    for (var i = 0; i < lines.length; i++) {
      var found = false;
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

Future main(List<String> arguments) async {
  final parser = ArgParser()
    ..addFlag(recursive, negatable: false, abbr: 'r')
    ..addFlag(lineNumber, negatable: false, abbr: 'n')
    ..addFlag(followLinks, negatable: false, abbr: 'S');

  argResults = parser.parse(arguments);

  if (argResults.rest.length < 2) {
    print(usage);
    exit(1);
  }

  final searchPath = argResults.rest.last;
  final searchTerms = argResults.rest.sublist(0, argResults.rest.length - 1);

  if (await FileSystemEntity.isDirectory(searchPath)) {
    final startingDir = Directory(searchPath);
    await for (var entity in startingDir.list(
        recursive: argResults[recursive],
        followLinks: argResults[followLinks])) {
      if (entity is File) {
        await searchFile(entity, searchTerms);
      } else {
        await searchFile(File(searchPath), searchTerms);
      }
    }
  } else {
    await searchFile(File(searchPath), searchTerms);
  }
}
