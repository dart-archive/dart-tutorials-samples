import 'package:web_ui/web_ui.dart';

@observable String shoutThis='';

void main() {
}

String get shouted => shoutThis.toUpperCase();
String get palindrome =>
      shoutThis + shoutThis.split('').reversed.join();
