// Replies "Hello, world!" to all requests.
// Use the URL localhost:4040 in your browser.
import 'dart:io';

main() {
  HttpServer.bind(InternetAddress.LOOPBACK_IP_V6, 4040)
    .then((HttpServer server) {
        print('listening on localhost, port 4040');
        server.listen((HttpRequest request) {
          request.response.write('Hello, world!');
          request.response.close();
        });
      })
    .catchError((_) => print ('Bind failed.'));
}
