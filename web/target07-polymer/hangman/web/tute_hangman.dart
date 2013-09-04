import 'package:polymer/polymer.dart';

@CustomTag('tute-hangman')
class TuteHangman extends PolymerElement with ObservableMixin {

  String answer = 'ambidextrous';
  
  @observable List<String> characters;
  @observable List<String> hyphens;
  @observable List<String> wrongletters;
  @observable bool hazWrongLetters;
  @observable List<List> hangmandisplay;
  
  @observable String guessedletter = '';
  @observable bool dead = false;
  @observable bool won = false;
  @observable bool   stillPlaying = true;
  
  void created() {
    super.created();
    characters = answer.split("");
    hyphens      = toObservable(answer.replaceAll(new RegExp('.'), '-').split(""));
    wrongletters = toObservable(new List());
    hazWrongLetters = false;

    _setUpHangmanGrid();
  }
  
  void checkit() {
    const int maxwrong = 7;
    if (characters.contains(guessedletter)) {  // guess is correct
      _revealletters();
      if (!hyphens.contains('-')) {
        won = true;
      }
    } else {                                   // guess is wrong
      _revealnewbodypart();                                  
      wrongletters.add(guessedletter);
      if (wrongletters.length == maxwrong) {
        dead = true;
      }
    }
    hazWrongLetters = (wrongletters.length == 0) ? false : true;
    stillPlaying = !dead && !won;
    guessedletter = '';
  }
  
  void _revealletters() {
    for (int i = 0; i < characters.length; i++) {
      if (characters[i] == guessedletter) {
        hyphens[i] = guessedletter;
      }
    }
  }
  
  void _revealnewbodypart() {
    // triplets: row, col, character for body part
    var deadmanparts = [ [1,4,'0'],   /* head */
                         [2,3,'\/'],  /* left arm */
                         [2,4,'\|'],  /* upper body */
                         [2,5, '\\'], /* right arm */
                         [3,4, '\|'], /* lower body */
                         [4,3, '\/'], /* left leg */
                         [4,5,'\\']   /* right leg */
                       ];
  
    var row = deadmanparts[wrongletters.length][0];
    var col = deadmanparts[wrongletters.length][1];
    hangmandisplay[row][col] = deadmanparts[wrongletters.length][2];
  }
  
  void _setUpHangmanGrid() {
    var gallows = [ '+---+  ',
                    '\|      ',
                    '\|      ',
                    '\|      ',
                    '\|      ' ];
    hangmandisplay = new List(gallows.length);
    
    for (int i = 0; i < gallows.length; i++) {
      List<String> row = gallows[i].split("");
      hangmandisplay[i] = toObservable(row);
    }
  }
}