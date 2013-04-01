String answer = 'ambidextrous';

List<String> characters   = answer.split("");
List<String> hyphens      = answer.replaceAll(new RegExp('.'), '-').split("");
List<String> wrongletters = new List();
List<List> hangmandisplay;

String guessedletter = '';
bool dead = false;
bool won = false;

void main() {
  setUpHangmanGrid();
}

void checkit() {
  const int maxwrong = 7;
  if (characters.contains(guessedletter)) {  // guess is correct
    revealletters();
    if (!hyphens.contains('-')) {
      won = true;
    }
  } else {                                   // guess is wrong
    revealnewbodypart();                                  
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

void revealnewbodypart() {
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

void setUpHangmanGrid() {
  var gallows = [ '+---+  ',
                  '\|      ',
                  '\|      ',
                  '\|      ',
                  '\|      ' ];
  hangmandisplay = new List(gallows.length);
  
  for (int i = 0; i < gallows.length; i++) {
    List<String> row = gallows[i].split("");
    hangmandisplay[i] = row;
  }
}
