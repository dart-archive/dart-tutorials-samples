Dart Tutorials
===============
[![Build Status](https://drone.io/github.com/dart-lang/dart-tutorials-samples/status.png)](https://drone.io/github.com/dart-lang/dart-tutorials-samples/latest)

These are small Dart samples used by the online
[Dart tutorials](http://www.dartlang.org/docs/tutorials/).

Four samples use Polymer. These samples require Polymer version 0.9.
The samples in  [Write HTTP Clients & Servers](http://www.dartlang.org/docs/tutorials/httpserver) are compatible with Dart 1.3.

Repo and testing
----------------

Currently, drone.io tests only whether the .dart files under web/ and bin/ pass static analysis (dartanalyzer). We could do real unit testing, and we could do better with HTML samples.

Project structure
-----------------

**web/:**
	Browser-based code samples used in the online tutorial. Contains sub-directories to organize the samples by topic.

**bin/:**
	Code samples that run in the standalone VM (not browser-based).

**README.md:**
	This file.

**runtests.sh:**
	BASH script that runs dartanalyzer on all Dart source files in the web/ and bin/ directories.
