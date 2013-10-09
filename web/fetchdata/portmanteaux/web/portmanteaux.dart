import 'dart:html';
import 'dart:convert';

var wordList;

void main() {
  query('#getWords').onClick.listen(makeRequest);
  wordList = query('#wordList');
}

void makeRequest(Event e) {
  var path = 'portmanteaux.json';
  var httpRequest = new HttpRequest();
  httpRequest
  ..open('GET', path)
  ..onLoadEnd.listen((e) => requestComplete(httpRequest))
  ..send('');
}

requestComplete(HttpRequest request) {
  if (request.status == 200) {
    List<String> portmanteaux = JSON.decode(request.responseText);
    for (int i = 0; i < portmanteaux.length; i++) {
      wordList.children.add(new LIElement()..text = portmanteaux[i]);
    }
  } else {
    wordList.children.add(new LIElement()..text =
        'Request failed, status={$request.status}');
  }
}