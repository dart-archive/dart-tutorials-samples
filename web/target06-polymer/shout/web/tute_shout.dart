import 'package:polymer/polymer.dart';

@CustomTag('tute-shout')
class TuteShout extends PolymerElement with ObservableMixin {

  @observable String shoutThis;
  @observable String shouted;
  @observable String shoutedSubstring;
  @observable String palindrome;
  
  void created() {
    super.created();

    // When 'shoutThis' changes, recompute other dependent strings.
    bindProperty(this, const Symbol('shoutThis'), () {
      shouted = shoutThis.toUpperCase();
      shoutedSubstring = (shoutThis.length >= 6) ?
                          shoutThis.substring(1, 5) :
                          shoutThis.substring(0, 0);
      palindrome = shoutThis + shoutThis.split('').reversed.join();
      //Observable.dirtyCheck();
    });
  }
}
