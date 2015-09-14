// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@HtmlImport('my_li.html')
library my_li;

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
