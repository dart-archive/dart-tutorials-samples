// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'dart:math';

InputElement inputNameElement;

bool useRandomName = false;

List names = [ "Anne", "Bette", "Cate", "Dawn",
  "Elise", "Faye", "Ginger", "Harriot",
  "Izzy", "Jane", "Kaye", "Liz",
  "Maria", "Nell", "Olive", "Pat",
  "Queenie", "Rae", "Sal", "Tam",
  "Uma", "Violet", "Wilma", "Xana", "Yvonne", "Zelda"];

void  main() {
  query('#generateButton').onClick.listen(generateBadge);
  query('#useRandomName').onClick.listen(useRandomNameClickHandler);

  inputNameElement = query('#inputName');
  inputNameElement.onInput.listen(generateBadge);
}

void generateBadge(Event event) { 
  Random indexGenerator = new Random();
  
  if (useRandomName) {
    query('#badgeName').text = names[indexGenerator.nextInt(names.length)];
  } else {
    query('#badgeName').text = inputNameElement.value;
  }
}

void useRandomNameClickHandler(MouseEvent e) { 
  if ((e.target as CheckboxInputElement).checked) {
    inputNameElement.disabled = true;
    useRandomName = true;
  } else {
    inputNameElement.disabled = false;
    useRandomName = false;
  }
}
