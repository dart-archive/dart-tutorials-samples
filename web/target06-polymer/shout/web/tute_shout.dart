import 'package:polymer/polymer.dart';
import 'package:observe/observe.dart';
import 'dart:html';

class TuteShout extends CustomElement with ObservableMixin {

  @observable String shoutThis;
  @observable String shouted;
  @observable String shoutedSubstring;
  @observable String palindrome;
  
  void created() {
    // When 'shoutThis' changes recompute to 'shouted' and 'palindrome'.
    bindProperty(this, const Symbol('shoutThis'), () {
      shouted = shoutThis.toUpperCase();
      shoutedSubstring = (shoutThis.length >= 6) ?
                          shoutThis.substring(1, 5) :
                          shoutThis.substring(0, 0);
      palindrome = shoutThis + shoutThis.split('').reversed.join();
    });
  }
}