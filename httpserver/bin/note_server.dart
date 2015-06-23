// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Client program is note_client.dart.
// Use note_taker.html to run the client.

import 'dart:io';
import 'dart:async';
import 'dart:convert' show UTF8, JSON;

int count = 0;

main() async {
  // One note per line.
  try {
    List<String> lines = new File('notes.txt').readAsLinesSync();
    count = lines.length;

    var server =
        await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 4042);
    print('Listening for requests on 4042.');
    await listenForRequests(server);
  } on FileSystemException {
    print('Could not open notes.txt');
  } catch (e) {
    print('hello: ${e.toString()}');
  }
}

Future listenForRequests(HttpServer requests) async {
  try {
    await for (HttpRequest request in requests) {
      switch (request.method) {
        case 'POST':
          handlePost(request);
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
  } catch (e) {
    print(e.toString());
  }
}

handlePost(HttpRequest request) async {
  addCorsHeaders(request.response);

  try {
    var decoded = await request
        .transform(UTF8.decoder.fuse(JSON.decoder)).first;

    if (decoded.containsKey('myNote')) {
      saveNote(request, '${decoded["myNote"]}\n');
    } else {
      getNote(request, decoded['getNote']);
    }
  } catch (e) {
    print('Request listen error: $e');
  }
}

saveNote(HttpRequest request, String myNote) {
  try {
    new File('notes.txt').writeAsStringSync(myNote,
        mode: FileMode.APPEND);
    count++;
    request.response
      ..statusCode = HttpStatus.OK
      ..writeln('You have $count notes.')
      ..close();
  } catch (e) {
    print('Couldn\'t open notes.txt: $e');
    request.response
      ..statusCode = HttpStatus.INTERNAL_SERVER_ERROR
      ..writeln('Couldn\'t save note.')
      ..close();
  }
}

getNote(HttpRequest request, String getNote) {
  int requestedNote = int.parse(getNote, onError: (_) {
    print('error');
  });
  if (requestedNote == null) {
    requestedNote = 0;
  }
  if (requestedNote >= 0 && requestedNote < count) {
    List<String> lines = new File('notes.txt').readAsLinesSync();
    request.response
      ..statusCode = HttpStatus.OK
      ..writeln(lines[requestedNote])
      ..close();
  }
}

void defaultHandler(HttpRequest request) {
  HttpResponse response = request.response;
  addCorsHeaders(response);
  response
    ..statusCode = HttpStatus.NOT_FOUND
    ..write('Not found: ${request.method}, ${request.uri.path}')
    ..close();
}

void handleOptions(HttpRequest request) {
  HttpResponse response = request.response;
  addCorsHeaders(response);
  print('${request.method}: ${request.uri.path}');
  response
    ..statusCode = HttpStatus.NO_CONTENT
    ..close();
}

void addCorsHeaders(HttpResponse response) {
  response.headers.add('Access-Control-Allow-Origin', '*');
  response.headers.add(
      'Access-Control-Allow-Methods', 'POST, OPTIONS');
  response.headers.add('Access-Control-Allow-Headers',
      'Origin, X-Requested-With, Content-Type, Accept');
}
