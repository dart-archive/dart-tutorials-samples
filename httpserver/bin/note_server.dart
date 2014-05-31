// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Client program is note_client.dart.
// Use note_taker.html to run the client.

import 'dart:io';
import 'dart:convert' show JSON;

int count = 0;

void main() {
  // One note per line.
  List<String> lines = new File('notes.txt').readAsLinesSync();
  count = lines.length;

  HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 4042)
      .then(listenForRequests)
      .catchError((e) => print('hello: ${e.toString()}'));
}

listenForRequests(_server) {
  _server.listen((HttpRequest request) {
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
  },
  onDone: () => print('No more requests.'),
  onError: (e ) => print(e.toString()));
}

void handlePost(HttpRequest req) {
  StringBuffer data = new StringBuffer();

  addCorsHeaders(req.response);

  req.listen((buffer) {
    data.write(new String.fromCharCodes(buffer));
  }, onDone: () {
    var decoded = JSON.decode(data.toString());

    if (decoded.containsKey('myNote')) {
      saveNote(req, '${decoded["myNote"]}\n');
    } else { // 'getNote'
      getNote(req, decoded['getNote']);
    }
  }, onError: (_) {
    print('Request listen error.');
  });
}

saveNote(HttpRequest req, String myNote) {
  new File('notes.txt').writeAsStringSync(myNote, mode: FileMode.APPEND);
  count++;
  req.response.statusCode = HttpStatus.OK;
  req.response.writeln('You have $count notes.');
  req.response.close();
}

getNote(HttpRequest req, String getNote) {
  int requestedNote = int.parse(getNote, onError: (_) {
    print('error');
  });
  if (requestedNote == null) {
    requestedNote = 0;
  }
  if (requestedNote >= 0 && requestedNote < count) {
    List<String> lines = new File('notes.txt').readAsLinesSync();
    req.response.statusCode = HttpStatus.OK;
    req.response.writeln(lines[requestedNote]);
    req.response.close();
  }
}

void defaultHandler(HttpRequest req) {
  HttpResponse res = req.response;
  addCorsHeaders(res);
  res.statusCode = HttpStatus.NOT_FOUND;
  res.write('Not found: ${req.method}, ${req.uri.path}');
  res.close();
}

void handleOptions(HttpRequest req) {
  HttpResponse res = req.response;
  addCorsHeaders(res);
  print('${req.method}: ${req.uri.path}');
  res.statusCode = HttpStatus.NO_CONTENT;
  res.close();
}

void addCorsHeaders(HttpResponse res) {
  res.headers.add('Access-Control-Allow-Origin', '*');
  res.headers.add('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.headers.add('Access-Control-Allow-Headers',
      'Origin, X-Requested-With, Content-Type, Accept');
}
