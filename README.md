These are small Dart samples used by the online
[Dart tutorials](https://dart.dev/tutorials).

Each directory in this repo represents a tutorial.
The `homepage` field in each pubspec file points to the
corresponding tutorial on [dart.dev](https://dart.dev/).

## DartPad and Gist Files

Some of the tutorial examples execute using
[DartPad](https://dartpad.dev/).
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

## Additional files

**README.md:**
	This file.

**runtests.sh:**
	BASH script that runs dartanalyzer on all Dart source files in the web/ and bin/ directories.

