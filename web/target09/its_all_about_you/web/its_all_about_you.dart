import 'dart:html';
import 'dart:json' as JSON;

// JSON strings, bound to HTML
String intasjson;
String doubleasjson;
String stringasjson;
String listasjson;
String boolasjson;
String mapasjson;

// Data input as strings, bound to input fields
String favoritenumber='';
String valueofpi='';
String horrorscope='';
String favone='';
String favtwo='';
String favthree='';
String chocolate='';

void showJSON() {
  
  // typed data to convert to JSON
  num favnum = int.parse(favoritenumber);
  num pi = double.parse(valueofpi);
  var anElement = query('#true');
  bool choco = anElement.checked ? true : false;
  
  List<String> favoritethings = [ favone, favtwo, favthree ];

  Map formdata = {
    'favoritenumber': favnum,
    'valueofpi': pi,
    'chocolate': choco,
    'horrorscope': horrorscope,
    'favoritethings': favoritethings
  };

  // convert everything to JSON
  intasjson = JSON.stringify(favnum);
  doubleasjson = JSON.stringify(pi);
  boolasjson = JSON.stringify(choco);
  stringasjson = JSON.stringify(horrorscope);
  listasjson = JSON.stringify(favoritethings);
  mapasjson = JSON.stringify(formdata);
}

void main() {
  populateFromJSON();
  showJSON();
}

void populateFromJSON() {

String jsondataasstring = '''
{ "favoritenumber":44,
  "valueofpi":3.141592,
  "chocolate":true,
  "horrorscope":"virgo",
  "favoritethings":["raindrops",
                    "whiskers",
                    "mittens"]
}
''';

  Map jsondata = JSON.parse(jsondataasstring);
  
  favoritenumber = jsondata['favoritenumber'].toString();
  valueofpi = jsondata['valueofpi'].toString();
  horrorscope = jsondata['horrorscope'];
  favone = jsondata['favoritethings'][0];
  favtwo = jsondata['favoritethings'][1];
  favthree = jsondata['favoritethings'][2];

  if (jsondata['chocolate']) {
    var anElement = query('#true');
    anElement.checked = true;
  } else {
    var anElement = query('#false');
    anElement.checked = true;
  }
}
