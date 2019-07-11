// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Client program is note_client.dart.
// Use note_taker.html to run the client.

import 'dart:async';
import 'dart:convert' show utf8, json;
import 'dart:io';

import 'package:path/path.dart' as p;

int count = 0;

Future main() async {
  Directory.current = p.dirname(Platform.script.toFilePath());

  // One note per line.
  try {
    final lines = File('notes.txt').readAsLinesSync();
    count = lines.length;
  } on FileSystemException {
    print('Could not open notes.txt.');
    return;
  }

  var server = await HttpServer.bind(InternetAddress.loopbackIPv4, 4042);
  print('Listening on http://${server.address.address}:${server.port}/');
  await listenForRequests(server);
}

Future listenForRequests(HttpServer requests) async {
  await for (HttpRequest request in requests) {
    switch (request.method) {
      case 'POST':
        await handlePost(request);
        break;
      case 'OPTION':
        handleOptions(request);
        break;
      default:
        defaultHandler(request);
        break;
    }
  }
  print('No more requests.');
}

Future handlePost(HttpRequest request) async {
  Map decoded;

  addCorsHeaders(request.response);

  try {
    decoded =
        await utf8.decoder.bind(request).transform(json.decoder).first as Map;
  } catch (e) {
    print('Request listen error: $e');
    return;
  }

  if (decoded.containsKey('myNote')) {
    saveNote(request, "${decoded['myNote']}\n");
  } else {
    getNote(request, decoded['getNote'] as String);
  }
}

void saveNote(HttpRequest request, String myNote) {
  try {
    File('notes.txt').writeAsStringSync(myNote, mode: FileMode.append);
  } catch (e) {
    print('Couldn\'t open notes.txt: $e');
    request.response
      ..statusCode = HttpStatus.internalServerError
      ..writeln('Couldn\'t save note.')
      ..close();
    return;
  }

  count++;
  request.response
    ..statusCode = HttpStatus.ok
    ..writeln('You have $count notes.')
    ..close();
}

void getNote(HttpRequest request, String getNote) {
  final requestedNote = int.tryParse(getNote) ?? 0;
  if (requestedNote >= 0 && requestedNote < count) {
    final lines = File('notes.txt').readAsLinesSync();
    request.response
      ..statusCode = HttpStatus.ok
      ..writeln(lines[requestedNote])
      ..close();
  }
}

void defaultHandler(HttpRequest request) {
  final response = request.response;
  addCorsHeaders(response);
  response
    ..statusCode = HttpStatus.notFound
    ..write('Not found: ${request.method}, ${request.uri.path}')
    ..close();
}

void handleOptions(HttpRequest request) {
  final response = request.response;
  addCorsHeaders(response);
  print('${request.method}: ${request.uri.path}');
  response
    ..statusCode = HttpStatus.noContent
    ..close();
}

void addCorsHeaders(HttpResponse response) {
  response.headers.add('Access-Control-Allow-Origin', '*');
  response.headers.add('Access-Control-Allow-Methods', 'POST, OPTIONS');
  response.headers.add('Access-Control-Allow-Headers',
      'Origin, X-Requested-With, Content-Type, Accept');
}
