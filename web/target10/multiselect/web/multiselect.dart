import 'dart:html';
import 'package:web_ui/web_ui.dart';

final Map<String, bool> books = toObservable(
    { 'The Cat in the Hat': true, 'War and Peace': false,
      'Pride and Prejudice': true, 'On the Road': true,
      'The Hunger Games': true, 'The Java Tutorial':  false,
      'The Joy of Cooking': false, 'Goodnight Moon': true }
);

void main() {
  window.onLoad.listen((e) {        
    // Get the OptionElements in the SelectElement.
    List<OptionElement> options = (query('#bookselector') as SelectElement).options;
    print(options.length);
    // Update the selected items in the SelectElement from the Map.
    options.forEach((o) => o.selected = books[o.value] );
  });
}
      
List<String> get booksselected {
  // Return the keys of the selected items.
  return books.keys.where((c) => books[c]).toList();
}

void changeselected(Event e) {
  // Get the selected elements.
  List<OptionElement> options = (query('#bookselector') as SelectElement).selectedOptions;
  // Set everything to false temporarily.
  books.forEach((k, v) => books[k] = false);
  // Set true for selected items.
  options.forEach((e) => books[e.value] = true);
}
