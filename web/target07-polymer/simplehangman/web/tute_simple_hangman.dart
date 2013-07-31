import 'package:polymer/polymer.dart';

@CustomTag('tute-simple-hangman')
class TuteSimpleHangman extends PolymerElement with ObservableMixin {

  String answer = 'pumpernickel';
  
  @observable List<String> characters;
  @observable List<String> hyphens;
  @observable List<String> wrongletters;
  @observable bool hazWrongLetters;
  
  @observable String guessedletter = '';
  @observable bool   dead = false;
  @observable bool   won = false;
  @observable bool   stillPlaying = true;
  
  void created() {
    super.created();
    characters   = answer.split("");
    hyphens      = toObservable(answer.replaceAll(new RegExp('.'), '-').split(""));
    wrongletters = toObservable(new List());
    hazWrongLetters = false;
  }
    
  void checkit() {  
    const int maxwrong = 7;

    if (characters.contains(guessedletter)) {  // guess is correct
      revealletters();
      if (!hyphens.contains('-')) {
        won = true;
      }
    } else {                                   // guess is wrong
      wrongletters.add(guessedletter);
      if (wrongletters.length == maxwrong) {
        dead = true;
      }
    }
    hazWrongLetters = (wrongletters.length == 0) ? false : true;
    stillPlaying = !dead && !won;
    guessedletter = '';
  }
  
  void revealletters() {
    for (int i = 0; i < characters.length; i++) {
      if (characters[i] == guessedletter) {
        hyphens[i] = guessedletter;
      }
    }
  }
}