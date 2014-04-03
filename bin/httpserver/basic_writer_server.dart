// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Server to basic_writer_client.dart.
// Receives JSON encoded data in a POST request and writes it to
// the file specified in the URI. 

import 'dart:io';
import 'dart:convert';

void main() {

  HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 4049).then((server) {
    server.listen((req) {

      StringBuffer data = new StringBuffer();
      if (req.method == 'POST' &&
          req.headers.contentType.subType == 'json') {
        req.listen((buffer) {
          data.write(new String.fromCharCodes(buffer));
        }, onDone: () {
          // Write to a file, get the file name from the URI.
          String filename = req.uri.pathSegments.last;
          new File(filename).writeAsString(data.toString(),
              mode: FileMode.WRITE).then((_) {
            Map jsonData = JSON.decode(data.toString());
            req.response.statusCode = HttpStatus.OK;
            req.response.write('Wrote data for ${jsonData['name']}.');
            req.response.close();
            data.clear();
          });
        });
      } else {
        req.response.write('Unsupported request.');
        req.response.close();
      }
    });
  });
}
