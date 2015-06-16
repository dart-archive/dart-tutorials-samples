// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Use the client program, number_guesser.dart to automatically make guesses.
// Or, you can manually guess the number using the URL localhost:4045/?q=#,
// where # is your guess.
// Or, you can use the make_a_guess.html UI.

import 'dart:io';
import 'dart:math' show Random;

int myNumber = new Random().nextInt(10);

main() async {
  print("I'm thinking of a number: $myNumber");

  try {
    HttpServer requestServer =
        await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 4041);
    await for (var request in requestServer) {
      handleRequest(request);
    }
  } catch (e) {
    print('Exception in main: $e');
  }
}

void handleRequest(HttpRequest request) {
  try {
    if (request.method == 'GET') {
      handleGet(request);
    } else {
      request.response.statusCode = HttpStatus.METHOD_NOT_ALLOWED;
      request.response
          .write('Unsupported request: ${request.method}.');
      request.response.close();
    }
  } catch (e) {
    print('Exception in handleRequest: $e');
  } finally {
    print('Request handled.');
  }
}

void handleGet(HttpRequest request) {
  String guess = request.uri.queryParameters['q'];
  request.response.statusCode = HttpStatus.OK;
  if (guess == myNumber.toString()) {
    request.response.writeln('true');
    request.response.writeln("I'm thinking of another number.");
    request.response.close();
    myNumber = new Random().nextInt(10);
    print("I'm thinking of another number: $myNumber");
  } else {
    request.response.writeln('false');
    request.response.close();
  }
}
