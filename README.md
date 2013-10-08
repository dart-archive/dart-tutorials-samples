Dart Tutorials
===============
[![Build Status](https://drone.io/github.com/dart-lang/dart-tutorials-samples/status.png)](https://drone.io/github.com/dart-lang/dart-tutorials-samples/latest)

These are small Dart samples used by the online
[Dart tutorials](http://www.dartlang.org/docs/tutorials/).

For links to running versions of all of the apps, visit
[index.html](http://dart-lang.github.io/dart-tutorials-samples/).

Repo and testing
----------------
Currently, drone.io tests only whether the .dart files under web/ pass static analysis (dartanalyzer). We could do real unit testing, and we could do better with HTML samples.

Project structure
-----------------

**web/:**
	Code samples used in the online tutorial. Contains sub-directories to organize the samples by topic.

**tool/:**
	A tool that builds and deploys the gh-pages version of the apps.
	To build the samples and push the changes to the gh-pages repo, run these commands from the top-level directory.
	Make sure Dart is in your path:

    pub update && dart tool/hop_runner.dart pages


**README.md:**
	This file.

**runtests.sh:**
	BASH script that runs dartanalyzer on all Dart source files in the web directory.
