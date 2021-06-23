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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2),
      child: Button(
        child: Row(
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
            border: ButtonState.all(
              BorderSide(
                color:
                    (color == null) ? Colors.grey[120] : color!.withAlpha(150),
              ),
            ),
            shape: ButtonState.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
            backgroundColor: ButtonState.resolveWith((states) {
              return (color == null)
                  ? Colors.grey.withAlpha(states.isHovering ? 180 : 255)
                  : color!.withAlpha(states.isHovering ? 50 : 80);
            }),
            padding: ButtonState.all(EdgeInsets.all(7))),
        onPressed: () {
          onPressed();
        },
      ),
    );
  }
}
