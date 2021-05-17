import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fluent_ui/fluent_ui.dart';

import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:lyric/data/data.dart';
import 'package:lyric/data/context.dart';

import 'pages/manage.dart';
import 'pages/songs.dart';
import 'pages/sets.dart';
import 'pages/present.dart';
import 'pages/settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'Lyric',
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      navigatorObservers: [ClearFocusOnPush()],
      initialRoute: '/',
      routes: {
        '/': (_) => MyHomePage(),
      },
      darkTheme:
          ThemeData(accentColor: Colors.teal, brightness: Brightness.dark),
    );
  }
}

class ClearFocusOnPush extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    final focus = FocusManager.instance.primaryFocus;
    focus?.unfocus();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool value = false;

  bool ready = false;

  int index = 0;

  @override
  void initState() {
    data.sync().then((value) => setState(() {
          ready = true;
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        !ready
            ? Center(
                child: ProgressRing(),
              )
            : NavigationView(
                useAcrylic: false,
                pane: NavigationPane(
                  selected: index,
                  onChanged: (i) => setState(() => index = i),
                  displayMode: PaneDisplayMode.auto,
                  header: Text('Lyric',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  items: [
                    PaneItem(
                      icon: Icon(FeatherIcons.folder),
                      title: 'Manage',
                    ),
                    PaneItem(
                      icon: Icon(FeatherIcons.music),
                      title: 'Songs',
                    ),
                    PaneItem(
                      icon: Icon(FeatherIcons.columns),
                      title: 'Sets',
                    ),
                    PaneItemSeparator(),
                    PaneItem(
                      icon: Icon(FeatherIcons.monitor),
                      title: 'Present',
                    )
                  ],
                  footerItems: [
                    PaneItem(
                      icon: Icon(FeatherIcons.settings),
                      title: 'Settings',
                    ),
                  ],
                  indicatorBuilder: ({
                    required BuildContext context,
                    int? index,
                    required List<Offset> Function() offsets,
                    required List<Size> Function() sizes,
                    required Axis axis,
                    required Widget child,
                  }) {
                    if (index == null) return child;
                    assert(debugCheckHasFluentTheme(context));
                    final theme = NavigationPaneThemeData.of(context);
                    return StickyNavigationIndicator(
                      index: index,
                      offsets: offsets,
                      sizes: sizes,
                      child: child,
                      color: theme.highlightColor,
                      curve: theme.animationCurve ?? Curves.linear,
                      axis: axis,
                    );
                  },
                ),
                content: NavigationBody(index: index, children: [
                  ManagePage(),
                  SongsPage(),
                  SetsPage(),
                  PresentPage(),
                  SettingsPage()
                ]),
              ),
        Container(
          child: Container(
            height: 40,
            child: Row(
              children: [
                Spacer(),
                Align(
                  child: WindowButtons(),
                  alignment: Alignment.topRight,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class WindowButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(
          colors: WindowButtonColors(
            iconNormal: Colors.white,
          ),
        ),
        MaximizeWindowButton(
          colors: WindowButtonColors(
            iconNormal: Colors.white,
          ),
        ),
        CloseWindowButton(
          colors: WindowButtonColors(
              iconNormal: Colors.white,
              mouseOver: Colors.red,
              mouseDown: Colors.red.withAlpha(100)),
        )
      ],
    );
  }
}
