// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@HtmlImport('tute_slambookform.html')
library slambook.lib.tute_slambookform;

import 'dart:html';
import 'dart:convert';
import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart' show HtmlImport;

@PolymerRegister('tute-slambookform', extendsTag: 'form')
class SlamBookComponent extends FormElement with 
    PolymerMixin, PolymerBase, JsProxy {

  AllAboutMe _myData = new AllAboutMe();

  @Property(observer: 'submitForm')
  AllAboutMe get myData => _myData;
  void set myData(AllAboutMe newValue) {
    _myData = newValue;
    notifyPath('myData', _myData);
  }

  SlamBookComponent.created() : super.created() {
    polymerCreated();
  }

  @Property(observer: 'submitForm')
  String serverResponse = '';

  HttpRequest request;

  @eventHandler
  void submitForm(var e, [_]) {
    if (e is Event) e.preventDefault(); // Don't do the default submit.
       
    request = new HttpRequest();
    
    request.onReadyStateChange.listen(onData); 
    
    // POST the data to the server.
    var url = 'http://127.0.0.1:4040';
    request.open('POST', url);
    request.send(myData.jsonSerialize());
  }

  @eventHandler
  void petChanged(Event e, [_]) {
    myData.pet = (e.target as RadioButtonInputElement).value;
  }

  void onData(_) {
    if (request.readyState == HttpRequest.DONE &&
        request.status == 200) {
      // Data saved OK.
      serverResponse = 'Server Sez: ' + request.responseText;
      notifyPath('serverResponse', serverResponse);
    } else if (request.readyState == HttpRequest.DONE &&
        request.status == 0) {
      // Status is 0...most likely the server isn't running.
      serverResponse = 'No server';
      notifyPath('serverResponse', serverResponse);
    }
  }
   
  @eventHandler
  void resetForm(var e, [_]) {
    if (e is Event) e.preventDefault(); // Default behavior clears elements,
                        // but bound values don't follow
                        // so have to do this explicitly.

    myData.resetData();
    serverResponse = 'Data cleared.';
    notifyPath('serverResponse', serverResponse);
  }
}

class AllAboutMe extends JsProxy {
  String firstName = 'Bob';
  String favoriteQuote = 'Bob\'s your uncle!';
  String favoriteColor = '#4169E1';
  String birthday = '1963-08-30';
  int musicVolume = 11;
  int musicType = 2;
  String pet = 'cat';
  bool zombies=true;

  String jsonSerialize() {
    var theData = {
      'firstName': firstName,
      'favoriteQuote': favoriteQuote,
      'favoriteColor': favoriteColor,
      'birthday': birthday,
      'musicType': musicType,
      'musicVolume': musicVolume,
      'pet': pet,
      'zombies': zombies
    };

    return JSON.encode(theData);
  }

  void resetData() {
    firstName = '';
    favoriteQuote = '';
    favoriteColor = '#FFFFFF';
    birthday = '2015-01-01';
    musicVolume = 0;
    musicType = 0;
    pet = 'iguana';
    zombies = false;
  }
}
