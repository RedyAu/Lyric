import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:lyric/data/data.dart';
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
  File? selectedFile;
  Folder? selectedFolder;

  void folderCallback(Folder folder) {
    setState(() {
      selectedFolder = folder;
    });
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
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 50),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        child: FolderButton(selectedFolder == testFolder,
                            testFolder, folderCallback),
                      )
                    ],
                  ),
                ),
              ],
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

class FolderButton extends StatelessWidget {
  final bool checked;
  final Folder folder;
  final Function onChanged;

  FolderButton(this.checked, this.folder, this.onChanged);

  @override
  Widget build(BuildContext context) {
    return Button(
        text: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 4, bottom: 2),
                child: Icon(
                  FeatherIcons.folder,
                  size: 18,
                ),
              ),
              Text("Hello"),
            ]),
        onPressed: () {
          onChanged(folder);
          print(checked);
        });
  }
}
