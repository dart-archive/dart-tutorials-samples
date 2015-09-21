Dart Tutorials
===============
[![Build Status](https://drone.io/github.com/dart-lang/dart-tutorials-samples/status.png)](https://drone.io/github.com/dart-lang/dart-tutorials-samples/latest)

These are small Dart samples used by the online
[Dart tutorials](http://www.dartlang.org/docs/tutorials/).

Each directory in this repo represents a tutorial.
The `homepage` field in each pubspec file points to the
corresponding tutorial on www.dartlang.org.

Repo and testing
----------------

Currently, drone.io tests only whether the .dart files under web/ and bin/ pass static analysis (dartanalyzer). We could do real unit testing, and we could do better with HTML samples.

DartPad and Gist Files
----------------------

Some of the tutorial examples execute using
[DartPad](https://dartpad.dartlang.org/).
The DartPad examples are organized so that each complete example is
placed in a subdirectory, with its own pubspec and **web/** directory.

DartPad grabs the source for these examples from 
[gist](https://gist.github.com/) files.
The gist files are generated from the source in this repo using the
[gist generator](https://github.com/kasperpeulen/gist-generator).

You can update the gist files, as follows:

* Clone the repo.
* If needed, activate the gist executable:
  `pub global activate --source git https://github.com/kasperpeulen/gist-generator`
* Change directory to the top of the repo.
* Run "gist generate".
  See the [readme](https://github.com/kasperpeulen/gist-generator)
  for information on available options. If you are updating, or creating,
  gist files rather than generating a test gist,
  or performing a dry run of the gist generator,
  you'll need to provide a Gist token.
  (See the project lead for info on obtaining an existing Gist token.)

Additional files
-----------------
**README.md:**
	This file.

**runtests.sh:**
	BASH script that runs dartanalyzer on all Dart source files in the web/ and bin/ directories.

