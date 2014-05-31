// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Client to basic_writer_server.dart.
// Makes a POST request containing JSON-encoded data
// to the server and prints the response.

import 'dart:io';
import 'dart:convert' show UTF8, JSON;

main() {

  Map jsonData = {
    'name': 'Han Solo',
    'job': 'reluctant hero',
    'BFF': 'Chewbacca',
    'ship': 'Millennium Falcon',
    'weakness': 'smuggling debts'
  };
  
  new HttpClient().post(InternetAddress.LOOPBACK_IP_V4.host, 4049, '/file.txt')
      .then((HttpClientRequest request) {
        request.headers.contentType = ContentType.JSON;
        request.write(JSON.encode(jsonData));
        return request.close();
      })
      .then((HttpClientResponse response) {
        response.transform(UTF8.decoder).listen((contents) {
          print(contents);
        });
      });

}
