import 'dart:io';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:lyric/data/context.dart';
import 'package:lyric/data/data.dart';
import 'package:lyric/data/fileActions.dart';
import 'package:path/path.dart';
import '../data/song.dart';

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
  Directory? renamedDirectory;

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
              //! Rename
              widget.toRename.fileEntity is File
                  ? renamedFile = renameFile(
                      widget.toRename.fileEntity, newNameController!.text)
                  : renamedDirectory = renameDirectory(
                      widget.toRename.fileEntity, newNameController!.text);
              //! Return new selected in data structure
              data.sync().then((_) {
                if (widget.toRename is Folder) {
                  //* Folder was renamed
                  if (renamedDirectory == null) ; //TODO error handling

                  Folder? toPop = data.folders.firstWhere((element) =>
                      element.fileEntity.path == renamedDirectory!.path);
                  if (toPop == null) ;
                  lyric.selectedFolder = toPop;

                  Navigator.of(context).pop(toPop);
                } else if (widget.toRename is Song) {
                  //* Song was renamed
                  if (renamedFile == null) ;
                  lyric.selectedFolder = data.folders.firstWhere((f) =>
                      f.fileEntity.path ==
                      lyric.selectedFolder!.fileEntity.path);
                  if (lyric.selectedFolder == null) ;

                  Song? toPop = lyric.selectedFolder!.songs.firstWhere(
                      (s) => s.fileEntity!.path == renamedFile!.path); //TODO make sure fileEntity is not null!

                  lyric.setSelectedFile(toPop);

                  Navigator.of(context).pop(toPop);
                } else if (widget.toRename is Set) {
                  //* Set was renamed
                  if (renamedFile == null) ;
                  lyric.selectedFolder = data.folders.firstWhere((f) =>
                      f.fileEntity.path ==
                      lyric.selectedFolder!.fileEntity.path);
                  if (lyric.selectedFolder == null) ;

                  Set? toPop = lyric.selectedFolder!.sets.firstWhere(
                      (s) => s.fileEntity.path == renamedFile!.path);

                  lyric.setSelectedFile(toPop);

                  Navigator.of(context).pop(toPop);
                }
              });

              //TODO implement returning the actual file in the tree
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
