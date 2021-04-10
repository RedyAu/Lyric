import 'package:fluent_ui/fluent_ui.dart';
import 'package:lyric/pages/page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
        body: Center(child: Text("Settings", style: TextStyle(fontSize: 25))));
  }
}
