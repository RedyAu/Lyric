import 'package:fluent_ui/fluent_ui.dart';

class NonClickablePaneItem extends PaneItemHeader {
  final Widget child;
  NonClickablePaneItem(this.child) : super(header: child);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
