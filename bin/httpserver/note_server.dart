// Shows receiving and responding to both GET and POST requests.
// Shows buffering request (which in this example is completely unnecessary)

// Client program is pair_client.dart
// Or you can manually guess the number
// using the URL localhost:4042/# , where # is your guess

import 'dart:io';
import 'dart:convert' show JSON;

int count = 0;

void main() {
  // One note per line.
  new File('notes.txt').readAsLines().then((lines) {
    count = lines.length;
  },
  onError: (_) {count = 0; } );
  
  HttpServer.bind(InternetAddress.LOOPBACK_IP_V6, 4042)
            .then(listenForRequests, onError: printError)
            .catchError((_) => print ('Bind failed.'));
}

void printError(_) {
  print('Bind error.');
}

listenForRequests(_server) {
  _server.listen((HttpRequest request) {
    switch (request.method) {
      case 'POST': 
        handlePost(request);
        break;
      case 'OPTION': 
        handleOptions(request);
        break;
      default:
        defaultHandler(request);
        break;
    }
  },
  onDone: () => print('No more requests.'),
  onError: (_) => print('Server listen failed.') );
}

void handlePost(HttpRequest req) {
  StringBuffer data = new StringBuffer();

  addCorsHeaders(req.response);
  
  req.listen((buffer) {
    data.write(new String.fromCharCodes(buffer));
  },
  onDone: () {
    var decoded = JSON.decode(data.toString());
    
    if (decoded.containsKey('myNote')) {    
      saveNote(req, '${decoded["myNote"]}\n');
    } else { // 'getNote'
      getNote(req, decoded['getNote']);
    }
  },
  onError: (_) {
    print('Request listen error.');
  });
}

saveNote(HttpRequest req, String myNote) {
  new File('notes.txt').writeAsString(myNote, mode: FileMode.APPEND)
      .then((_) { print('Data written.'); });
  count++;
  req.response.statusCode = HttpStatus.OK;
  req.response.writeln('You have $count notes.');
  req.response.close();
}

getNote(HttpRequest req, String getNote) {
  int requestedNote = int.parse(getNote,
      onError: (_) { print('error'); } );
  if (requestedNote == null) {
    requestedNote = 0;
  }
  if (requestedNote >= 0 && requestedNote < count) {
    new File('notes.txt').readAsLines().then((lines) {
      req.response.statusCode = HttpStatus.OK;
      req.response.writeln(lines[requestedNote]);
      req.response.close();
    },
    onError: (_) { print('no'); } );
  }
}

void defaultHandler(HttpRequest req) {
  HttpResponse res = req.response;
  addCorsHeaders(res);
  res.statusCode = HttpStatus.NOT_FOUND;
  res.write('Not found: ${req.method}, ${req.uri.path}');
  res.close();
}

void handleOptions(HttpRequest req) {
  HttpResponse res = req.response;
  addCorsHeaders(res);
  print('${req.method}: ${req.uri.path}');
  res.statusCode = HttpStatus.NO_CONTENT;
  res.close();
}

void addCorsHeaders(HttpResponse res) {
  res.headers.add('Access-Control-Allow-Origin', '*, ');
  res.headers.add('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.headers.add('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept');
}
