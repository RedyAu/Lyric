import 'package:lyric/data/data.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:path/path.dart';

class FileSystemButton extends StatelessWidget {
  final bool checked;
  final Folder folder;
  final Function onChanged;

  FileSystemButton(this.checked, this.folder, this.onChanged);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 4, bottom: 4, right: checked ? 0 : 3),
      height: 30,
      child: HoverButton(
        builder: (context, buttonStates) {
          return FocusBorder(
              focused: (buttonStates.isFocused),
              child: AnimatedContainer(
                  decoration: BoxDecoration(
                      color: (buttonStates.isHovering)
                          ? Color.fromARGB(255, 100, 100, 100)
                          : checked
                              ? Color.fromARGB(255, 80, 80, 80)
                              : Colors.grey,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4),
                          bottomLeft: Radius.circular(4),
                          topRight: checked ? Radius.zero : Radius.circular(4),
                          bottomRight:
                              checked ? Radius.zero : Radius.circular(4))),
                  padding: EdgeInsets.all(3),
                  duration: Theme.of(context).mediumAnimationDuration!,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Icon(FeatherIcons.folder),
                      ),
                      Text(basename(folder.directory.path)),
                      Spacer(),
                      if (checked) Icon(FeatherIcons.chevronRight)
                    ],
                  )));
        },
        onPressed: () {
          onChanged(folder);
        },
      ),
    );
  }
}
