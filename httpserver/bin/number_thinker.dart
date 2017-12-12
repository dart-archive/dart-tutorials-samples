// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Use the client program, number_guesser.dart to automatically make guesses.
// Or, you can manually guess the number using the URL localhost:4045/?q=#,
// where # is your guess.
// Or, you can use the make_a_guess.html UI.

import 'dart:async';
import 'dart:io';
import 'dart:math' show Random;

Random intGenerator = new Random();
int myNumber = intGenerator.nextInt(10);

Future main() async {
  print("I'm thinking of a number: $myNumber");

  HttpServer server = await HttpServer.bind(
    InternetAddress.LOOPBACK_IP_V4,
    4041,
  );
  await for (var request in server) {
    handleRequest(request);
  }
}
// #enddocregion main

void handleRequest(HttpRequest request) {
  try {
    if (request.method == 'GET') {
      handleGet(request);
    } else {
      // #enddocregion handleRequest
      request.response
        ..statusCode = HttpStatus.METHOD_NOT_ALLOWED
        ..write('Unsupported request: ${request.method}.')
        ..close();
    }
    // #enddocregion request-method
  } catch (e) {
    print('Exception in handleRequest: $e');
  }
  print('Request handled.');
}
// #enddocregion handleRequest

void handleGet(HttpRequest request) {
  // #enddocregion write
  final guess = request.uri.queryParameters['q'];
  // #enddocregion uri
  final response = request.response;
  response.statusCode = HttpStatus.OK;
  // #enddocregion statusCode
  if (guess == myNumber.toString()) {
    response
      ..writeln('true')
      ..writeln("I'm thinking of another number.")
      ..close();
    // #enddocregion write
    myNumber = intGenerator.nextInt(10);
    print("I'm thinking of another number: $myNumber");
  } else {
    response
      ..writeln('false')
      ..close();
  }
}
