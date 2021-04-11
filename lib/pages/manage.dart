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

  File? selectedFile;
  Folder? selectedFolder;

  void folderCallback(Folder folder) {
    setState(() {
      selectedFolder = folder;
      print(selectedFolder!.directory); //TODO Removeme
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
      folderWidgets
          .add(FileSystemButton(selectedFolder == folder, folder, folderCallback));
      print("Added " + folder.directory.toString());
    }

    return folderWidgets;
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
          Container(
              width: 5,
              color: Theme.of(context).navigationPanelBackgroundColor),
          Expanded(child: Container())
        ],
      ),
      rightPane: selectedFile == null
          ? Center(
              child: Text("Selected item details pane",
                  style: TextStyle(fontSize: 25)))
          : null,
    );
  }
}
