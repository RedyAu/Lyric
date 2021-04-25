import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:lyric/data/data.dart';
import 'package:lyric/data/fileActions.dart';
import 'package:lyric/elements/fileSystemButton.dart';
import 'package:lyric/elements/topRowButton.dart';
import 'page.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:path/path.dart';

class ManagePage extends StatefulWidget {
  const ManagePage({Key? key}) : super(key: key);

  @override
  _ManagePageState createState() => _ManagePageState();
}

class _ManagePageState extends State<ManagePage> {
  List<Widget> fileWidgets = [];

  var selectedFile;
  Folder? selectedFolder;

  void folderCallback(Folder folder) {
    setState(() {
      selectedFolder = folder;
      selectedFile = null;
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
      print("Added " + folder.fileEntity.toString());
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
      rightActions: [
        selectedFolder != null
            ? selectedFile != null
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
                            return RenameDialog(toRename: selectedFolder);
                          }).then((renamed) => setState(() {
                            renamed is Folder
                                ? selectedFolder = renamed
                                : selectedFile = renamed;
                            print(renamed.fileEntity);
                            buildFolders();
                          }));
                    })
            : Container()
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
          : Text(selectedFile.fileEntity.readAsStringSync()),
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
