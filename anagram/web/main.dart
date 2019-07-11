// Copyright (c) 2012, the Dart project authors.  Please see the
// AUTHORS file for details. All rights reserved. Use of this
// source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:html';
import 'dart:math';

// Should remove tiles from here when they are selected otherwise
// the ratio is off.

String scrabbleLetters =
    'aaaaaaaaabbccddddeeeeeeeeeeeeffggghhiiiiiiiiijkllllmmnnnnnnooooooooppqrrrrrrssssttttttuuuuvvwwxyyz**';

List<ButtonElement> buttons = List();
Element letterpile;
Element result;
ButtonElement clearButton;
Element value;
int wordvalue = 0;

Map scrabbleValues = {
  'a': 1,
  'e': 1,
  'i': 1,
  'l': 1,
  'n': 1,
  'o': 1,
  'r': 1,
  's': 1,
  't': 1,
  'u': 1,
  'd': 2,
  'g': 2,
  'b': 3,
  'c': 3,
  'm': 3,
  'p': 3,
  'f': 4,
  'h': 4,
  'v': 4,
  'w': 4,
  'y': 4,
  'k': 5,
  'j': 8,
  'x': 8,
  'q': 10,
  'z': 10,
  '*': 0
};

void main() {
  letterpile = querySelector("#letterpile");
  result = querySelector("#result");
  value = querySelector("#value");

  clearButton = querySelector("#clearButton");
  clearButton.onClick.listen(newletters);

  generateNewLetters();
}

void moveLetter(Event e) {
  Element letter = e.target;
  if (letter.parent == letterpile) {
    result.children.add(letter);
    wordvalue += scrabbleValues[letter.text];
    value.text = "$wordvalue";
  } else {
    letterpile.children.add(letter);
    wordvalue -= scrabbleValues[letter.text];
    value.text = "$wordvalue";
  }
}

void newletters(Event e) {
  letterpile.children.clear();
  result.children.clear();
  generateNewLetters();
}

void generateNewLetters() {
  final indexGenerator = Random();
  wordvalue = 0;
  value.text = '';
  buttons.clear();
  for (var i = 0; i < 7; i++) {
    final letterIndex = indexGenerator.nextInt(scrabbleLetters.length);
    // Should remove the letter from scrabbleLetters to keep the
    // ratio correct.
    buttons.add(ButtonElement());
    buttons[i].classes.add("letter");
    buttons[i].onClick.listen(moveLetter);
    buttons[i].text = scrabbleLetters[letterIndex];
    letterpile.children.add(buttons[i]);
  }
}
