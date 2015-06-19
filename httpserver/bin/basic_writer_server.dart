// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Server to basic_writer_client.dart.
// Receives JSON encoded data in a POST request and writes it to
// the file specified in the URI.

import 'dart:io';
import 'dart:convert';

main() async {
  var server =
      await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 4049);
  await for (var req in server) {
    ContentType contentType = req.headers.contentType;
    BytesBuilder builder = new BytesBuilder();

    if (req.method == 'POST' &&
        contentType != null &&
        contentType.mimeType == 'application/json') {
      try {
        await for (var buffer in req) {
          builder.add(buffer);
        }
      } finally {
        // Write to a file, get the file name from the URI.
        String jsonString = UTF8.decode(builder.takeBytes());
        String filename = req.uri.pathSegments.last;
        await new File(filename).writeAsString(jsonString,
            mode: FileMode.WRITE);
        Map jsonData = JSON.decode(jsonString);
        req.response.statusCode = HttpStatus.OK;
        req.response.write('Wrote data for ${jsonData['name']}.');
      }
    } else {
      req.response.statusCode = HttpStatus.METHOD_NOT_ALLOWED;
      req.response.write("Unsupported request: ${req.method}.");
    }
    req.response.close();
  }
}
