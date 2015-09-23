// Copyright (c) 2015, the Dart project authors.
// All rights reserved. Use of this source code
// is governed by a BSD-style license that can be
// found in the LICENSE file.
@HtmlImport('text_reverser.html')
library simple_wrapper_element.lib.text_reverser;

import 'package:polymer_elements/paper_input.dart';
import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

/// Mentioning [PaperInput] in this comment removes an
/// "unused import" warning for paper_input.dart.
@PolymerRegister('text-reverser')
class TextReverser extends PolymerElement {
  @property
  String text;

  TextReverser.created() : super.created();

  @eventHandler
  String reverseText(String text) {
    return text.split('').reversed.join('');
  }
}
