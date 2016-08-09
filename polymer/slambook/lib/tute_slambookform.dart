// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// This custom Polymer component extends a <form> element.
// See "Extend native HTML elements"
// https://github.com/dart-lang/polymer-dart/wiki/registration-and-lifecycle#extend-native-html-elements

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

  // This "@Property(observer:submitForm" declaration on myData
  // means that the submitForm function will be called when
  // "myData" changes.
  // See "Property Change Observers"
  // https://github.com/dart-lang/polymer-dart/wiki/properties#property-change-observers
  // Calling "notifyPath" informs the system that a value has changed.
  // See "Path change notification"
  // https://github.com/dart-lang/polymer-dart/wiki/data-binding-syntax#path-change-notification
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

  @reflectable
  void submitForm(var e, [_]) {
    if (e is Event) e.preventDefault(); // Don't do the default submit.

    request = new HttpRequest();

    request.onReadyStateChange.listen(onData);

    // POST the data to the server.
    var url = 'http://127.0.0.1:4040';
    request.open('POST', url);
    request.send(myData.jsonSerialize());
  }

  @reflectable
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

  // See "Event listener setup"
  // https://github.com/dart-lang/polymer-dart/wiki/events#event-listener-setup
  @reflectable
  void resetForm(var e, [_]) {
    if (e is Event) e.preventDefault(); // Default behavior clears elements,
                        // but bound values don't follow
                        // so have to do this explicitly.

    myData.resetData();
    serverResponse = 'Data cleared.';
    notifyPath('serverResponse', serverResponse);
  }
}

// The Polymer Dart 0.16.0 version of slambook stored the data
// using a Map. It's more efficient, and more Darty, to use
// a class. When extending JsProxy, Polymer reads and writes
// directly to the Dart object; when modifying a Map
// value, Polymer copies the entire map to a new JS object.
class AllAboutMe extends JsProxy {
  @reflectable
  String firstName = 'Bob';

  @reflectable
  String favoriteQuote = 'Bob\'s your uncle!';

  @reflectable
  String favoriteColor = '#4169E1';

  @reflectable
  String birthday = '1963-08-30';

  @reflectable
  int musicVolume = 11;

  @reflectable
  int musicType = 2;

  @reflectable
  String pet = 'cat';

  @reflectable
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
