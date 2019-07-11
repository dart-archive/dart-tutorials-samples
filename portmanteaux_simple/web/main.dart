// Copyright (c) 2012, the Dart project authors.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code
// is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:html';

UListElement wordList;

void main() {
  querySelector('#getWords').onClick.listen(makeRequest);
  wordList = querySelector('#wordList') as UListElement;
}

Future makeRequest(Event e) async {
  var path = 'https://dart.dev/f/portmanteaux.json';
  try {
    processString(await HttpRequest.getString(path));
  } catch (e) {
    print('Couldn\'t open $path: $e');
    handleError(e);
  }
}

void processString(String jsonString) {
  final portmanteaux =
      (json.decode(jsonString) as List<dynamic>).cast<String>();
  for (var i = 0; i < portmanteaux.length; i++) {
    wordList.children.add(LIElement()..text = portmanteaux[i]);
  }
}

void handleError(Object error) {
  wordList.children.add(LIElement()..text = 'Request failed.');
}
