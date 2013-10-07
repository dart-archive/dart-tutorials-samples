library piratebadge;

import 'dart:html';
import 'dart:math';
import 'package:polymer/polymer.dart';

@CustomTag('name-badge')
class NameBadge extends PolymerElement with ObservableMixin {
  @observable String badgename = 'Bob';
  @observable bool female = true;
  @observable bool male = false;
    
  NameBadge() {
    bindProperty(this, const Symbol('female'), () {
        if (female) {
          male = false;
        }
        notifyProperty(this, const Symbol('name'));
      });
    bindProperty(this, const Symbol('male'), () {
        if (male) {
          female = false;
        }
        notifyProperty(this, const Symbol('name'));
      });
  }

  void pirateName(Event event, var detail, Node target) {
    if (female) {
      badgename = new PirateName.female().name;
    } else {
      badgename = new PirateName.male().name;
    }
  }
}

//library models;
class PirateName {
  
  Random indexGenerator = new Random();
  
  String _pirateName;
  
  String get name => _pirateName;
         set name(String value) => _pirateName = value;
         
  String toString() => name;

  static const List titles = const [ 'Captn', 'Mate', 'Sailor'];
  static const List maleNames = const [ 'Jack', 'Jonas', 'Billy'];
  static const List femaleNames = const [ 'Jane', 'Sue', 'Maria'];
  
  PirateName.male() {
    String title = titles[indexGenerator.nextInt(titles.length)];
    String firstName = maleNames[indexGenerator.nextInt(maleNames.length)];
    _pirateName = '$title $firstName';
  }

  PirateName.female() {
    String title = titles[indexGenerator.nextInt(titles.length)];
    String firstName = femaleNames[indexGenerator.nextInt(femaleNames.length)];
    _pirateName = '$title $firstName';
  }
  
}

// list, random?, string interpolation, cascade, fat arrow, optional parameters
// named constructors.
// getters
// possible cascades: where. foreach, tostring