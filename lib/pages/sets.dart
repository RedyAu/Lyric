import 'package:fluent_ui/fluent_ui.dart';
import 'package:lyric/elements/topRowButton.dart';
import 'page.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class SetsPage extends StatefulWidget {
  const SetsPage({Key? key}) : super(key: key);

  @override
  _SetsPageState createState() => _SetsPageState();
}

class _SetsPageState extends State<SetsPage> {
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
      body: Center(child: Text("Set editor", style: TextStyle(fontSize: 25))),
      /*rightPane: Center(
          child: Text("Properties pane\nfor selected item in Set",
              style: TextStyle(fontSize: 25))),*/
    );
  }
}
