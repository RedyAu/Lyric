import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'data.dart';
import 'song.dart';
import 'dart:io';
import 'package:get_it/get_it.dart';

//AppContext lyric = AppContext();

final lyric = GetIt.instance;

void lyricInit() {
  lyric.registerSingleton<Lyric>(Lyric());
  lyric.registerSingleton<Data>(Data());
}

class Lyric extends ChangeNotifier {
  /* //Scroll controllers
  ScrollController manageFoldersController = ScrollController();
  ScrollController manageFilesController = ScrollController(); */

  //* Selecteds
  /// #### For editing on songs page
  ValueNotifier<Song?> selectedSong = ValueNotifier(null);

  /// #### For editing on sets page
  ValueNotifier<Set?> selectedSet = ValueNotifier(null);
  //Set? _selectedSet;

  /// #### For display on manage page
  /// #### Update displayed file on manage page, and edited file on the corresponding edit page
  var _selectedFile;
  get selectedFile => _selectedFile;
  set selectedFile(var newFile) {
    print("HALO SETTER JE");
    //print(selectedSong.value ?? Song(title: "null song"));
    _selectedFile = newFile;
    if (newFile is Song) {
      this.selectedSong.value = newFile;
    } else if (newFile is Set) {
      this.selectedSet.value = newFile;
    }
    //TODO add theme and etc
    notifyListeners();
  }

  /// #### For display on manage page
  Folder? selectedFolder;
}
