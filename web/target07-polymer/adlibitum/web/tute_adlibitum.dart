import 'package:polymer/polymer.dart';
import 'package:observe/observe.dart';
import 'dart:html';

class TuteAdlibitum extends CustomElement with ObservableMixin {

  @observable String sillyword='';
  @observable String adjective='';
  @observable String animal='';
  @observable String bodypart='';
  @observable String verb='';
  @observable String adverb='';
  
  @observable bool show = false;
  
  void _show() {
    if (sillyword != '' && adjective != '' &&
        animal    != '' && bodypart  != '' &&
        verb      != '' && adverb    != '') {
      show = true;
    } else {
      show = false;
    }
  }
  
  void created() {
    bindProperty(this, const Symbol('sillyword'), _show);
    bindProperty(this, const Symbol('adjective'), _show);
    bindProperty(this, const Symbol('animal'), _show);
    bindProperty(this, const Symbol('bodypart'), _show);
    bindProperty(this, const Symbol('verb'), _show);
    bindProperty(this, const Symbol('adverb'), _show);
  }
}