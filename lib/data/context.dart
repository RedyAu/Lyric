import 'package:fluent_ui/fluent_ui.dart';
import 'package:lyric/data/data.dart';

AppContext lyric = AppContext();

class AppContext {
  //* Scroll controllers
  ScrollController manageFoldersController = ScrollController();
  ScrollController manageFilesController = ScrollController();

  //* Selecteds
  Set? selectedSet;
  Song? selectedSong;
  var selectedFile;
  Folder? selectedFolder;
}