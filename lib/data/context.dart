import 'package:fluent_ui/fluent_ui.dart';
import 'package:lyric/data/data.dart';

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
  var selectedFile;

  /// #### For display on manage page
  Folder? selectedFolder;

  /// #### Update displayed file on manage page, and edited file on the corresponding edit page
  void setSelectedFile(var selected) {
    this.selectedFile = selected;
    if (selected is Song)
      this.selectedSong = selected;
    else if (selected is Set) this.selectedSet = selected;
  }
}
