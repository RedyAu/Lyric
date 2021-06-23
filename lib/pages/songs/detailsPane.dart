import 'package:fluent_ui/fluent_ui.dart';

class DetailsPane extends StatefulWidget {
  @override
  _DetailsPaneState createState() => _DetailsPaneState();
}

class _DetailsPaneState extends State<DetailsPane> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Text("Details pane"),
      ),
    );
  }
}
