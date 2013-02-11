import 'dart:html';
import 'dart:json' as JSON;

var wordlist;

void main() {
  query('#getwords').onClick.listen(makerequest);
  wordlist = query('#wordlist');
}

void makerequest(Event e) {
  var path = 'portmanteaux_request.json';
  HttpRequest.request(path).then(
    (httprequest) {
      onSuccess(httprequest);
    },
    onError: (e) {
      wordlist.children.add(new LIElement()..text = 'Request failed, error status: ${e.cause}');
    }
  );
}

onSuccess(HttpRequest request) {
  List<String> portmanteaux = JSON.parse(request.responseText);
  for (int i = 0; i < portmanteaux.length; i++) {
    wordlist.children.add(new LIElement()..text = portmanteaux[i]);
  }
}