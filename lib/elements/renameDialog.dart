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
                  ? renamedFile =
                      renameFile(widget.toRename.fileEntity, newNameController!.text)
                  : renamedDirectory = renameDirectory(
                      widget.toRename.fileEntity, newNameController!.text);
              //! Return new selected in data structure
              data<Data>().sync().then((_) {
                if (widget.toRename is Folder) {
                  //* Folder was renamed
                  if (renamedDirectory == null) ; //TODO error handling

                  Folder? toPop = data<Data>().folders.firstWhere((element) =>
                      element.fileEntity.path == renamedDirectory!.path);
                  if (toPop == null) ;
                  lyric<Lyric>().selectedFolder = toPop;

                  Navigator.of(context).pop(toPop);
                } else if (widget.toRename is Song) {
                  //* Song was renamed
                  if (renamedFile == null) ;
                  lyric<Lyric>().selectedFolder = data<Data>()
                      .folders
                      .firstWhere((f) =>
                          f.fileEntity.path ==
                          lyric<Lyric>().selectedFolder!.fileEntity.path);
                  if (lyric<Lyric>().selectedFolder == null) ;

                  Song? toPop = lyric<Lyric>().selectedFolder!.songs.firstWhere(
                      (s) =>
                          s.fileEntity.path ==
                          renamedFile!
                              .path); //TODO make sure fileEntity is not null!

                  lyric<Lyric>().selectedFile = toPop;

                  Navigator.of(context).pop(toPop);
                } else if (widget.toRename is Set) {
                  //* Set was renamed
                  if (renamedFile == null) ;
                  lyric<Lyric>().selectedFolder = data<Data>()
                      .folders
                      .firstWhere((f) =>
                          f.fileEntity.path ==
                          lyric<Lyric>().selectedFolder!.fileEntity.path);
                  if (lyric<Lyric>().selectedFolder == null) ;

                  Set? toPop = lyric<Lyric>().selectedFolder!.sets.firstWhere(
                      (s) => s.fileEntity.path == renamedFile!.path);

                  lyric<Lyric>().selectedFile = toPop;

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
