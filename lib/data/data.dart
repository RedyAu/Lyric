import 'dart:io';
import 'package:path/path.dart';
import 'song.dart';

final Directory dataDir = Directory("Lyric"); //TODO Make configurable

Data data = Data();

class Data {
  List<Folder> folders = [];

  Future<bool> sync() async {
    print("Syncing...");

    folders = [];

    List<Directory> directories = [dataDir]; //!Init dir list and add root

    //!List root dir to get all folders
    for (var entity in dataDir.listSync().where((e) => e is Directory)) {
      directories.add(Directory(entity.path));
      print("added dir " + entity.path);
    }

    for (Directory dir in directories) {
      folders.add(buildFolder(dir));
    }
    print("Sync complete!");
    return true;
  }
}

Folder buildFolder(Directory dir) {
  List<Song> songs = [];
  List<Set> sets = [];

  for (FileSystemEntity entity in dir.listSync().where((e) => e is File)) {
    File file = File(entity.path);

    if (isSong(file)) {
      songs.add(Song(fileEntity: file));
    } else if (isSet(file)) {
      sets.add(Set(file));
    }
  }

  return Folder(dir, songs, sets);
}

bool isSong(File file) {
  return (extension(file.path) == ".lsong");
}

bool isSet(File file) {
  return (extension(file.path) == ".lset");
}

class Folder {
  Directory fileEntity;
  List<Song> songs;
  List<Set> sets;

  Folder(this.fileEntity, this.songs, this.sets);
}

class Set {
  File fileEntity;

  Set(this.fileEntity);
}
