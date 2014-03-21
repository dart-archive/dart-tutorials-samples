// Serves the index.html in the same directory as this script.
// Use the URL localhost:4044 in your browser.

// For a similar server that uses http_server package
// see basic_http_server.dart.

import 'dart:io';

main() {
  HttpServer.bind(InternetAddress.LOOPBACK_IP_V6, 4044).then((server) {
    server.listen((HttpRequest req) {
      File file = new File('index.html');
      file.exists().then((bool found) {
        if (found) {
          file.openRead()
          .pipe(req.response)  //HttpResponse type
          .catchError((e) { });
        } else {
          req.response.statusCode = HttpStatus.NOT_FOUND;
          req.response.close();
        }
      });
    });
  });
}
