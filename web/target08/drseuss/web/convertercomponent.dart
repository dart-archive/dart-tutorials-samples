import 'package:web_ui/web_ui.dart';

class ConverterComponent extends WebComponent {
  
  @observable num ratio = 0.5;
  @observable String thing_one = '0';
  @observable String thing_two = '0';

  @observable void convertOnetoTwo() {
    var one = double.parse(thing_one);
    var two = one/ratio;
    thing_two = two.toStringAsFixed(2);
  }

  @observable void convertTwotoOne() {
    var two = double.parse(thing_two);
    var one = two*ratio;
    thing_one = one.toStringAsFixed(2);
  }
}

