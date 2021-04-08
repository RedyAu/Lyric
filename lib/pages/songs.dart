import 'package:fluent_ui/fluent_ui.dart';
import 'page.dart';

class SongsPage extends StatefulWidget {
  const SongsPage({Key? key}) : super(key: key);

  @override
  _SongsPageState createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage> {
  @override
  Widget build(BuildContext context) {
    return PageTemplate([Text("Hello")], Text("Hello SongsPage"));
  }
}
