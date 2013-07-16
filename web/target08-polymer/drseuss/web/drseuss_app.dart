import 'package:mdv/mdv.dart' as mdv;
import 'dart:html';

void main() {
  mdv.initialize();
  query("#drseuss").model = "0.5";
}
