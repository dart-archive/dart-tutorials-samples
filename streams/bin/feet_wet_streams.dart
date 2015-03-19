// BEGIN(consuming_a_stream)
import 'dart:async';
// END(consuming_a_stream)

//XXX: Change " to ' in strings?

import 'dart:convert';

// BEGIN(reading_a_file)
import 'dart:io';
// END(reading_a_file)

// BEGIN(consuming_a_stream)
// BEGIN(reading_a_file)
main() {
  // END(consuming_a_stream)
  // END(reading_a_file)

  singleStream();
  streamProperties();
  broadcast();
  streamSubsetsOfData();
  transformingStream();
  validatingStream();

  singleWhere();
  singleError();
  singleErrorWithCatch();

  streamSubscription_handlersOnSubscription();
  streamSubscription_handlerFunctionArgs();

  unsubscribing();
  generic();
  readingAFile();
}

singleStream() {
  // BEGIN(consuming_a_stream)
  // BEGIN(simple_stream_code)
  var data = [1, 2, 3, 4, 5]; // some sample data
  var stream = new Stream.fromIterable(data); // create the stream
  // END(simple_stream_code)

  // subscribe to the streams events
  stream.listen((value) {
    //
    print("Received: $value"); // onData handler
  }); //
}
// END(consuming_a_stream)

Future streamProperties() async {
  var stream;

  // BEGIN(stream_properties)
  stream = new Stream.fromIterable([1, 2, 3, 4, 5]);
  print("stream.first: ${await stream.first}"); // 1

  stream = new Stream.fromIterable([1, 2, 3, 4, 5]);
  print("stream.last: ${await stream.last}"); // 5

  stream = new Stream.fromIterable([1, 2, 3, 4, 5]);
  print("stream.isEmpty: ${await stream.isEmpty}"); // false

  stream = new Stream.fromIterable([1, 2, 3, 4, 5]);
  print("stream.length: ${await stream.length}"); // 5
  // END(stream_properties)
}

Future broadcast() async {
  // BEGIN(as_broadcast_stream)
  var data = [1, 2, 3, 4, 5];
  var stream = new Stream.fromIterable(data);
  var broadcastStream = stream.asBroadcastStream();

  broadcastStream
      .listen((value) => print("stream.listen: $value")); //XXX

  print("stream.first: ${await broadcastStream.first}"); // 1
  print("stream.last: ${await broadcastStream.last}"); // 5
  print("stream.isEmpty: ${await broadcastStream.isEmpty}"); // false
  print("stream.length: ${broadcastStream.length}"); // 5
  // END(as_broadcast_stream)
}

streamSubsetsOfData() {
  var data = [1, 2, 3, 4, 5];
  var stream = new Stream.fromIterable(data);
  // get the stream as a broadcast stream
  var broadcastStream = stream.asBroadcastStream();

  // these all work on a normal single subscriber stream,
  // but using a broadcast stream allows me to attach multiple
  // listeners

  // BEGIN(stream_subsets)
  broadcastStream.where((value) => value % 2 == 0) // divisible by 2
      .listen((value) => print("where: $value")); // where: 2
  // where: 4

  broadcastStream.take(3) // takes only the first three elements
      .listen((value) => print("take: $value")); // take: 1
  // take: 2
  // take: 3

  broadcastStream.skip(3) // skips the first three elements
      .listen((value) => print("skip: $value")); // skip: 4
  // skip: 5

  broadcastStream.takeWhile((value) => value < 3) // take while true
      .listen((value) => print("takeWhile: $value")); // takeWhile: 1
  // takeWhile: 2

  broadcastStream.skipWhile((value) => value < 3) // skip while true
      .listen((value) => print("skipWhile: $value")); // skipWhile: 3
  // skipWhile: 4
  // skipWhile: 5
  // END(stream_subsets)
}

transformingStream() {
  var data = [1, 2, 3, 4, 5]; // some sample data
  var stream = new Stream.fromIterable(data); // create the stream

  // BEGIN(stream_transformer)
  // define a stream transformer
  var transformer = new StreamTransformer.fromHandlers(
      handleData: (value, sink) {
    // create two new values from the original value
    sink.add("Message: $value");
    sink.add("Body: $value");
  });

  // transform the stream and listen to its output
  stream
      .transform(transformer)
      .listen((value) => print("listen: $value"));
  // END(stream_transformer)
}

Future validatingStream() async {
  var data = [1, 2, 3, 4, 5];
  var stream = new Stream.fromIterable(data);
  // get the stream as a broadcast stream
  var broadcastStream = stream.asBroadcastStream();

  // these all work on a normal single subscriber stream,
  // but using a broadcast stream allows me to attach multiple
  // listeners

  // BEGIN(validating_stream_data)
  var result;

  result = await broadcastStream.any((value) => value < 5);
  print("Any less than 5?: $result"); // true

  result = await broadcastStream.every((value) => value < 5);
  print("All less than 5?: $result"); // false

  result = await broadcastStream.contains(4);
  print("Contains 4?: $result"); // true
  // END(validating_stream_data)
}

singleWhere() {
  var data = [1, 2, 3, 4, 5];
  var stream = new Stream.fromIterable(data);
  // get the stream as a broadcast stream
  var broadcastStream = stream.asBroadcastStream();

  // BEGIN(single_where)
  var result;

  // Only one value is less than 2
  result = broadcastStream.singleWhere((value) => value < 2);
  print("single value: $result"); // single value: 1
  // END(single_where)
}

singleError() {
  var data = [1, 2, 3, 4, 5];
  var stream = new Stream.fromIterable(data);
  // get the stream as a broadcast stream
  var broadcastStream = stream.asBroadcastStream();

  Future inner() async {
    var result;

    // BEGIN(failure_using_single)
    try {
      // will fail: the stream has more than one value
      result = broadcastStream.single;
      print("single value: $result");
      return result;
    } catch (e) {
      return e;
    }
    // END(failure_using_single)
  }

  inner().catchError((err) => print("Expected Error: $err"));
}

singleErrorWithCatch() {
  var data = [1, 2, 3, 4, 5];
  var stream = new Stream.fromIterable(data);
  // get the stream as a broadcast stream
  var broadcastStream = stream.asBroadcastStream();

  // BEGIN(catch_error)
  broadcastStream.single // will fail - there is more than one value in the stream
      .then((value) => print("single value: $value"))
      .catchError((err) => print(
          "Expected Error: $err")); // catch any error in the then()
  // output: Expected Error: Bad State: More than one element
  // END(catch_error)
}

Future singleErrorWithCatchAsync() async {
  var data = [1, 2, 3, 4, 5];
  var stream = new Stream.fromIterable(data);
  // get the stream as a broadcast stream
  var broadcastStream = stream.asBroadcastStream();

  // BEGIN(catch_error_async)
  try {
    // single will fail: stream has > 1 value
    print("single value: ${await broadcastStream.single}");
  } catch (e) {
    print("Expected error: $e"); // catch any error
    // output: Expected error: Bad State: Too many elements
  }
  // END(catch_error_async)
}

// XXX: Can I convert this to async*?
streamSubscription_handlersOnSubscription() {
  var data = [1, 2, 3, 4, 5];
  var stream = new Stream.fromIterable(data);

  // BEGIN(subscription_handler_methods)
  // setup the handlers through the subscription's handler methods
  var subscription = stream.listen(null);
  subscription.onData((value) => print("listen: $value"));
  subscription.onError((err) => print("error: $err"));
  subscription.onDone(() => print("done"));
  // END(subscription_handler_methods)
}

streamSubscription_handlerFunctionArgs() {
  var data = [1, 2, 3, 4, 5];
  var stream = new Stream.fromIterable(data);

  // BEGIN(arguments_to_listen)
  // setup the handlers as arguments to the listen() function
  var subscription = stream.listen((value) => print("listen: $value"),
      onError: (err) => print("error: $err"),
      onDone: () => print("done"));
  // END(arguments_to_listen)
}

unsubscribing() {
  var data = [1, 2, 3, 4, 5];
  var stream = new Stream.fromIterable(data);

  // BEGIN(cancelling_a_stream)
  var subscription = stream.listen(null);
  subscription.onData((value) {
    print("listen: $value");
    if (value == 2) subscription.cancel(); // cancel the subscription
  });
  subscription.onError((err) => print("error: $err"));
  subscription.onDone(() => print("done"));
  // END(cancelling_a_stream)
}

generic() {
  // BEGIN(stream_generics)
  var data = [1, 2, 3, 4, 5]; // ints, valid
  // var data = ["1","2","3","4","5"]; // strings, not valid
  var stream = new Stream<int>.fromIterable(data); // Stream<int>
  stream.listen((value) {
    // value must be an int
    print("listen: $value");
  });
  // END(stream_generics)
}

readingAFile() {
  // read this script file
  //var options = new Options();
  var this_file = Platform.script;
  //var thisFilePath = options.script;

  File file = new File(this_file.toFilePath());
  // BEGIN(string_decoder)
  // BEGIN(reading_a_file)
  file
      .openRead()
      .transform(UTF8.decoder)
      .listen((String data) => print(data), // output the data
          onError: (error) => print("Error, could not open file"),
          onDone: () => print("Finished reading data"));
  // END(string_decoder)
}
// END(reading_a_file)
