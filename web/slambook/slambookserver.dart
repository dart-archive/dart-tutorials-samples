// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

/* A simple server stolen from Chris Buckett's JSON web-service article
 * and modified for purposes of this tutorial sample.
 *  
 * Provides CORS headers, so can be accessed from any other page
 */

final HOST = '127.0.0.1'; // eg: localhost 
final PORT = 4040;        // a port, must match the client program

void main() {
  HttpServer.bind(HOST, PORT).then(gotMessage, onError: printError);
}

void gotMessage(_server) {
  _server.listen((HttpRequest request) {
    switch (request.method) {
      case 'POST': 
        handlePost(request);
        break;
      case 'OPTIONS': 
        handleOptions(request);
        break;
      default: defaultHandler(request);
    }
  },
  onError: printError); // .listen failed
  print('Listening for GET and POST on http://$HOST:$PORT');
}

/**
 * Handle POST requests
 * Return the same set of data back to the client.
 */
void handlePost(HttpRequest req) {
  HttpResponse res = req.response;
  print('${req.method}: ${req.uri.path}');
  
  addCorsHeaders(res);
  
  req.listen((List<int> buffer) {
    // return the data back to the client
    res.write('Thanks for the data. This is what I heard you say: ');
    res.write(new String.fromCharCodes(buffer));
    res.close();
  },
  onError: printError);
}

/**
 * Add Cross-site headers to enable accessing this server from pages
 * not served by this server
 * 
 * See: http://www.html5rocks.com/en/tutorials/cors/ 
 * and http://enable-cors.org/server.html
 */
void addCorsHeaders(HttpResponse res) {
  res.headers.add('Access-Control-Allow-Origin', '*');
  res.headers.add('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.headers.add('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept');
}

void handleOptions(HttpRequest req) {
  HttpResponse res = req.response;
  addCorsHeaders(res);
  print('${req.method}: ${req.uri.path}');
  res.statusCode = HttpStatus.NO_CONTENT;
  res.close();
}

void defaultHandler(HttpRequest req) {
  HttpResponse res = req.response;
  addCorsHeaders(res);
  res.statusCode = HttpStatus.NOT_FOUND;
  res.write('Not found: ${req.method}, ${req.uri.path}');
  res.close();
}

void printError(error) => print(error);

/* UNUSED CODE */
/**
 * Handle GET requests 
 */
/*
void handleGet(HttpRequest req) {
  HttpResponse res = req.response;
  print('${req.method}: ${req.uri.path}');
  addCorsHeaders(res);
  
  res.headers.add(HttpHeaders.CONTENT_TYPE, 'application/json');
  res.write('hi from the server');
  res.close();
}
*/
/**
 *put this back in the switch statement in main() to handle GET requests
 */
/*
        case 'GET': 
          handleGet(request);
	  break;
 */ 
