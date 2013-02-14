import 'dart:html';
import 'dart:json' as json;

// JSON strings, bound to HTML
String intAsJson;
String doubleAsJson;
String stringAsJson;
String listAsJson;
String boolAsJson;
String mapAsJson;

// Data input as strings, bound to input fields
String favoriteNumber='';
String valueOfPi='';
String horrorScope='';
String favOne='';
String favTwo='';
String favThree='';
String chocolate='';

void showJson() {
  // Typed data to convert to JSON
  num favNum = int.parse(favoriteNumber);
  num pi = double.parse(valueOfPi);
  var anElement = query('#true');
  bool choco = anElement.checked ? true : false;
  
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

void main() {
  populateFromJson();
  showJson();
}

void populateFromJson() {

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
    var anElement = query('#true');
    anElement.checked = true;
  } else {
    var anElement = query('#false');
    anElement.checked = true;
  }
}
