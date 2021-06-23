import 'package:fluent_ui/fluent_ui.dart';

class EditorPane extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView(
      children: [VerseRow()],
    ));
  }
}

class VerseRow extends StatefulWidget {
  @override
  _VerseRowState createState() => _VerseRowState();
}

class _VerseRowState extends State<VerseRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.grey[180], borderRadius: BorderRadius.circular(7)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 60,
              child:
                  VerseButton(onPressed: () {}, verseID: "V2", checked: false),
            ),
            Expanded(
                child: Padding(
                  padding: EdgeInsets.all(3),
                  child: TextBox(
                    maxLines: 8,
                    minLines: 1,
                    decoration: BoxDecoration(
                        color: Colors.grey[140],
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),
                flex: 4),
            Expanded(child: Center(child: Text("Theme yes")), flex: 1)
          ],
        ));
  }
}

class FlyoutVerseButton extends StatefulWidget {
  @override
  _FlyoutVerseButtonState createState() => _FlyoutVerseButtonState();
}

class _FlyoutVerseButtonState extends State<FlyoutVerseButton> {
  final controller = FlyoutController();
  String selectedVerseType = "";

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  onChanged(bool newValue, String verseType) {
    print(newValue);
    print(verseType);
    if (newValue) {
      setState(() {
        this.selectedVerseType = verseType;
        controller.open = false;
      });
      rebuildAllChildren(context);
      print(selectedVerseType);
    } else {
      setState(() {
        this.selectedVerseType = "";
        controller.open = false;
      });
    }
  }

  int rebuildNumber = 0;

  @override
  Widget build(BuildContext context) {
    return Flyout(
        child: VerseButton(
            verseID: "V2",
            onPressed: () {
              controller.open = true;
            }),
        content: FlyoutContent(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              VerseTypeChooserRow(
                  "V",
                  "Verse",
                  (bool newValue, String verseType) =>
                      onChanged(newValue, verseType),
                  (selectedVerseType == "V")),
              VerseTypeChooserRow(
                  "P",
                  "Pre-Chorus",
                  (bool newValue, String verseType) =>
                      onChanged(newValue, verseType),
                  (selectedVerseType == "P")),
              VerseTypeChooserRow(
                  "C",
                  "Chorus",
                  (bool newValue, String verseType) =>
                      onChanged(newValue, verseType),
                  (selectedVerseType == "C")),
              VerseTypeChooserRow(
                  "B",
                  "Bridge",
                  (bool newValue, String verseType) =>
                      onChanged(newValue, verseType),
                  (selectedVerseType == "B")),
              VerseTypeChooserRow(
                  "T",
                  "Coda",
                  (bool newValue, String verseType) =>
                      onChanged(newValue, verseType),
                  (selectedVerseType == "T")),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 1.5),
                child: Row(
                  children: [
                    VerseButton(verseID: "+", onPressed: null),
                    Expanded(child: TextBox())
                  ],
                ),
              )
            ],
          ),
        ),
        contentWidth: 200,
        controller: controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class VerseTypeChooserRow extends StatelessWidget {
  final String verseType;
  final String description;
  final Function onChanged;
  final bool selected;

  VerseTypeChooserRow(
      this.verseType, this.description, this.onChanged, this.selected);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.5),
      child: Row(
        children: [
          VerseTypeSelectButton(verseType, onChanged, selected),
          Padding(padding: EdgeInsets.only(left: 5), child: Text(description))
        ],
      ),
    );
  }
}

class VerseTypeSelectButton extends StatelessWidget {
  final Function onChanged;
  final String verseType;
  final bool checked;

  VerseTypeSelectButton(this.verseType, this.onChanged, this.checked);

  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 40),
      child: ToggleButton(
        checked: checked,
        onChanged: (newValue) {
          onChanged(newValue, verseType);
          print(verseType);
        },
        child: Text(
          verseType,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        style: ToggleButtonThemeData(
          checkedButtonStyle: ButtonStyle(
              border: ButtonState.all(
                BorderSide(color: Colors.teal),
              ),
              backgroundColor: ButtonState.all(Colors.teal.withAlpha(120)),
              shape: ButtonState.all(StadiumBorder())),
          uncheckedButtonStyle: ButtonStyle(
            border: ButtonState.all(
              BorderSide(color: Colors.grey[120]),
            ),
            shape: ButtonState.all(StadiumBorder()),
          ),
        ),
      ),
    );
  }
}

class VerseButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String verseID;
  final bool checked;

  VerseButton(
      {required this.verseID, required this.onPressed, this.checked = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2),
      child: Button(
        child: Text(
          verseID,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        onPressed: onPressed,
        style: ButtonStyle(
            border: ButtonState.all(
              BorderSide(color: Colors.grey[120]),
            ),
            shape: ButtonState.all(StadiumBorder())),
      ),
    );
  }
}
