// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:polymer/builder.dart';

void main() {
  build(entryPoints: ['web/anagram.html',
                      'web/clickme.html',
                      'web/count_down.html',
                      'web/helloworld.html',
                      'web/its_all_about_you.html',
                      'web/mini.html',
                      'web/mini_with_style.html',
                      'web/portmanteaux.html',
                      'web/portmanteaux_simple.html',
                      'web/slambook.html', 
                      'web/stopwatch.html',
                      'web/todo.html',
                      'web/todo_with_delete.html'], options: parseOptions(['--deploy']));
}

