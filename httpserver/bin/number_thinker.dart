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

Random intGenerator = Random();
int myNumber = intGenerator.nextInt(10);

Future main() async {
  print("I'm thinking of a number: $myNumber");

  final server = await HttpServer.bind(
    InternetAddress.loopbackIPv4,
    4041,
  );
  print('Listening on http://${server.address.address}:${server.port}/');
  await for (var request in server) {
    handleRequest(request);
  }
}

void handleRequest(HttpRequest request) {
  try {
    if (request.method == 'GET') {
      handleGet(request);
    } else {
      request.response
        ..statusCode = HttpStatus.methodNotAllowed
        ..write('Unsupported request: ${request.method}.')
        ..close();
    }
  } catch (e) {
    print('Exception in handleRequest: $e');
  }
  print('Request handled.');
}

void handleGet(HttpRequest request) {
  final guess = request.uri.queryParameters['q'];
  final response = request.response;
  response.statusCode = HttpStatus.ok;
  if (guess == myNumber.toString()) {
    response
      ..writeln('true')
      ..writeln("I'm thinking of another number.")
      ..close();
    myNumber = intGenerator.nextInt(10);
    print("I'm thinking of another number: $myNumber");
  } else {
    response
      ..writeln('false')
      ..close();
  }
}
