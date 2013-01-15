import 'package:web_ui/web_ui.dart';

class ConverterComponent extends WebComponent {
  
  num ratio = 0.5;
  String thing_one = '0';
  String thing_two = '0';

  void convertOnetoTwo() {
    var one = double.parse(thing_one);
    var two = one/ratio;
    thing_two = two.toStringAsFixed(2);
  }

  void convertTwotoOne() {
    var two = double.parse(thing_two);
    var one = two*ratio;
    thing_one = one.toStringAsFixed(2);
  }
}

