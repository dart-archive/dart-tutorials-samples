// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.


// Demonstrates:
// list, random, string interpolation, cascade, fat arrow,
// named constructors.
// optional parameters.
// getters, setters,
// httprequest, JSON
// static methods/fields
// cascades (onclick listen...piratename.male.name

import 'dart:html';
import 'dart:math';
import 'dart:convert';

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
  query('#inputName').onInput.listen(generateBadge);

  PirateName.initialize();
}

void generateBadge(Event event) { 
  if (!useRandomName) {
    badgeNameElement.text = new PirateName(inputNameElement.value).name;
  } else if (femaleRadioElement.checked) {
    badgeNameElement.text = new PirateName.female().name;
  } else {
    badgeNameElement.text = new PirateName.male().name;
  }
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
  
//library models;
class PirateName {
  
  Random indexGenerator = new Random();
  
  String _pirateName;
  
  String get name => _pirateName;
         set name(String value) => _pirateName = value;
         
  String toString() => name;

  PirateName(String firstName) {
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

  static List<String> femaleNames = [];
  static List<String> maleNames = [];
  static List<String> surnames = [];

  static void initialize() {
    makeRequest();
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