import 'dart:io';
import 'package:path/path.dart';

final Directory dataDir = Directory("Lyric"); //TODO Make configurable

Data data = Data();

class Data {
  List<Folder> folders = [];

  Future<bool> sync() async {
    List<Directory> directories = [dataDir]; //!Init dir list and add root

    //!List root dir to get all folders
    for (var entity in dataDir.listSync().where((e) => e is Directory)) {
      directories.add(Directory(entity.path));
      print("added dir " + entity.path);
    }

    for (Directory dir in directories) {
      List<Song> songs = [];
      List<Set> sets = [];

      for (var entity in dir.listSync().where((e) => e is File)) {
        File file = File(entity.path);

        if (isSong(file)) {
          songs.add(Song(file));
        } else if (isSet(file)) {
          sets.add(Set(file));
        }
      }

      folders.add(Folder(dir, songs, sets));
    }

    return true;
  }

  bool isSong(File file) {
    return (extension(file.path) == ".lsong");
  }

  bool isSet(File file) {
    return (extension(file.path) == ".lset");
  }
}

class Folder {
  Directory directory;
  List<Song> songs;
  List<Set> sets;

  Folder(this.directory, this.songs, this.sets);
}

class Song {
  File file;
  String name = "";

  Song(this.file);
}

class Set {
  File file;
  String name = "";

  Set(this.file);
}
