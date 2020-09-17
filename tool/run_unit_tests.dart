#! /usr/bin/env dcli

import 'package:dcli/dcli.dart';

///
/// running unit tests from vs-code doesn't seem to work as it spawns
/// two isolates and runs tests in parallel (even when using the -j1 option)
/// Given we are actively modifying the file system this is a bad idea.
/// So this script forces the test to run serially via the -j1 option.
///
void main() {
  var root = Script.current.pathToProjectRoot;

  print(orange('cleaning old test and build artifacts'));

  if (exists('/tmp/dcli')) deleteDir('/tmp/dcli', recursive: true);

  /// remove all of the test artifacts from our test_scripts
  /// so we are in a clean state.
  /// The artifacts (e.g. .packages) also have paths that won't
  /// be valide in our test file system.
  print('purging test artifacts');
  DartProject.fromPath(join(root, 'test', 'test_scripts')).purge();


  
  /// we need to clean before we can run unit test script
  DartProject.fromPath(root).clean();



  print('Run unit tests from $root');
  '${DartSdk().pathToPubExe} run test -j1 --coverage ${join(root, 'coverage')}'
      .start(nothrow: true, workingDirectory: root);

  // cleanup temp
  if (exists('/tmp/dcli')) deleteDir('/tmp/dcli', recursive: true);
}
