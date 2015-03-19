import 'dart:async';

main() async {
//  expensiveA().then((aValue) => expensiveB())
//              .then((bValue) => expensiveC())
//              .then((cValue) => doSomethingWith(cValue));
  await expensiveA();
  await expensiveB();
  doSomethingWith(await expensiveC());
}

Future expensiveA() => new Future.value('from expensiveA');
Future expensiveB() => new Future.value('from expensiveB');
Future expensiveC() => new Future.value('from expensiveC');

doSomethingWith(value) {
  print(value);
}
