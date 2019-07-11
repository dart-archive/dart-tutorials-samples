// Copyright (c) 2012, the Dart project authors.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code
// is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:html';
import 'dart:convert';

UListElement wordList;

void main() {
  querySelector('#getWords').onClick.listen(makeRequest);
  wordList = querySelector('#wordList') as UListElement;
}

void makeRequest(Event e) {
  var path = 'https://dart.dev/f/portmanteaux.json';
  var httpRequest = HttpRequest();
  httpRequest
    ..open('GET', path)
    ..onLoadEnd.listen((e) => requestComplete(httpRequest))
    ..send('');
}

void requestComplete(HttpRequest request) {
  if (request.status == 200) {
    final portmanteaux =
        (json.decode(request.responseText) as List<dynamic>).cast<String>();
    for (var i = 0; i < portmanteaux.length; i++) {
      wordList.children.add(LIElement()..text = portmanteaux[i]);
    }
  } else {
    wordList.children
        .add(LIElement()..text = 'Request failed, status=${request.status}');
  }
}
