import 'dart:io';
import 'package:http_server/http_server.dart';
import 'package:path/path.dart';

void main() {
  var pathToBuild = join(dirname(Platform.script.toFilePath()));

  var staticFiles = new VirtualDirectory(pathToBuild);
  staticFiles.allowDirectoryListing = true;
  staticFiles.directoryHandler = (dir, request) {
    var indexUri = new Uri.file(dir.path).resolve('index.html');
    staticFiles.serveFile(new File(indexUri.toFilePath()), request);
  };

  HttpServer.bind(InternetAddress.LOOPBACK_IP_V6, 4048).then((server) {
    server.listen(staticFiles.serveRequest);
  });
}