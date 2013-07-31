import 'package:polymer/polymer.dart';
import 'dart:html';

@CustomTag('tute-converter')
class TuteConverter extends PolymerElement with ObservableMixin {
  
  @observable String ratio = '1';
  @observable String thing_one = '0';
  @observable String thing_two = '0';

  void convertOnetoTwo(Event e, var detail, Node target) {
    var ratioAsNum = double.parse(ratio);
    var one = double.parse(thing_one);
    var two = one/ratioAsNum;
    thing_two = two.toStringAsFixed(2);
  }

  void convertTwotoOne(Event e, var detail, Node target) {
    var ratioAsNum = double.parse(ratio);
    var two = double.parse(thing_two);
    var one = two*ratioAsNum;
    thing_one = one.toStringAsFixed(2);
  }
}

