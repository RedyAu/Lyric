import 'package:fluent_ui/fluent_ui.dart';
import 'package:lyric/data/data.dart';
import 'song.dart';
import 'dart:io';

AppContext lyric = AppContext();

class AppContext {
  //* Scroll controllers
  ScrollController manageFoldersController = ScrollController();
  ScrollController manageFilesController = ScrollController();

  //* Selecteds
  /// #### For editing on sets page
  Set? selectedSet;

  /// #### For editing on songs page
  Song? selectedSong;

  /// #### For display on manage page
  /// #### Update displayed file on manage page, and edited file on the corresponding edit page
  var _selectedFile;
  FileSystemEntity get selectedFile => _selectedFile;
  set selectedFile(FileSystemEntity newFile) {
    _selectedFile = newFile;
    if (newFile is Song)
      this.selectedSong = newFile;
    else if (newFile is Set) this.selectedSet = newFile;
  }

  /// #### For display on manage page
  Folder? selectedFolder;
}