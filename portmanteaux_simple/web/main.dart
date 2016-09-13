// Copyright (c) 2012, the Dart project authors.
// Please see the AUTHORS file for details.
// All rights reserved. Use of this source code
// is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:html';

var wordList;

void main() {
  querySelector('#getWords').onClick.listen(makeRequest);
  wordList = querySelector('#wordList');
}

Future makeRequest(Event e) async {
  var path = 'https://www.dartlang.org/f/portmanteaux.json';
  try {
    processString(await HttpRequest.getString(path));
  } catch (e) {
    print('Couldn\'t open $path');
    handleError(e);
  }
}

void processString(String jsonString) {
  List<String> portmanteaux = JSON.decode(jsonString) as List<String>;
  for (int i = 0; i < portmanteaux.length; i++) {
    wordList.children.add(new LIElement()..text = portmanteaux[i]);
  }
}

void handleError(Object error) {
  wordList.children.add(new LIElement()..text = 'Request failed.');
}
