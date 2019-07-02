// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Type localhost:4048 into your browser.
// This server returns the contents of index.html for all requests.

import 'dart:async';
import 'dart:io';
import 'package:http_server/http_server.dart';
import 'package:path/path.dart' as p;

Future main() async {
  var pathToBuild = p.join(p.dirname(Platform.script.toFilePath()));

  var staticFiles = VirtualDirectory(pathToBuild);
  staticFiles.allowDirectoryListing = true; /*1*/
  staticFiles.directoryHandler = (dir, request) /*2*/ {
    var indexUri = Uri.file(dir.path).resolve('index.html');
    staticFiles.serveFile(File(indexUri.toFilePath()), request); /*3*/
  };

  var server = await HttpServer.bind(InternetAddress.loopbackIPv4, 4048);
  print('Listening on http://${server.address.address}:${server.port}/');
  await server.forEach(staticFiles.serveRequest); /*4*/
}
