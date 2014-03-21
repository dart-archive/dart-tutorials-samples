// Uses the http_server package.
// Similar to mini_file_server.dart, which uses straight Dart APIs.

// Serves files in the same directory as this script.
// Client is basic_http_client.dart (or use the browser).

import 'dart:io';
import 'dart:convert';

void main() {
    
  HttpServer.bind(InternetAddress.LOOPBACK_IP_V6, 4043).then((server) {
    server.listen((req) {
      
      StringBuffer data = new StringBuffer();
      if (req.method == 'POST' &&
          req.headers[HttpHeaders.CONTENT_ENCODING].toString() == '[JSON]') {
        req.listen((buffer) {
          data.write(new String.fromCharCodes(buffer));
        },
        onDone: () {
          // write to a file, get the file name from the URI
          String filename = req.requestedUri.pathSegments.last;
          new File(filename).writeAsString(data.toString(), mode: FileMode.WRITE)
              .then((_) {
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
