// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// This custom Polymer element extends an HTML list item.
// See "Extend native HTML elements"
// https://github.com/dart-lang/polymer-dart/wiki/registration-and-lifecycle#extend-native-html-elements

// A custom Polymer element must be declared as a
// Dart library. Annotate the library using
// @HtmlImport and specifying where the HTML is defined.
@HtmlImport('my_li.html')
library polymer_list.lib.my_li;

import 'dart:html' show LIElement;
import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart' show HtmlImport;

@PolymerRegister('my-li', extendsTag: 'li')
class MyListElement extends LIElement
    with PolymerMixin, PolymerBase, JsProxy {

  MyListElement.created() : super.created() {
    polymerCreated();
  }
}
