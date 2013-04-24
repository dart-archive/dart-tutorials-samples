import 'package:web_ui/web_ui.dart';

@observable String sillyword='';
@observable String adjective='';
@observable String animal='';
@observable String bodypart='';
@observable String verb='';
@observable String adverb='';

void main() {
}

@observable bool show() {
  if (sillyword != '' && adjective != '' &&
      animal    != '' && bodypart  != '' &&
      verb      != '' && adverb    != '') {
    return true;
  } else {
    return false;
  }
}