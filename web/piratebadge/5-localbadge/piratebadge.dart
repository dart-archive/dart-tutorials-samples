// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'dart:math' show Random;
import 'dart:convert' show JSON;

final String TREASUREKEY = 'pirateName';

ButtonElement genButton;

void  main() {
  query('#inputName').onInput.listen(updateBadge);
  genButton = query('#generateButton')
      ..onClick.listen(generateBadge);
  
  badgeName = pirateNameFromStorage;
}

void updateBadge(Event e) {
  String inputName = (e.target as InputElement).value;
  
  badgeName = new PirateName(firstName: inputName);
  if (inputName.trim().isEmpty) {
    genButton..disabled = false
             ..text = 'Generate badge';
  } else {
    genButton..disabled = true
             ..text = 'Arrr! Remove the text!';
  }
}

void generateBadge(Event e) {
  badgeName = new PirateName();
}

set badgeName(PirateName newName) {
  query('#badgeName').text = newName.pirateName;
  window.localStorage[TREASUREKEY] = newName.toJsonString();
}

PirateName get pirateNameFromStorage {
  String storedName = window.localStorage[TREASUREKEY];
  if (storedName != null) {
    return new PirateName.fromJSON(storedName);
  } else {
    return null;
  }
}

class PirateName {
  
  static final Random indexGen = new Random();

  String _firstName;
  String _appellation;

  PirateName({String firstName, String appellation}) {
    if (firstName == null) {
      _firstName = names[indexGen.nextInt(names.length)];
    } else {
      _firstName = firstName;
    }
    if (appellation == null) {
      _appellation = appellations[indexGen.nextInt(appellations.length)];
    } else {
      _appellation = appellation;
    }
  }

  PirateName.fromJSON(String jsonString) {
    Map storedName = JSON.decode(jsonString);
    _firstName = storedName['f'];
    _appellation = storedName['a'];
  }

  String toString() => pirateName;

  String toJsonString() => '{ "f": "$_firstName", "a": "$_appellation" } ';

  String get pirateName => '$_firstName the $_appellation';

  static final List names = [
    'Anne', 'Mary', 'Jack', 'Morgan', 'Roger',
    'Bill', 'Ragnar', 'Ed', 'John', 'Jane' ];
  static final List appellations = [
    'Black','Damned', 'Jackal', 'Red', 'Stalwart', 'Axe',
    'Young', 'Old', 'Angry', 'Brave', 'Crazy', 'Noble'];
}
