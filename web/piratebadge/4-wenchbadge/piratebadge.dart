// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'dart:math';

InputElement inputNameElement;

bool useRandomName = false;

void  main() {
  query('#generateButton').onClick.listen(generateBadge);
  query('#useRandomName').onClick.listen(useRandomNameClickHandler);
  
  inputNameElement = query('#inputName');
  inputNameElement.onInput.listen(generateBadge);
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

void generateBadge(Event event) { 
  if (useRandomName) {
    query('#badgeName').text = new PirateName().name;
  } else {
    query('#badgeName').text = new PirateName(firstName: inputNameElement.value).name;
  }
}

class PirateName {
  
  Random indexGenerator = new Random();
  
  String _pirateName;
  
  String get name => _pirateName;
         set name(String value) => _pirateName = value;
         
  String toString() => name;

  PirateName({String firstName}) {
    if (firstName == null) {
      firstName = names[indexGenerator.nextInt(names.length)];
    }
    String surname = surnames[indexGenerator.nextInt(surnames.length)];
    _pirateName = '$firstName the $surname';
  }

  List names = const [ 'Anne', 'Bette', 'Cate', 'Dawn',
                             'Elise', 'Faye', 'Ginger', 'Harriot',
                             'Izzy', 'Jane', 'Kaye', 'Liz',
                             'Maria', 'Nell', 'Olive', 'Pat',
                             'Queenie', 'Rae', 'Sal', 'Tam',
                             'Uma', 'Violet', 'Wilma', 'Xana', 'Yvonne', 'Zelda'];
  List surnames = const   [ 'Angry', 'Brave', 'Crazy', 'Damned',
                            'Even', 'Fool', 'Great', 'Hated',
                            'Idiot', 'Jackal', 'Kind', 'Lame',
                            'Maimed', 'Naked', 'Old', 'Pirate',
                            'Quick', 'Rich', 'Sandy', 'Tired',
                            'Ultimate', 'Violent', 'Wily', 'aXe', 'Young', 'Zealot'];
}

