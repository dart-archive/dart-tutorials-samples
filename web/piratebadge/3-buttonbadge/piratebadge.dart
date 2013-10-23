// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

ButtonElement genButton;

void  main() {
  query('#inputName').onInput.listen(updateBadge);
  genButton = query('#generateButton')
      ..onClick.listen(generateBadge);
}

void updateBadge(Event e) {
  String inputName = (e.target as InputElement).value;
  
  badgeName = inputName;
  if (inputName.trim().isEmpty) {
    genButton..disabled = false
             ..text = 'Generate badge';
  } else {
    genButton..disabled = true
             ..text = 'Arrr! Remove the text!';
  }
}

void generateBadge(Event e) {
  badgeName = 'Anne Bonney';
}

set badgeName(String newName) {
  query('#badgeName').text = newName;
}
