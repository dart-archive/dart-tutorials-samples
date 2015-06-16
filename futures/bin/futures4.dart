import 'dart:async';

main() async {
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
