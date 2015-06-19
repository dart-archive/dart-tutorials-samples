// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Client program is note_client.dart.
// Use note_taker.html to run the client.

import 'dart:io';
import 'dart:async';
import 'dart:convert' show JSON;

int count = 0;

main() async {
  // One note per line.
  try {
    List<String> lines = new File('notes.txt').readAsLinesSync();
    count = lines.length;
    
    var server = await HttpServer
      .bind(InternetAddress.LOOPBACK_IP_V4, 4042);
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
  StringBuffer data = new StringBuffer();

  addCorsHeaders(request.response);

  try {
    await for (var buffer in request) {
      data.write(new String.fromCharCodes(buffer));
    }
    
    var decoded = JSON.decode(data.toString());
  
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
    request.response.statusCode = HttpStatus.OK;
    request.response.writeln('You have $count notes.');
    request.response.close();
  } catch (e) {
    print('Couldn\'t open notes.txt: $e');
    request.response.statusCode = HttpStatus.INTERNAL_SERVER_ERROR;
    request.response.writeln('Couldn\'t save note.');
    request.response.close();
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
    request.response.statusCode = HttpStatus.OK;
    request.response.writeln(lines[requestedNote]);
    request.response.close();
  }
}

void defaultHandler(HttpRequest request) {
  HttpResponse response = request.response;
  addCorsHeaders(response);
  response.statusCode = HttpStatus.NOT_FOUND;
  response.write('Not found: ${request.method}, ${request.uri.path}');
  response.close();
}

void handleOptions(HttpRequest request) {
  HttpResponse response = request.response;
  addCorsHeaders(response);
  print('${request.method}: ${request.uri.path}');
  response.statusCode = HttpStatus.NO_CONTENT;
  response.close();
}

void addCorsHeaders(HttpResponse response) {
  response.headers.add('Access-Control-Allow-Origin', '*');
  response.headers.add('Access-Control-Allow-Methods', 'POST, OPTIONS');
  response.headers.add('Access-Control-Allow-Headers',
      'Origin, X-Requested-With, Content-Type, Accept');
}
