The slambook Example
====================

The code in `slambookserver.dart` implements an HTTP server
that handles POST requests by echoing the data sent by the
client back to the client. The server must also handle
OPTIONS requests to allow cross-domain requests.

* Run the server with `dart slambookserver.dart`.

* Run the client by loading `slambook.html` in Dartium.

For a detailed description of the server and how it
works refer to
[Get Data from a Form](http://www.dartlang.org/docs/tutorials/forms/).
in the Dart Tutorials.
