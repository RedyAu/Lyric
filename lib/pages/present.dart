import 'package:fluent_ui/fluent_ui.dart';
import 'package:lyric/elements/topRowButton.dart';
import 'page.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class PresentPage extends StatefulWidget {
  const PresentPage({Key? key}) : super(key: key);

  @override
  _PresentPageState createState() => _PresentPageState();
}

class _PresentPageState extends State<PresentPage> {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      leftActions: [
        TopRowButton(
            text: "Search", icon: FeatherIcons.search, onPressed: () {}),
      ],
      rightActions: [
        TopRowButton(text: "To Be Determined", onPressed: () {}),
        TopRowButton(text: "Save As Set", onPressed: () {}),
      ],
      body:
          Center(child: Text("Service order", style: TextStyle(fontSize: 25))),
      rightPane: Center(child: Text("Actions", style: TextStyle(fontSize: 25))),
    );
  }
}
