// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'dart:convert';
import 'package:polymer/polymer.dart';

@CustomTag('tute-its-all-about-you')
class TuteItsAllAboutYou extends PolymerElement {
  // JSON strings, bound to HTML
  @observable String intAsJson;
  @observable String doubleAsJson;
  @observable String stringAsJson;
  @observable String listAsJson;
  @observable String boolAsJson;
  @observable String mapAsJson;
  
  // Data input as strings, bound to input fields
  @observable String favoriteNumber='';
  @observable String valueOfPi='';
  @observable String horrorScope='';
  @observable String favOne='';
  @observable String favTwo='';
  @observable String favThree='';
  @observable String chocolate='';
  
  TuteItsAllAboutYou.created() : super.created();
  
  void showJson(Event e, var detail, Node target) {
    // Typed data to convert to JSON
    num favNum = int.parse(favoriteNumber);
    num pi = double.parse(valueOfPi);
    var anElement = $['lovechocolate'];
    bool choco = (anElement as RadioButtonInputElement).checked;
    
    List<String> favoriteThings = [ favOne, favTwo, favThree ];
  
    Map formData = {
      'favoriteNumber': favNum,
      'valueOfPi': pi,
      'chocolate': choco,
      'horrorScope': horrorScope,
      'favoriteThings': favoriteThings
    };
  
    // Convert everything to JSON
    intAsJson = JSON.encode(favNum);          // int
    doubleAsJson = JSON.encode(pi);           // double
    boolAsJson = JSON.encode(choco);          // boolean
    stringAsJson = JSON.encode(horrorScope);  // string
    listAsJson = JSON.encode(favoriteThings); // list of strings
    mapAsJson = JSON.encode(formData);        // map with string keys
                                                 // and mixed values
  }
  
  void attached() {
    super.attached();
    _populateFromJson();
    showJson(null, null, null);
  }
  
  void _populateFromJson() {
  
  String jsonDataAsString = '''
  { "favoriteNumber":44,
    "valueOfPi":3.141592,
    "chocolate":true,
    "horrorScope":"virgo",
    "favoriteThings":["raindrops",
                      "whiskers",
                      "mittens"]
  }
  ''';
  
    Map jsonData = JSON.decode(jsonDataAsString);
    
    favoriteNumber = jsonData['favoriteNumber'].toString();
    valueOfPi = jsonData['valueOfPi'].toString();
    horrorScope = jsonData['horrorScope'];
    favOne = jsonData['favoriteThings'][0];
    favTwo = jsonData['favoriteThings'][1];
    favThree = jsonData['favoriteThings'][2];
  
    if (jsonData['chocolate']) {
      var anElement = $['lovechocolate'];
      (anElement as RadioButtonInputElement).checked = true;
    } else {
      var anElement = $['noloveforchocolate'];
      (anElement as RadioButtonInputElement).checked = true;
    }
    
  }
}
