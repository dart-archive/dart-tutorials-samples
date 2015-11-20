import 'dart:html';

import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/paper_checkbox.dart';
import 'package:polymer_elements/paper_input.dart';
import 'package:polymer_elements/paper_dropdown_menu.dart';
import 'package:polymer_elements/paper_menu.dart';
import 'package:polymer_elements/paper_item.dart';
import 'package:polymer/polymer.dart';

/// Mentioning [PaperButton], [PaperCheckbox], [PaperInput],
/// [PaperDropdownMenu], [PaperMenu], and [PaperItem]
/// in this comment removes "unused import"
/// warnings from the analyzer.
main() async {
  await initPolymer();

  // Note: The "tap" event processes faster than the "click" event.
  querySelector('paper-button').on['tap'].listen((_) {
    print('Button tapped!');
  });

  querySelector('paper-checkbox').on['change'].listen((e) {
    bool checked = e.target.checked;
    print('Checkbox changed: $checked');
  });

  querySelector('paper-menu').on['tap'].listen((e) {
    var selected = e.target.text;
    print('Selected pizza: $selected');
  });

  var domBind = querySelector('template[is="dom-bind"]');
  domBind['onKeyUp'] = (e, _) {
    String input = e.target.value;
    print('Input entered: $input');
  };
}