A Game of Darts
===============
[![Build Status](https://drone.io/github.com/dart-lang/dart-tutorials-samples/status.png)](https://drone.io/github.com/dart-lang/dart-tutorials-samples/latest)

These are small Dart samples used by the online Dart tutorials:
[A Game of Darts](http://www.dartlang.org/docs/tutorials/)

Repo and testing
----------------
Currently, drone.io tests only whether the .dart files under web/ pass static analysis (dart_analyzer). We could do real unit testing, and we could do better with HTML samples.

Project structure
-----------------

**web/:**
	Code samples used in the online tutorial. Contains sub-directories to organize the samples by target.

**tool/:**
	A tool that builds the gh-pages deployable version of the apps.
	To run and update the gh-pages repo, run these commands from the top-level directory. Make sure Dart is in your path:

 pub update && dart tool/hop_runner.dart pages

	[Run all of the apps here.](http://dart-lang.github.io/dart-tutorials-samples/)

**README.md:**
	This file.

**runtests.sh:**
       BASH script that runs dart_analyzer on all Dart source files in the web directory.
