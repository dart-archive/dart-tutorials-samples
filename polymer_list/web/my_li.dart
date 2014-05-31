// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html' show LIElement;
import 'package:polymer/polymer.dart';

@CustomTag('my-li')
class MyListElement extends LIElement with Polymer, Observable {  
  MyListElement.created() : super.created() {
    polymerCreated();
  }
}
