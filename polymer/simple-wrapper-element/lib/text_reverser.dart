// Copyright (c) 2015, the Dart project authors.
// All rights reserved. Use of this source code
// is governed by a BSD-style license that can be
// found in the LICENSE file.

// The "text_reverser" custom Polymer element.
// This element uses a standard paper element
// for user input.

// A custom Polymer element must be declared as a
// Dart library. Annotate the library using
// @HtmlImport and specifying where the HTML is defined.
@HtmlImport('text_reverser.html')
library simple_wrapper_element.lib.text_reverser;

// Import the paper element from Polymer.
import 'package:polymer_elements/paper_input.dart';

// Import the Polymer and Web Components scripts.
import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

/// Mentioning [PaperInput] in this comment removes an
/// "unused import" warning for paper_input.dart.
@PolymerRegister('text-reverser')
class TextReverser extends PolymerElement {

  // Marking with @property allows a user to
  // configure the property from markup.
  // https://github.com/dart-lang/polymer-dart/wiki/Properties
  @property
  String text;

  TextReverser.created() : super.created();

  @reflectable
  String reverseText(String text) {
    return text.split('').reversed.join('');
  }
}

// The Polymer Dart 1.0 Developer Guide:
// https://github.com/dart-lang/polymer-dart/wiki/feature-overview
