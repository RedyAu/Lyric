//Rename
import 'dart:io';

import 'package:lyric/data/data.dart';

Directory renameDirectory(Directory dir, String newName) {
  var path = dir.path;
  var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
  var newPath = path.substring(0, lastSeparator + 1) + newName;
  print("Renaming " + path + " to " + newPath);
  return dir.renameSync(newPath);
}

File renameFile(File file, String newName) {
  var path = file.path;
  var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
  var newPath = path.substring(0, lastSeparator + 1) + newName;
  print("Renaming " + path + " to " + newPath);
  return file.renameSync(newPath);
}

/*//Create
Song createSong(String name, Directory dir) {
  //TODO needs XML magic
}

Set createSet(String name, Directory dir) {
  //TODO needs XML magic
}

bool createFolder(String name) {}

Future<bool> convertToLyric(Function setStateCallback) {
  //progress maybe?
  //! Will replace filenames with title from XML and put original filename in tag (if different)!
}*/
