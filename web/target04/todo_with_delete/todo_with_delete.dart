import 'dart:html';

InputElement toDoInput;
UListElement toDoList;
ButtonElement deleteAll;

void main() {
  toDoInput = query('#to-do-input');
  toDoList = query('#to-do-list');
  toDoInput.on.change.add(addToDoItem);
  deleteAll = query('#delete-all');
  deleteAll.on.click.add((e) => toDoList.children.clear());
}

void addToDoItem(Event e) {
  var newToDo = new LIElement();
  newToDo.text = toDoInput.value;
  newToDo.on.click.add((e) => newToDo.remove());
  toDoInput.value = '';
  toDoList.children.add(newToDo);
}
