// Uses the http_server package.
// Similar to mini_file_server.dart, which uses straight Dart APIs.

// Serves files in the same directory as this script.
// Client is basic_http_client.dart (or use the browser).

import 'dart:io';
import 'package:http_server/http_server.dart' show VirtualDirectory;

void main() {

  VirtualDirectory staticFiles = new VirtualDirectory('.');
    
  HttpServer.bind(InternetAddress.LOOPBACK_IP_V6, 4046).then((server) {
    server.listen((req) {
      staticFiles.serveFile(new File('index.html'), req);
    });
  });
}
