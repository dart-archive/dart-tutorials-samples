
String answer = 'pumpernickel';
List<String> characters = answer.split("");
List<String> hyphens    = answer.replaceAll(new RegExp('.'), '-').split("");

List<String> wrongletters = new List();
String guessedletter = '';
bool dead = false;
bool won = false;

void main() {
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
  guessedletter = '';
}

void revealletters() {
  for (int i = 0; i < characters.length; i++) {
    if (characters[i] == guessedletter) {
      hyphens[i] = guessedletter;
    }
  }
}