import 'dart:ui' as ui;

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';

import 'package:provider/provider.dart';
import 'package:system_theme/system_theme.dart';

import 'pages/manage.dart';
import 'pages/songs.dart';
import 'pages/sets.dart';
import 'pages/present.dart';
import 'pages/settings.dart';

import 'utils/theme.dart';

late bool darkMode;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // The platforms the plugin support (01/04/2021 - DD/MM/YYYY):
  //   - Windows
  //   - Web
  //   - Android
  if (defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.android ||
      kIsWeb) {
    darkMode = await SystemTheme.darkMode;
    await SystemTheme.accentInstance.load();
  } else {
    darkMode = true;
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppTheme(),
      builder: (context, _) {
        final appTheme = context.watch<AppTheme>();
        return FluentApp(
          title: 'Lyric',
          themeMode: appTheme.mode,
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            '/': (_) => MyHomePage(),
          },
          style: Style(
            accentColor: SystemTheme.accentInstance.accent,
            brightness: appTheme.mode == ThemeMode.system
                ? darkMode
                    ? Brightness.dark
                    : Brightness.light
                : null,
          ),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool value = false;

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      left: NavigationPanel(
        menu: NavigationPanelMenuItem(
          icon: Icon(Icons.menu),
          label: Text('Lyric'),
        ),
        currentIndex: index,
        items: [
          NavigationPanelItem(
            icon: Icon(Icons.pan_tool_rounded),
            label: Text('Manage'),
            onTapped: () => setState(() => index = 0),
          ),
          NavigationPanelItem(
            icon: Icon(Icons.music_note_rounded),
            label: Text('Songs'),
            onTapped: () => setState(() => index = 1),
          ),
          NavigationPanelItem(
            icon: Icon(Icons.list),
            label: Text('Sets'),
            onTapped: () => setState(() => index = 2),
          ),
          NavigationPanelTileSeparator(),
          NavigationPanelItem(
              icon: Icon(Icons.personal_video_rounded),
              label: Text('Present'),
              onTapped: () => setState(() => index = 3)),
        ],
        bottom: NavigationPanelItem(
          // selected: index == 3,
          icon: Icon(Icons.settings),
          label: Text('Settings'),
          onTapped: () => setState(() => index = 4),
        ),
      ),
      body: NavigationPanelBody(index: index, children: [
        ManagePage(),
        SongsPage(),
        SetsPage(),
        PresentPage(),
        SettingsPage()
      ]),
    );
  }
}
