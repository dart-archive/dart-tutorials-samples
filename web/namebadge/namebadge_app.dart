// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.


// Demonstrates:
// list, random, string interpolation, cascade, fat arrow,
// named constructors.
// getters, setters,
// httprequest, JSON
// static methods/fields
// cascades (onclick listen...piratename.male.name

// Does not yet demonstrate optional parameters

import 'dart:html';
import 'dart:math';
import 'dart:convert';

void  main() {
  query('#generateButton').onClick.listen(generateName);
  PirateName.initialize();
}

void generateName(MouseEvent event) { 
  
  String badgeName = '';
  
  if ((query('#female') as RadioButtonInputElement).checked) {
    badgeName = new PirateName.female().name;
  } else {
    badgeName = new PirateName.male().name;
  }
  query('#badgeName').text = badgeName;
  
}

//library models;
class PirateName {
  
  Random indexGenerator = new Random();
  
  String _pirateName;
  
  String get name => _pirateName;
         set name(String value) => _pirateName = value;
         
  String toString() => name;

  static List femaleNames;
  static List maleNames;
  static List surnames;

  static void initialize() {
    makeRequest();
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

  static void makeRequest(/*Event e*/) {
    var path = 'piratenames.json';
    HttpRequest.getString(path)
      .then(processString)
        .catchError(handleError);
  }

  static handleError(Error error) {
    print('Request failed.');
  }

  static processString(String jsonString) {
    List<List> pirateNames = JSON.decode(jsonString);
    femaleNames = pirateNames[0];
    maleNames = pirateNames[1];
    surnames = pirateNames[2];
  }
}

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
