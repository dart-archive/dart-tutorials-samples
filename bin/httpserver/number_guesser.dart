// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Automatic client to number_thinker.dart.

import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'dart:async';

Random myRandomGenerator = new Random();
HttpClient client;

main() {
  client = new HttpClient();
  Timer timer = new Timer.periodic(new Duration(seconds: 2), makeGuess);
}

makeGuess(_) {
  var aRandomNumber = myRandomGenerator.nextInt(10);
  
  client.get(InternetAddress.LOOPBACK_IP_V4.host, 4041, '/?q=${aRandomNumber}')
      .then((HttpClientRequest request) {
        print('Guess is $aRandomNumber.');
        return request.close();
      })
      .then((HttpClientResponse response) {
        if (response.statusCode == HttpStatus.OK) {
          print(response.statusCode);
          response.transform(UTF8.decoder).listen((contents) {
            if (contents.toString().startsWith('true')) {
              client.close();
              print('yay');
              exit(0);
            } else {
              print('boo');
            }
          });
        }
     });
}