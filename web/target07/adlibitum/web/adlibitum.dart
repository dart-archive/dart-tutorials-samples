String sillyword='';
String adjective='';
String animal='';
String bodypart='';
String verb='';
String adverb='';

bool show=false;

void main() {
}

void verify() {
  if (sillyword != '' && adjective != '' &&
      animal    != '' && bodypart  != '' &&
      verb      != '' && adverb    != '') {
    show = true;
  } else {
    show = false;
  }
}