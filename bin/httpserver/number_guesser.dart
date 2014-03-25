// Automatic client to pair_server.dart.
// Shows two Future series for making a request
// and getting the response.
// Shows data conversion.

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
  
  client.get(InternetAddress.LOOPBACK_IP_V6.host, 4041, '/?q=${aRandomNumber}')
        .then((HttpClientRequest request) {
          print(aRandomNumber);
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