import 'dart:html';
import 'dart:json' as json;
import 'package:polymer/polymer.dart';

@CustomTag('tute-its-all-about-you')
class TuteItsAllAboutYou extends PolymerElement with ObservableMixin {
  // JSON strings, bound to HTML
  @observable String intAsJson;
  @observable String doubleAsJson;
  @observable String stringAsJson;
  @observable String listAsJson;
  @observable String boolAsJson;
  @observable String mapAsJson;
  
  // Data input as strings, bound to input fields
  @observable String favoriteNumber='';
  @observable String valueOfPi='';
  @observable String horrorScope='';
  @observable String favOne='';
  @observable String favTwo='';
  @observable String favThree='';
  @observable String chocolate='';
  
  void showJson(Event e, var detail, Node target) {
    // Typed data to convert to JSON
    num favNum = int.parse(favoriteNumber);
    num pi = double.parse(valueOfPi);
    var anElement = getShadowRoot("tute-its-all-about-you").query('.true');
    bool choco = anElement.checked;
    
    List<String> favoriteThings = [ favOne, favTwo, favThree ];
  
    Map formData = {
      'favoriteNumber': favNum,
      'valueOfPi': pi,
      'chocolate': choco,
      'horrorScope': horrorScope,
      'favoriteThings': favoriteThings
    };
  
    // Convert everything to JSON
    intAsJson = json.stringify(favNum);          // int
    doubleAsJson = json.stringify(pi);           // double
    boolAsJson = json.stringify(choco);          // boolean
    stringAsJson = json.stringify(horrorScope);  // string
    listAsJson = json.stringify(favoriteThings); // list of strings
    mapAsJson = json.stringify(formData);        // map with string keys
                                                 // and mixed values
  }
  
  void inserted() {
    super.inserted();
    _populateFromJson();
    showJson(null, null, null);
  }
  
  void _populateFromJson() {
  
  String jsonDataAsString = '''
  { "favoriteNumber":44,
    "valueOfPi":3.141592,
    "chocolate":true,
    "horrorScope":"virgo",
    "favoriteThings":["raindrops",
                      "whiskers",
                      "mittens"]
  }
  ''';
  
    Map jsonData = json.parse(jsonDataAsString);
    
    favoriteNumber = jsonData['favoriteNumber'].toString();
    valueOfPi = jsonData['valueOfPi'].toString();
    horrorScope = jsonData['horrorScope'];
    favOne = jsonData['favoriteThings'][0];
    favTwo = jsonData['favoriteThings'][1];
    favThree = jsonData['favoriteThings'][2];
  
    if (jsonData['chocolate']) {
      var anElement = getShadowRoot("tute-its-all-about-you").query('.true');
      anElement.checked = true;
    } else {
      var anElement = getShadowRoot("tute-its-all-about-you").query('.false');
      anElement.checked = true;
    }
    
  }
}