import 'package:fluent_ui/fluent_ui.dart';
import 'package:lyric/elements/topRowButton.dart';
import 'page.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class SongsPage extends StatefulWidget {
  @override
  _SongsPageState createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage> {
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
        )
      ],
      rightActions: [
        TopRowButton(
            text: "Manage", icon: FeatherIcons.folder, onPressed: () {}),
        TopRowButton(
            text: "Save",
            color: Colors.blue,
            icon: FeatherIcons.save,
            onPressed: () {}),
        TopRowButton(
            text: "Present",
            color: Colors.orange,
            icon: FeatherIcons.airplay,
            onPressed: () {})
      ],
      body: Center(child: Text("Song editor", style: TextStyle(fontSize: 25))),
      /*rightPane: Center(
          child:
              Text("Song editor details pane", style: TextStyle(fontSize: 25))),*/
    );
  }
}
