// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library dcat;

import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';

const lineNumber = 'line-number';

ArgResults argResults;

/// Simple implementation of the *nix cat utility.
///
/// Usage: dart dcat.dart [-n] patterns files
///
/// `dcat` reads `files` sequentially, writing them to standard output. The
/// file operands are processed in command-line order.
/// If `files` is absent, `dcat` reads from the standard input until `EOF`.
///
/// Unlike the *nix `cat`, `dcat` does not support single dash ('-') arguments.

void main(List<String> arguments) {
  exitCode = 0; //presume success
  final parser = ArgParser()..addFlag(lineNumber, negatable: false, abbr: 'n');

  argResults = parser.parse(arguments);
  final paths = argResults.rest;

  dcat(paths, argResults[lineNumber]);
}

Future dcat(List<String> paths, bool showLineNumbers) async {
  if (paths.isEmpty) {
    // No files provided as arguments. Read from stdin and print each line.
    await stdin.pipe(stdout);
  } else {
    for (var path in paths) {
      var lineNumber = 1;
      final lines = utf8.decoder
          .bind(File(path).openRead())
          .transform(const LineSplitter());
      try {
        await for (var line in lines) {
          if (showLineNumbers) {
            stdout.write('${lineNumber++} ');
          }
          stdout.writeln(line);
        }
      } catch (_) {
        await _handleError(path);
      }
    }
  }
}

Future _handleError(String path) async {
  if (await FileSystemEntity.isDirectory(path)) {
    stderr.writeln('error: $path is a directory');
  } else {
    exitCode = 2;
  }
}
