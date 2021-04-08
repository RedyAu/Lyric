import 'package:fluent_ui/fluent_ui.dart';
//import 'package:bitsdojo_window/bitsdojo_window.dart';

class PageTemplate extends StatelessWidget {
  final List<Widget> actions;
  final Widget body;
  PageTemplate(this.actions, this.body);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      children: [
        SizedBox(
          height: 30,
          child: Row(
            children: actions,
          ),
        ),
        Expanded(child: body)
      ],
    ));
  }
}
