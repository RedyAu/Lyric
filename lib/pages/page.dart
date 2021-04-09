import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fluent_ui/fluent_ui.dart';
//import 'package:bitsdojo_window/bitsdojo_window.dart';

class PageTemplate extends StatelessWidget {
  final List<Widget> actions;
  final Widget body;

  PageTemplate(this.actions, this.body);

  @override
  Widget build(BuildContext context) {
    List<Widget> topRow = [];
    topRow.addAll(actions);
    topRow.add(Expanded(child: MoveWindow()));
    return Container(
        child: Column(
      children: [
        Acrylic(
          child: Container(
            color: Theme.of(context).navigationPanelBackgroundColor,
            height: 41,
            child: Row(
              children: topRow,
            ),
          ),
        ),
        Expanded(child: body)
      ],
    ));
  }
}
