// Shows receiving and responding to both GET and POST requests.
// Shows buffering request (which in this example is completely unnecessary)

// Client program is pair_client.dart
// Or you can manually guess the number
// using the URL localhost:4041/?# , where # is your guess

import 'dart:io';
import 'dart:math' show Random;

int myNumber = new Random().nextInt(10);

void main() {
  print("I'm thinking of a number. $myNumber");
  HttpServer.bind(InternetAddress.LOOPBACK_IP_V6, 4041)
            .then(listenForRequests)
            .catchError((_) => print ('Bind failed.'));
}

listenForRequests(HttpServer _server) {
  _server.listen((HttpRequest request) {
    if (request.method == 'GET') {
      handleGet(request);
    } else {
      request.response.write("Unsupported request: ${request.method}.");
      request.response.close();
    }
  },
  onDone: () => print('No more requests.'),
  onError: (_) => print('Server listen failed.') );
}

void handleGet(HttpRequest request) {
  String guess = request.requestedUri.queryParameters['q'];
  print(guess);
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