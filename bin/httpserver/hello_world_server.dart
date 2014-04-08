// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Replies "Hello, world!" to all requests.
// Use the URL localhost:4040 in your browser.

import 'dart:io';

main() {
  HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 4040)
      .then((HttpServer server) {
    print('listening on localhost, port ${server.port}');
    server.listen((HttpRequest request) {
      request.response.write('Hello, world!');
      request.response.close();
    });
  }).catchError((e) => print(e.toString()));
}
