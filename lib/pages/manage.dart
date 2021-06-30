import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:lyric/data/data.dart';
import 'package:lyric/data/context.dart';
import 'package:lyric/data/fileActions.dart';
import 'package:lyric/data/song.dart';
import 'package:lyric/elements/fileSystemButton.dart';
import 'package:lyric/elements/renameDialog.dart';
import 'package:lyric/elements/topRowButton.dart';
import 'page.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:path/path.dart';

class ManagePage extends StatefulWidget {
  ManagePage({Key? key}) : super(key: key);

  @override
  _ManagePageState createState() => _ManagePageState();
}

class _ManagePageState extends State<ManagePage> {
  List<Widget> folderWidgets = [];

  void folderCallback(Folder folder) {
    setState(() {
      lyric<Lyric>().selectedFolder = folder;
      lyric<Lyric>().selectedFile = null;
    });
  }

  void fileCallback(var file) {
    setState(() {
      if (file is Song) {
        lyric<Lyric>().selectedFile = Song.fromFile(file.fileEntity);
      } else {
        lyric<Lyric>().selectedFile = file;
      }
    });
  }

  Future<bool> buildFolders() async {
    print("hello");
    List<Widget> folderWidgets = [
      Container(
        height: 4,
      )
    ];
    for (var folder in data<Data>().folders) {
      folderWidgets.add(FileSystemButton(
          lyric<Lyric>().selectedFolder == folder, folder, folderCallback));
    }
    setState(() {
      this.folderWidgets = folderWidgets;
    });
    return true;
  }

  List<Widget> buildFiles(Folder inFolder) {
    List<Widget> fileWidgets = [Container(height: 4)];
    for (var song in data<Data>()
        .folders
        .firstWhere((folder) => folder == lyric<Lyric>().selectedFolder)
        .songs) {
      fileWidgets.add(FileSystemButton(
          lyric<Lyric>().selectedFile == song, song, fileCallback));
    }
    for (var set in data<Data>()
        .folders
        .firstWhere((folder) => folder == lyric<Lyric>().selectedFolder)
        .sets) {
      fileWidgets.add(FileSystemButton(
          lyric<Lyric>().selectedFile == set, set, fileCallback));
    }
    return fileWidgets;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    buildFolders();
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
        lyric<Lyric>().selectedFolder != null
            ? lyric<Lyric>().selectedFile != null
                ? TopRowButton(
                    text: "Rename file",
                    icon: FeatherIcons.edit3,
                    color: Colors.green,
                    onPressed: () {
                      showRenameDialog(context, lyric<Lyric>().selectedFile);
                    })
                : TopRowButton(
                    text: "Rename folder",
                    icon: FeatherIcons.edit,
                    color: Colors.teal,
                    onPressed: () {
                      showRenameDialog(context, lyric<Lyric>().selectedFolder);
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
                    child: folderWidgets.length > 0
                        ? ListView(
                            children: folderWidgets,
                          )
                        : Center(child: ProgressRing()),
                  ),
                  AnimatedContainer(
                      duration: FluentTheme.of(context).mediumAnimationDuration,
                      width: 5,
                      color: lyric<Lyric>().selectedFolder != null
                          ? Colors.grey[130]
                          : Colors.grey[200]),
                  Expanded(
                      child: lyric<Lyric>().selectedFolder != null
                          ? ListView(
                              children:
                                  buildFiles(lyric<Lyric>().selectedFolder!),
                            )
                          : Center(
                              child: Text(
                                "Choose a folder",
                                style: TextStyle(
                                    color: Colors.grey[130],
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
                  child: lyric<Lyric>().selectedFile == null
                      ? Center(
                          child: Text(
                            "Choose a file",
                            style: TextStyle(
                                color: Colors.grey[130],
                                fontSize: 15,
                                fontStyle: FontStyle.italic),
                          ),
                        )
                      : Text(lyric<Lyric>()
                          .selectedFile
                          .fileEntity
                          .readAsStringSync()),
                )),
          ],
        ),
      ),
    );
  }

  void showRenameDialog(BuildContext context, var toRename) {
    showDialog(
        context: context,
        builder: (context) {
          return RenameDialog(toRename: toRename);
        }).then((renamed) => setState(() {
          buildFolders();
        }));
  }
}
