Dart Tutorials
===============
[![Build Status](https://drone.io/github.com/dart-lang/dart-tutorials-samples/status.png)](https://drone.io/github.com/dart-lang/dart-tutorials-samples/latest)

These are small Dart samples used by the online
[Dart tutorials](http://www.dartlang.org/docs/tutorials/).

Four samples use Polymer. These samples require Polymer version 0.9.

Repo and testing
----------------

Currently, drone.io tests only whether the .dart files under web/ pass static analysis (dartanalyzer). We could do real unit testing, and we could do better with HTML samples.

Project structure
-----------------

**web/:**
	Code samples used in the online tutorial. Contains sub-directories to organize the samples by topic.

**README.md:**
	This file.

**runtests.sh:**
	BASH script that runs dartanalyzer on all Dart source files in the web directory.
