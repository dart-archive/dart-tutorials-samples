// Automatic client to pair_server.dart.
// Shows two Future series for making a request
// and getting the response.
// Shows data conversion.

import 'dart:html';

String note;

TextInputElement noteTextInput;
ParagraphElement howManyNotes;
TextInputElement chooseNote;
ParagraphElement displayNote;
HttpRequest request;

main() {
  noteTextInput = querySelector('#note_entry');
  howManyNotes = querySelector('#display_how_many_notes');
  chooseNote = querySelector('#choose_note');
  displayNote = querySelector('#display_note');
  
  querySelector('#save_note').onClick.listen(saveNote);
  querySelector('#get_note').onClick.listen(requestNote);
}

void saveNote(Event e) {
  request = new HttpRequest();
  request.onReadyStateChange.listen(onData); 
  
  var url = 'http://localhost:4042';
  request.open('POST', url);
  request.send('{"myNote":"${noteTextInput.value}"}');
}

void requestNote(Event e) {
  int getNoteNumber;
  
  if (chooseNote.value.isEmpty)
    return;
  
  if ((getNoteNumber = int.parse(chooseNote.value, onError: (_) { print('NaN'); } )) == null)
    getNoteNumber = 0;
  
  request = new HttpRequest();
  request.onReadyStateChange.listen(onData); 
  
  var url = 'http://localhost:4042';
  request.open('POST', url);
  request.send('{"getNote":"${getNoteNumber}"}');
}

void onData(_) {
  if (request.readyState == HttpRequest.DONE &&
      request.status == 200) {
    if (request.responseText.startsWith('You')) {
      howManyNotes.text = request.responseText;
    } else {
      displayNote.text = request.responseText;
    }
  } else if (request.readyState == HttpRequest.DONE &&
      request.status == 0) {
    // Status is 0...most likely the server isn't running.
    howManyNotes.text = 'No server';
  }
}