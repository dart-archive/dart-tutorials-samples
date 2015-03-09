import 'dart:async';

main() async {
//  Future.wait([expensiveA(), expensiveB(), expensiveC()])
//        .then((List responses) => chooseBestResponse(responses))
//        .catchError((e) => handleError(e));
  try {
    List responses =
        await Future.wait([expensiveA(), expensiveB(), expensiveC()]);
    chooseBestResponse(responses);
  } catch (e) {
    handleError(e);
  }
}

Future expensiveA() => new Future.value('from expensiveA');
Future expensiveB() => new Future.value('from expensiveB');
Future expensiveC() => new Future.value('from expensiveC');

doSomethingWith(value) {
  print(value);
}

chooseBestResponse(List responses) {
  print(responses[1]);
//  throw new Error();
}

handleError(e) {
  print('error handled');
}