import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:lyric/data/data.dart';
import 'package:lyric/data/context.dart';
import 'package:lyric/data/fileActions.dart';
import 'package:lyric/elements/fileSystemButton.dart';
import 'package:lyric/elements/topRowButton.dart';
import 'page.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:path/path.dart';

// ignore: must_be_immutable
class ManagePage extends StatefulWidget {
  Function updateTopRowButtons;
  ManagePage(this.updateTopRowButtons, {Key? key}) : super(key: key);

  @override
  _ManagePageState createState() => _ManagePageState();
}

class _ManagePageState extends State<ManagePage> {
  List<Widget> fileWidgets = [];

  void folderCallback(Folder folder) {
    setState(() {
      lyric.selectedFolder = folder;
      lyric.selectedFile = null;
    });
  }

  void fileCallback(var file) {
    setState(() {
      lyric.selectedFile = file;
      if (file is Song)
        lyric.selectedSong = file;
      else if (file is Set) lyric.selectedSet = file;
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
      folderWidgets.add(FileSystemButton(
          lyric.selectedFolder == folder, folder, folderCallback));
      print("Added " + folder.fileEntity.toString());
    }

    return folderWidgets;
  }

  List<Widget> buildFiles(Folder inFolder) {
    print("Build files");
    List<Widget> fileWidgets = [Container(height: 4)];
    for (var song in data.folders
        .firstWhere((folder) => folder == lyric.selectedFolder)
        .songs) {
      fileWidgets.add(
          FileSystemButton(lyric.selectedFile == song, song, fileCallback));
    }
    for (var set in data.folders
        .firstWhere((folder) => folder == lyric.selectedFolder)
        .sets) {
      fileWidgets
          .add(FileSystemButton(lyric.selectedFile == set, set, fileCallback));
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
      rightActions: [
        lyric.selectedFolder != null
            ? lyric.selectedFile != null
                ? TopRowButton(
                    text: "Rename file",
                    icon: FeatherIcons.edit3,
                    color: Colors.green,
                    onPressed: () {})
                : TopRowButton(
                    text: "Rename folder",
                    icon: FeatherIcons.edit,
                    color: Colors.teal,
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return RenameDialog(toRename: lyric.selectedFolder);
                          }).then((renamed) => setState(() {
                            //TODO nah
                            renamed is Folder
                                ? lyric.selectedFolder = renamed
                                : lyric.selectedFile = renamed;
                            buildFolders();
                          }));
                    })
            : Container()
      ],
      body: Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    child: ListView(
                      children: buildFolders(),
                    ),
                  ),
                  AnimatedContainer(
                      duration: FluentTheme.of(context).mediumAnimationDuration,
                      width: 5,
                      color: lyric.selectedFolder != null
                          ? Color.fromARGB(255, 80, 80, 80)
                          : FluentTheme.of(context)
                              .navigationPaneTheme
                              .backgroundColor),
                  Expanded(
                      child: lyric.selectedFolder != null
                          ? ListView(
                              children: buildFiles(lyric.selectedFolder!),
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
            ),
            Expanded(
                flex: 1,
                child: Container(
                  color: Colors.grey[200],
                  child: lyric.selectedFile == null
                      ? Center(
                          child: Text(
                            "Choose a file",
                            style: TextStyle(
                                color: Color.fromARGB(255, 100, 100, 100),
                                fontSize: 15,
                                fontStyle: FontStyle.italic),
                          ),
                        )
                      : Text(lyric.selectedFile.fileEntity.readAsStringSync()),
                )),
          ],
        ),
      ),
    );
  }
}

class RenameDialog extends StatefulWidget {
  final toRename;

  RenameDialog({required this.toRename});

  @override
  _RenameDialogState createState() => _RenameDialogState();
}

class _RenameDialogState extends State<RenameDialog> {
  TextEditingController? newNameController;
  @override
  void initState() {
    newNameController = TextEditingController.fromValue(
        TextEditingValue(text: basename(widget.toRename.fileEntity.path)));

    super.initState();
  }

  File? renamedFile;
  Directory? renamedFolder;

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Text("Átnevezés"),
      content: Column(
        children: [
          TextBox(
            autofocus: true,
            controller: newNameController,
          ) //Display just path
        ],
      ),
      actions: [
        Button(
            child: Text("Átnevezés"),
            onPressed: () {
              widget.toRename.fileEntity is File
                  ? renamedFile = renameFile(
                      widget.toRename.fileEntity, newNameController!.text)
                  : renamedFolder = renameDirectory(
                      widget.toRename.fileEntity, newNameController!.text);
              data.sync().then((value) => Navigator.of(context).pop(renamedFile ==
                      null
                  ? data.folders.firstWhere((element) =>
                      element.fileEntity.path == renamedFolder!.path)
                  : renamedFile!)); //TODO implement returning the actual file in the tree
            }),
        Button(
            child: Text("Mégse"),
            onPressed: () {
              Navigator.pop(context);
            })
      ],
    );
  }
}
