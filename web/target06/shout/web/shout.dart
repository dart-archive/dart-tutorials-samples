import 'package:web_ui/watcher.dart' as watchers;
String shoutThis='';

void main() {
}

String palindrome() {
  var buffer = new StringBuffer(shoutThis);
  for (int i = shoutThis.length - 1; i >= 0; i--) {
    buffer.write(shoutThis[i]);
  }
  return buffer.toString();
}
