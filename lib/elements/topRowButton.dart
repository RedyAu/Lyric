import 'package:fluent_ui/fluent_ui.dart';

class TopRowButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Function onPressed;
  final Color? color;

  TopRowButton({
    required this.text,
    this.icon,
    this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Button(
      text: Row(
        children: [
          if (icon != null)
            Container(
              padding: EdgeInsets.only(right: 4),
              child: Icon(
                icon,
                size: 18,
              ),
            ),
          Text(text)
        ],
      ),
      style: ButtonStyle(
          decoration: (buttonState) => BoxDecoration(
              color: (color == null)
                  ? Colors.grey.withAlpha(buttonState.isHovering ? 30 : 255)
                  : color!.withAlpha(buttonState.isHovering ? 30 : 80),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                  color: (color == null)
                      ? Color.fromARGB(255, 100, 100, 100)
                      : color!.withAlpha(150))),
          padding: EdgeInsets.all(5.5)),
      onPressed: () {
        onPressed();
      },
    );
  }
}
