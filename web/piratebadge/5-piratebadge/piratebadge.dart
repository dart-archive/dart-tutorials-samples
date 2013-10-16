// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'dart:math';

RadioButtonInputElement maleRadioElement;
RadioButtonInputElement femaleRadioElement;
InputElement inputNameElement;

Element badgeNameElement;

bool useRandomName = false;

void  main() {
  maleRadioElement = query('#male');
  femaleRadioElement = query('#female');
  badgeNameElement = query('#badgeName');

  query('#generateButton').onClick.listen(generateBadge);
  query('#useRandomName').onClick.listen(useRandomNameClickHandler);

  inputNameElement = query('#inputName');
  inputNameElement.onInput.listen(generateBadge);
}

void useRandomNameClickHandler(MouseEvent e) { 
  if ((e.target as CheckboxInputElement).checked) {
    inputNameElement.disabled = true;
    femaleRadioElement.disabled = false;
    maleRadioElement.disabled = false;
    useRandomName = true;
  } else {
    inputNameElement.disabled = false;
    femaleRadioElement.disabled = true;
    maleRadioElement.disabled = true;
    useRandomName = false;
  }
}

void generateBadge(Event event) {   
  if (!useRandomName) {
    badgeNameElement.text = new PirateName(firstName: inputNameElement.value).name;
  } else if ((query('#female') as RadioButtonInputElement).checked) {
    badgeNameElement.text = new PirateName.female().name;
  } else {
    badgeNameElement.text = new PirateName.male().name;
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
      firstName = femaleNames[indexGenerator.nextInt(femaleNames.length)];
    }
    String surname = surnames[indexGenerator.nextInt(surnames.length)];
    _pirateName = '$firstName the $surname';
  }

  PirateName.male() {
    String firstName = maleNames[indexGenerator.nextInt(maleNames.length)];
    String surname = surnames[indexGenerator.nextInt(surnames.length)];
    _pirateName = '$firstName the $surname';
  }

  PirateName.female() {
    String firstName = femaleNames[indexGenerator.nextInt(femaleNames.length)];
    String surname = surnames[indexGenerator.nextInt(surnames.length)];
    _pirateName = '$firstName the $surname';
  }

  List femaleNames = const [ 'Anne', 'Bette', 'Cate', 'Dawn',
                             'Elise', 'Faye', 'Ginger', 'Harriot',
                             'Izzy', 'Jane', 'Kaye', 'Liz',
                             'Maria', 'Nell', 'Olive', 'Pat',
                             'Queenie', 'Rae', 'Sal', 'Tam',
                             'Uma', 'Violet', 'Wilma', 'Xana', 'Yvonne', 'Zelda'];
  List maleNames = const [ 'Abe', 'Billy', 'Caleb', 'Davie',
                           'Eb', 'Frank', 'Gabe', 'House',
                           'Icarus', 'Jack', 'Kurt', 'Larry',
                           'Mike', 'Nolan', 'Oliver', 'Pat',
                           'Quib', 'Roy', 'Sal', 'Tom',
                           'Ube', 'Val', 'Walt', 'Xavier', 'Yvan', 'Zeb'];
  List surnames = const   [ 'Angry', 'Brave', 'Crazy', 'Damned',
                            'Even', 'Fool', 'Great', 'Hated',
                            'Idiot', 'Jackal', 'Kind', 'Lame',
                            'Maimed', 'Naked', 'Old', 'Pirate',
                            'Quick', 'Rich', 'Sandy', 'Tired',
                            'Ultimate', 'Violent', 'Wily', 'aXe', 'Young', 'Zealot'];
}