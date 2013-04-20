import 'dart:async';
import 'dart:io';
import 'package:web_ui/component_build.dart' as web_ui;
import 'package:hop/hop.dart';
import 'package:hop/hop_tasks.dart';

String deployFolderName = '.deploy';
String workingBranch = 'hop_gh_pages';

List webUIFiles = ['web/target06/littleben/web/littleben.html',
                   'web/target06/littleben_clock/web/littleben_clock.html',
                   'web/target06/shout/web/shout.html',
                   'web/target06/stopwatch/web/stopwatch.html',
                   'web/target07/adlibitum/web/adlibitum.html',
                   'web/target07/hangman/web/hangman.html',
                   'web/target07/simplehangman/web/simplehangman.html',
                   'web/target08/convertthis/web/convertThis.html',
                   'web/target08/drseuss/web/drseuss.html',
                   'web/target09/its_all_about_you/web/its_all_about_you.html'];

List webUIArgs = ['--', '--no-rewrite-urls'];

List files = ['web/target01/clickme/web/clickme.dart',
              //'web/target01/helloworld/bin/helloworld.dart',
              'web/target02/mini/web/mini.dart',
              'web/target02/mini_with_style/web/mini_with_style.dart',
              'web/target03/anagram/web/anagram.dart',
              'web/target03/todo/web/todo.dart',
              'web/target04/todo_with_delete/web/todo_with_delete.dart',
              'web/target09/portmanteaux/web/portmanteaux.dart',
              'web/target09/portmanteaux_simple/web/portmanteaux_simple.dart'];

Future gitBranchPagesDelete(ctx) => startProcess(ctx, 'git', ['branch', '-D', 'gh-pages']);
Future gitBranchPagesCreate(ctx) => startProcess(ctx, 'git', ['branch', 'gh-pages']);
Future gitBranchPagesCheckout(ctx) => startProcess(ctx, 'git', ['checkout', 'gh-pages']);
Future gitBranchPagesDeleteFilesGit(ctx) => startProcess(ctx, 'git', ['rm', '-rf', '*']);
Future gitBranchPagesDeleteFiles(ctx) => startProcess(ctx, 'rm', ['-rf', 'web', 'packages', 'tool']);
Future gitBranchPagesDeleteGitIgnore(ctx) => startProcess(ctx, 'git', ['rm', '-rf', '.gitignore']);
Future gitBranchPagesCopyFiles(ctx) => startProcess(ctx, 'cp', ['-r', '${deployFolderName}/index.html', '${deployFolderName}/web', '.']);
Future gitBranchPagesAddFiles(ctx) => startProcess(ctx, 'git', ['add', '.']);
Future gitBranchPagesCommitFiles(ctx) => startProcess(ctx, 'git', ['commit', '-m', 'update site']);
Future gitBranchPagesPushFiles(ctx) => startProcess(ctx, 'git', ['push', '-f','origin', 'gh-pages:gh-pages']);
Future gitBranchPagesCheckoutMainBranch(ctx) => startProcess(ctx, 'git', ['checkout', workingBranch]);
Future gitBranchPagesResetHard(ctx) => startProcess(ctx, 'git', ['reset', '--hard']);
Future gitBranchPagesPubUpdate(ctx) => startProcess(ctx, 'pub', ['update']);

/**
 * Build a list of urls to the sample files. 
 */
List<String> buildWebUrls() {
  var urls = new List<String>();

  urls.addAll(webUIFiles.map((String u) {
    List s = u.split('/');
    var last = s.removeLast();
    s.add('out');
    s.add(last);
    return s.join('/');
  }).toList());

  urls.addAll(files.map((String u) => u.replaceAll('.dart', '.html')).toList());

  return urls;
}

/**
 * Write index file for the built samples.
 */
void writeIndexFile() {
  StringBuffer sb = new StringBuffer();
  sb.write(
"""
<!DOCTYPE html>

<html>
<head>
  <meta charset="utf-8">
  <title>dart tutorials samples</title>
</head>
<body>
""");

  buildWebUrls()
  ..sort()
  ..forEach((u) {
    sb.writeln("<a href='$u'>$u</a><br>");
  });

  sb.write(
"""  </body>
</html>
""");

  File indexFile = new File('${deployFolderName}/index.html');
  indexFile.writeAsStringSync(sb.toString());
}

/**
 * Run dart2js on non web_ui web projects. 
 */
Future<bool> dart2js(ctx) {
  ctx.info("executing dart2js");
  Completer completer = new Completer();
  List dart2jsFiles = new List.from(files);

  funcRun(List f) {
    if (f.length == 0) {
      completer.complete(true);
      return;
    }
    var file = f.removeLast();
    startProcess(ctx,
        'dart2js',
        ['--output-type=js',
         '--verbose',
         '--minify',
         '-o${deployFolderName}/$file.js',
         '$file']).then((r) {
           if (r == false) {
             ctx.info("failed on $file");
           }

           funcRun(f);
         });
  };

  funcRun(dart2jsFiles);

  return completer.future;
}

/**
 * Run dart2dart on non web_ui web projects. 
 */
Future<bool> dart2dart(ctx) {
  ctx.info("executing dart2dart");
  Completer completer = new Completer();
  List dart2dartFiles = new List.from(files);

  funcRun(List f) {
    ctx.info("funcRun($f)");
    if (f.length == 0) {
      completer.complete(true);
      return;
    }
    var file = f.removeLast();
    startProcess(ctx,
        'dart2js',
        ['--output-type=dart',
         '--verbose',
         '--minify',
         '-o${deployFolderName}/$file',
         '$file']).then((r) {
           if (r == false) {
             ctx.info("failed on $file");
           }

           funcRun(f);
         });
  };

  ctx.info("dart2dartFiles = $dart2dartFiles");
  funcRun(dart2dartFiles);

  return completer.future;
}

/**
 * Run dart2js and dart2dart on web_ui web projects. 
 */
Future<bool> dart2WebUI(ctx, List bootstrapFiles) {
  ctx.info("executing dart2dart");
  ctx.info("bootstrapFiles = ${bootstrapFiles}");
  var completer = new Completer();
  
  funcRun(List f) {
    if (f.length == 0) {
      completer.complete(true);
      return;
    }
    var file = f.removeLast();
    startProcess(ctx,
        'dart2js',
        ['--output-type=dart',
         '--verbose',
         '--minify',
         '-o${deployFolderName}/$file',
         '$file']).then((r) {
           if (r == false) {
             ctx.info("failed on $file");
           }

           startProcess(ctx,
               'dart2js',
               ['--output-type=js',
                '--verbose',
                '--minify',
                '-o${deployFolderName}/$file.js',
                '$file']).then((r) {
                  if (r == false) {
                    ctx.info("failed on $file");
                  }

                  funcRun(f);
                });
         });
  };

  funcRun(new List.from(bootstrapFiles));

  return completer.future;
}
    
/**
 * Build the pages branch and push to github. 
 */    
buildPages(ctx) {
  ctx.info("executing buildPages");
  var completer = new Completer();

  web_ui.build(webUIArgs, webUIFiles).then(
      (result) {

        ctx.info("==========================================");
        ctx.info("result = ${result}");
        ctx.info("web_ui.build done");
        ctx.info("==========================================");

        startProcess(ctx, 'rsync', ['-RLrk',
                                    '--include=*/',
                                    '--include=packages/browser/dart.js',
                                    '--exclude=packages/***',
                                    '--verbose',
                                    'web', deployFolderName]).then((rsync_result) {

          ctx.info("==========================================");
          ctx.info("result = ${rsync_result}");
          ctx.info("rsync done");
          ctx.info("==========================================");

          dart2js(ctx).then((dart2js_result) {

            ctx.info("==========================================");
            ctx.info("result = ${dart2js_result}");
            ctx.info("dart2js done");
            ctx.info("==========================================");

            dart2dart(ctx).then((dart2dart_result) {

              ctx.info("==========================================");
              ctx.info("result = ${dart2dart_result}");
              ctx.info("dart2dart done");
              ctx.info("==========================================");

              var filesToProcess = new List();
              result.forEach((o) => filesToProcess.addAll(o.outputs.keys.where((f) => f.endsWith("_bootstrap.dart"))));
              
              dart2WebUI(ctx, filesToProcess).then((dart2WebUI_results) {

                ctx.info("==========================================");
                ctx.info("result = ${dart2WebUI_results}");
                ctx.info("dart2WebUI done");
                ctx.info("=========================================="); 
                                 
                writeIndexFile();

                gitBranchPagesDelete(ctx).then((r) {

                  ctx.info("==========================================");
                  ctx.info("result = ${r}");
                  ctx.info("gitBranchPagesDelete done");
                  ctx.info("=========================================="); 

                  gitBranchPagesCreate(ctx).then((r) {

                    ctx.info("==========================================");
                    ctx.info("result = ${r}");
                    ctx.info("gitBranchPagesCreate done");
                    ctx.info("=========================================="); 

                    gitBranchPagesCheckout(ctx).then((r) {

                      ctx.info("==========================================");
                      ctx.info("result = ${r}");
                      ctx.info("gitBranchPagesCheckout done");
                      ctx.info("=========================================="); 

                      gitBranchPagesDeleteFilesGit(ctx).then((r) {

                        ctx.info("==========================================");
                        ctx.info("result = ${r}");
                        ctx.info("gitBranchPagesDeleteFilesGit done");
                        ctx.info("=========================================="); 

                        gitBranchPagesDeleteFiles(ctx).then((r) {

                          ctx.info("==========================================");
                          ctx.info("result = ${r}");
                          ctx.info("gitBranchPagesDeleteFiles done");
                          ctx.info("=========================================="); 

                          gitBranchPagesCopyFiles(ctx).then((r) {

                            ctx.info("==========================================");
                            ctx.info("result = ${r}");
                            ctx.info("gitBranchPagesCopyFiles done");
                            ctx.info("=========================================="); 

                            gitBranchPagesAddFiles(ctx).then((r) {

                              ctx.info("==========================================");
                              ctx.info("result = ${r}");
                              ctx.info("gitBranchPagesAddFiles done");
                              ctx.info("=========================================="); 

                              gitBranchPagesCommitFiles(ctx).then((r) {

                                ctx.info("==========================================");
                                ctx.info("result = ${r}");
                                ctx.info("gitBranchPagesCommitFiles done");
                                ctx.info("=========================================="); 

                                gitBranchPagesPushFiles(ctx).then((r) {

                                  ctx.info("==========================================");
                                  ctx.info("result = ${r}");
                                  ctx.info("gitBranchPagesPushFiles done");
                                  ctx.info("=========================================="); 

                                  gitBranchPagesCheckoutMainBranch(ctx).then((r) {

                                    ctx.info("==========================================");
                                    ctx.info("result = ${r}");
                                    ctx.info("gitBranchPagesCheckoutMainBranch done");
                                    ctx.info("=========================================="); 

                                    gitBranchPagesResetHard(ctx).then((r) {

                                      ctx.info("==========================================");
                                      ctx.info("result = ${r}");
                                      ctx.info("gitBranchPagesResetHard done");
                                      ctx.info("=========================================="); 

                                      gitBranchPagesPubUpdate(ctx).then((r) {

                                        ctx.info("==========================================");
                                        ctx.info("result = ${r}");
                                        ctx.info("gitBranchPagesPubUpdate done");
                                        ctx.info("=========================================="); 

                                        completer.complete(true);
                                      });
                                    });
                                  });
                                });
                              });
                            });
                          });
                        });
                      });
                    });
                  });
                });                  
              });
            });
          });
        });
      });

  return completer.future;
}

void main() {
  _assertKnownPath();

  addAsyncTask('pages', buildPages);

  // dart tool/hop_runner.dart --log-level all --allow-dirty
  addAsyncTask('clean', (ctx) => startProcess(ctx, 'rm', ['-rf', deployFolderName]));

  runHop();
}

void _assertKnownPath() {
  // since there is no way to determine the path of 'this' file
  // assume that Directory.current() is the root of the project.
  // So check for existance of /bin/hop_runner.dart
  final thisFile = new File('tool/hop_runner.dart');
  assert(thisFile.existsSync());
}