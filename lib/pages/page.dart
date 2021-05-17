import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fluent_ui/fluent_ui.dart';
//import 'package:bitsdojo_window/bitsdojo_window.dart';

class PageTemplate extends StatelessWidget {
  final List<Widget>? rightActions;
  final List<Widget>? leftActions;
  final Widget body;

  PageTemplate({this.leftActions, this.rightActions, required this.body});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.grey[200],
          height: 41,
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Row(children: [
                  ((leftActions != null)
                      ? Row(children: leftActions!)
                      : Container()),
                  Expanded(child: MoveWindow()),
                  ((rightActions != null)
                      ? Row(children: rightActions!)
                      : Container())
                ]),
              ),
              Expanded(flex: 2, child: MoveWindow())
            ],
          ),
        ),
        body,
        /*(rightPane == null)
            ? Expanded(child: body)
            : Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(flex: 4, child: body),
                    Expanded(
                        flex: 2,
                        child: Container(
                            color: FluentTheme.of(context)
                                .navigationPaneTheme
                                .backgroundColor,
                            child: ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: 400),
                                child: rightPane!)))
                  ],
                ),
              )*/
      ],
    );
  }
}
