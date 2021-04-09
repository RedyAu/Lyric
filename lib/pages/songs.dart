import 'package:fluent_ui/fluent_ui.dart';
import 'package:lyric/elements/topRowButton.dart';
import 'page.dart';

class SongsPage extends StatefulWidget {
  const SongsPage({Key? key}) : super(key: key);

  @override
  _SongsPageState createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage> {
  @override
  Widget build(BuildContext context) {
    return PageTemplate([
      TopRowButton(
        text: "Hello 3",
        onPressed: () {},
        color: Colors.green,
        icon: Icons.access_alarm,
      )
    ], Text("Hello SongsPage"));
  }
}
