import 'dart:html';
import 'dart:json' as json;
import 'package:web_ui/web_ui.dart';

class SlamBookComponent extends WebComponent {
  
  // Set up the maps for the form and give initial values.
  // Boolean values in this map are bound with bind-checked to checkboxes.
  @observable Map<String, bool> favoriteThings = toObservable({
    'kittens': true, 'raindrops': false,
    'mittens': true, 'kettles': false});
  
  // This map contains the rest of the forma data.
  @observable Map theData = toObservable({
    'firstName':      'mem',
    'favoriteQuote':  'Enjoy all your meals.',
    'favoriteColor':  '#4169E1',
    'birthday':       '1963-08-30',
    'volume':         '11', //I want this to be bound to an integer!
    'catOrDog':       'dog',
    'music':          2,
    'zombies':        true
    // Add favoriteThings later...can't do it here...there is no this.
  });

  @observable String serverResponse = '';
  HttpRequest request;

  void submitForm(Event e) {
    e.preventDefault(); // Don't do the default submit.
       
    request = new HttpRequest();
    
    request.onReadyStateChange.listen(onData); 
    
    // POST the data to the server.
    var url = 'http://127.0.0.1:4040';
    request.open('POST', url);
    request.send(slambookAsJsonData());
  }
  
  void onData(_) {
    if (request.readyState == HttpRequest.DONE &&
        request.status == 200) {
      // Data saved OK.
      serverResponse = 'Server Sez: ' + request.responseText;
    } else if (request.readyState == HttpRequest.DONE &&
        request.status == 0) {
      // Status is 0...most likely the server isn't running.
      serverResponse = 'No server';
    }
  }
   
  void resetForm(Event e) {
    e.preventDefault(); // Default behavior clears elements,
                        // but bound values don't follow
                        // so have to do this explicitly.
    favoriteThings['kittens'] = false;
    favoriteThings['raindrops'] = false;
    favoriteThings['mittens'] = false;
    favoriteThings['kettles'] = false;
    
    theData['firstName'] = '';
    theData['favoriteQuote'] = '';
    theData['favoriteColor'] = '#FFFFFF';
    theData['birthday'] = '2013-01-01';
    theData['volume'] = '0';
    theData['catOrDog'] = 'cat';
    theData['music'] = 0;
    theData['zombies'] = false;
    serverResponse = 'Data cleared.';
  }
  
  String slambookAsJsonData() {
    // Put favoriteThings in the map.
    theData['favoriteThings'] = favoriteThings;
    return json.stringify(theData);
  }
}
