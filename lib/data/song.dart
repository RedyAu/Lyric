import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:path/path.dart';

class Song {
  FileSystemEntity? fileEntity;
  String? title;
  List<Verse>? verses;
  Song({this.fileEntity, this.title, this.verses});
}

class SongNotifier extends ChangeNotifier {
  Song _song = Song();
  Song get song => _song;

  String get title => (_song.fileEntity == null)
      ? ""
      : basenameWithoutExtension(
          _song.fileEntity!.path); //TODO change to read XML

  /*void setSong(Song newSong) { //TODO remove if setter works by itself
    _song = newSong;
    notifyListeners();
  }*/

  set song(Song song) {
    _song = song;
    notifyListeners();
  }
}

class Verse {
  String verseID;
  Verse(this.verseID);
}
