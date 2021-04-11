import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:lyric/data/data.dart';
import 'package:lyric/elements/fileSystemButton.dart';
import 'package:lyric/elements/topRowButton.dart';
import 'page.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class ManagePage extends StatefulWidget {
  const ManagePage({Key? key}) : super(key: key);

  @override
  _ManagePageState createState() => _ManagePageState();
}

Folder testFolder = Folder(Directory("Lyric"), [], []);
Folder testFolder2 = Folder(Directory("Lyric2"), [], []);
Folder testFolder3 = Folder(Directory("Lyric3"), [], []);

class _ManagePageState extends State<ManagePage> {
  List<Widget> fileWidgets = [];

  var selectedFile;
  Folder? selectedFolder;

  void folderCallback(Folder folder) {
    setState(() {
      selectedFolder = folder;
      selectedFile = null;
      print(selectedFolder!.directory); //TODO Removeme
    });
  }

  void fileCallback(var file) {
    setState(() {
      selectedFile = file;
    });
  }

  List<Widget> buildFolders() {
    print("build folders");
    List<Widget> folderWidgets = [
      Container(
        height: 4,
      )
    ];
    for (var folder in data.folders) {
      folderWidgets.add(
          FileSystemButton(selectedFolder == folder, folder, folderCallback));
      print("Added " + folder.directory.toString());
    }

    return folderWidgets;
  }

  List<Widget> buildFiles(Folder inFolder) {
    print("Build files");
    List<Widget> fileWidgets = [Container(height: 4)];
    for (var song in data.folders
        .firstWhere((folder) => folder == selectedFolder)
        .songs) {
      fileWidgets
          .add(FileSystemButton(selectedFile == song, song, fileCallback));
    }
    for (var set
        in data.folders.firstWhere((folder) => folder == selectedFolder).sets) {
      fileWidgets.add(FileSystemButton(selectedFile == set, set, fileCallback));
    }
    return fileWidgets;
  }

  @override
  void initState() {
    buildFolders();
    print("Manage init");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      leftActions: [
        TopRowButton(
            text: "Search", icon: FeatherIcons.search, onPressed: () {}),
        TopRowButton(
          text: "New",
          onPressed: () {},
          color: Colors.green,
          icon: FeatherIcons.filePlus,
        ),
        TopRowButton(
          text: "New Folder",
          onPressed: () {},
          color: Colors.teal,
          icon: FeatherIcons.folderPlus,
        )
      ],
      body: Row(
        children: [
          Expanded(
            child: ListView(
              children: buildFolders(),
            ),
          ),
          AnimatedContainer(
              duration: Theme.of(context).mediumAnimationDuration!,
              width: 5,
              color: selectedFolder != null
                  ? Color.fromARGB(255, 80, 80, 80)
                  : Theme.of(context).navigationPanelBackgroundColor),
          Expanded(
              child: selectedFolder != null
                  ? ListView(
                      children: buildFiles(selectedFolder!),
                    )
                  : Center(
                      child: Text(
                        "Choose a folder",
                        style: TextStyle(
                            color: Color.fromARGB(255, 100, 100, 100),
                            fontSize: 15,
                            fontStyle: FontStyle.italic),
                      ),
                    ))
        ],
      ),
      rightPane: selectedFile == null
          ? Center(
              child: Text(
                "Choose a file",
                style: TextStyle(
                    color: Color.fromARGB(255, 100, 100, 100),
                    fontSize: 15,
                    fontStyle: FontStyle.italic),
              ),
            )
          : Text(selectedFile.file.readAsStringSync()),
    );
  }
}
