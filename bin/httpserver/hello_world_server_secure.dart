// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Replies "Hello, world!" to all requests.
// Use the HTTPS URL https://localhost:4047 in your browser.
// You might get a warning about a potential security risk.

import 'dart:io';

main() {
  var testPkcertDatabase = Platform.script.resolve('pkcert').toFilePath();
  SecureSocket.initialize(database: testPkcertDatabase,
      password: 'dartdart');

  HttpServer.bindSecure('localhost', 4047,
      certificateName: 'localhost_cert').then((server) {
    print('listening');
    server.listen((HttpRequest request) {
      request.response.write('Hello, world!');
      request.response.close();
    });
  });
}
