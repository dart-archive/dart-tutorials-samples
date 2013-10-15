// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.


// Demonstrates:
// list, random?, string interpolation, cascade, fat arrow, optional parameters
// named constructors.
// getters
// possible cascades: where. foreach, tostring

library piratebadge;

import 'dart:html';
import 'dart:math';
import 'dart:convert';
import 'package:polymer/polymer.dart';

@CustomTag('name-badge')
class NameBadge extends PolymerElement {
  @observable String badgeName ='';
  @observable String maleOrFemale = 'female';
  
  int NUM_NAMES = 5;
  
  @observable List resultingNames = toObservable(new List());
  
  void created() {
    super.created();
    makeRequest();
  }
  
  void generateName(Event event, var detail, Node target) {
    resultingNames.clear();
    for (var i = 0; i < NUM_NAMES; i++) {
      if (maleOrFemale == 'female') {
        resultingNames.add(new PirateName.female().name);
      } else {
        resultingNames.add(new PirateName.male().name);
      }
    }
    
    if (maleOrFemale == 'female') {
      badgeName = new PirateName.female().name;
    } else {
      badgeName = new PirateName.male().name;
    }
  }
  
  void updateRadios(Event e, var detail, Node target) {
    maleOrFemale = (e.target as InputElement).value;
  }
  
  void makeRequest(/*Event e*/) {
    var path = 'piratenames.json';
    HttpRequest.getString(path)
    .then(processString)
    .catchError(handleError);
  }
  
  handleError(Error error) {
    print('Request failed.');
  }

  processString(String jsonString) {
    List<List> pirateNames = JSON.decode(jsonString);
    femaleNames = pirateNames[0];
    maleNames = pirateNames[1];
    surnames = pirateNames[2];
  }

}

//library models;
class PirateName {
  
  Random indexGenerator = new Random();
  
  String _pirateName;
  
  String get name => _pirateName;
         set name(String value) => _pirateName = value;
         
  String toString() => name;

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
}

List femaleNames;
List maleNames;
List surnames;

//Read from JSON file
/*
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
                               'Ultimate', 'Violent', 'Wily', 'Xact', 'Young', 'Zealot'];
*/
