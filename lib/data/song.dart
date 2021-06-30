import 'dart:convert';
import 'dart:ui';

import 'package:xml/xml.dart';
import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:path/path.dart';

class Song {
  XmlDocument? xml;
  File fileEntity;
  String? title;
  List<Verse>? verses;
  List<VerseID>? presentationOrder;

  /// Default theme for slides (that slide themes can override)
  SongTheme? theme;

  /// True, if while reading the song, Lyric encountered data, which it doesn't (fully) support, and may be lost when saving the file.
  bool possibleDataLossOnSave;
  Song(
      {this.xml,
      required this.fileEntity,
      this.title,
      this.verses,
      this.presentationOrder = const [],
      this.theme,
      this.possibleDataLossOnSave = false});

  factory Song.fromFile(File file) {
    XmlDocument xml = XmlDocument.parse(file.readAsStringSync());
    bool possibleDataLossOnSave = false;

    //! BUILD PROTOVERSES
    List<ProtoVerse> protoVerses = [];
    List<ProtoVerse> looseProtoVerses = [];

    // Get and clean up lines
    List<String> lines = xml.firstElementChild!
        .getElement('lyrics')!
        .text
        .replaceAll("\r", "")
        .split("\n");
    lines.removeWhere((line) => ((line.length == 0) ||
        (RegExp(r"(---)|(--!)").hasMatch(line)) ||
        ({'.', ';'}.contains((line.length > 0) ? line[0] : ""))));

    // Go trough lines and add a Verse ID for each line with an ID
    int i = -1;
    for (String line in lines) {
      i++;
      // Anywhere in the line
      String? verseTag;
      if ((verseTag = RegExp(r"(\[.*\])").stringMatch(line)) != null) {
        verseTag = verseTag!.replaceAll(RegExp(r"[\[\]]"), "");
        if (verseTag == "") continue;

        // Get lines of this verse
        List<String> verseLines = [];
        for (String verseLine in lines.sublist(i + 1)) {
          if (RegExp(r"(\[.*\])").stringMatch(verseLine) != null) break;
          verseLines.add(verseLine.trim()); //Only add lyrics lines
        }

        //If there are lines that start with a number, mark for later processing
        if (verseLines.any((element) =>
            RegExp(r"[0-9]")
                .firstMatch(((element.length > 0) ? element[0] : "")) !=
            null)) {
          looseProtoVerses
              .add(ProtoVerse(VerseID.fromTag(verseTag), verseLines));
        } else {
          protoVerses.add(ProtoVerse(VerseID.fromTag(verseTag), verseLines));
        }
      }
    }

    // Go trough list of loose verseTypes and add add protoverses for numbered lines
    for (ProtoVerse looseVerse in looseProtoVerses) {
      for (String line in looseVerse.lines) {
        int number = int.parse(((looseVerse.verseID.number != null)
                ? looseVerse.verseID.number.toString()
                : "") +
            line[0]);
        if (!protoVerses.any((element) =>
            element.verseID.number == number &&
            element.verseID.type == looseVerse.verseID.type)) {
          protoVerses
              .add(ProtoVerse(VerseID(looseVerse.verseID.type, number), []));
        }

        protoVerses
            .firstWhere((element) =>
                element.verseID.number == number &&
                element.verseID.type == looseVerse.verseID.type)
            .lines
            .add(line);
        possibleDataLossOnSave = true;
      }
    }

    //! IMPORT VERSE BACKGROUNDS FROM OPENSONG FORMAT
    List<OpenSongBackground> openSongBackgrounds = [];
    XmlElement? styleElement = xml.firstElementChild!.getElement('style');
    if (styleElement != null) {
      openSongBackgrounds.add(
        OpenSongBackground(
          verseID: null,
          properties: BackgroundProperties(
            color: Color(
              int.parse(styleElement
                  .getElement('background')!
                  .getAttribute('color')!
                  .replaceAll("#", "")),
            ),
            fit: BackgroundFit.zoom,
            image: Image.memory(
              base64Decode(styleElement.getElement('background')!.text),
            ),
          ),
        ),
      );
    }
    XmlElement? backgroundsElement =
        xml.firstElementChild!.getElement('backgrounds');
    if (backgroundsElement != null) {
      for (XmlElement element
          in backgroundsElement.children.whereType<XmlElement>()) {
        openSongBackgrounds.add(OpenSongBackground(
            properties: BackgroundProperties(
                fit: BackgroundFit.fit,
                image: Image.memory(base64Decode(element.text))),
            verseID: VerseID.fromTag(element.getAttribute('verse')!)));
      }
    }

    //! LOAD LYRIC SLIDE THEMES
    //TODO

    //! BUILD VERSES
    List<Verse> verses = [];
    for (ProtoVerse protoVerse in protoVerses) {
      List<Slide> thisSlides = [];
      String thisVerseLyrics = protoVerse.lines.join("\n");
      List<String> thisVerseSlidesLyrics = thisVerseLyrics.split(' ||');
      BackgroundProperties? migratedOpenSongBackgroundProperties;
      if (openSongBackgrounds.length > 0) {
        migratedOpenSongBackgroundProperties = openSongBackgrounds
            .firstWhere((element) => element.verseID == protoVerse.verseID)
            .properties;
      }
      for (String slideLyrics in thisVerseSlidesLyrics) {
        thisSlides.add(Slide(
            body: slideLyrics,
            theme: (migratedOpenSongBackgroundProperties != null)
                ? SongTheme(
                    backgroundProperties: migratedOpenSongBackgroundProperties)
                : null));
      }
      verses.add(Verse(protoVerse.verseID, thisSlides));
    }

    List<VerseID> presentationOrder = [];
    for (String verseTag
        in xml.firstElementChild!.getElement('presentation')!.text.split(" ")) {
      presentationOrder.add(VerseID.fromTag(verseTag));
    }

    return Song(
        xml: xml,
        fileEntity: file,
        title: xml.firstElementChild!
            .getElement('title')!
            .text, //TODO error handling
        verses: verses,
        presentationOrder: presentationOrder,
        possibleDataLossOnSave: false //TODO detect chords, etc
        );
  }
}

class OpenSongBackground {
  BackgroundProperties properties;

  /// Null means background for the whole song
  VerseID? verseID;
  OpenSongBackground({required this.verseID, required this.properties});
}

class ProtoVerse {
  List<String> lines;
  VerseID verseID;

  ProtoVerse(this.verseID, this.lines);
}

class Verse {
  VerseID verseID;
  List<Slide> slides;
  Verse(this.verseID, this.slides);
}

class Slide {
  SongTheme? theme;
  String body;
  String title;
  String subtitle;
  Slide({this.theme, this.body = "", this.title = "", this.subtitle = ""});
}

class SongTheme {
  //! Values that are null, will be replaced by app default settings.
  String name;
  BackgroundProperties? backgroundProperties;
  TextStyle? bodyTheme;
  TextStyle? titleTheme;
  TextStyle? subtitleTheme;
  SongTheme(
      {this.name = "",
      this.backgroundProperties,
      this.bodyTheme,
      this.titleTheme,
      this.subtitleTheme});
}

enum BackgroundFit { fit, stretch, zoom }

class BackgroundProperties {
  BackgroundFit fit;
  Color color;
  Image? image;
  BackgroundProperties(
      {this.fit = BackgroundFit.zoom, this.color = Colors.black, this.image});
}

class TextProperties {
  TextStyle? style;
  EdgeInsets? padding;
  bool enabled;
  TextProperties({this.style, this.padding, this.enabled = true});
}

class VerseID {
  String type;
  int? number;
  String verseTag() => type + (number ?? 1).toString();

  factory VerseID.fromTag(String verseTag) {
    String verseType = verseTag.replaceAll(RegExp(r"[0-9]"), "");
    // If no verse number is present, default to 1.
    int? verseNumber = int.tryParse(verseTag.replaceAll(RegExp(r"[^0-9]"), ""));
    return VerseID(verseType, verseNumber);
  }

  VerseID(this.type, this.number);

  int get hashCode => hashValues(type, number);
  bool operator ==(other) =>
      other is VerseID && (number == other.number && type == other.type);
}
/*
List<Verse> getVerses(String rawLyrics) {
  /*
  ! Separate slides at ||
  ! Add line breaks in place of |
  ! Remove lines starting with .
  ! Parse [V1] and [V]...
  ! Remove multilang
  ! Remove printing symbols
  */
  List<Verse> verses = [];

  List<String> lines = rawLyrics.split(RegExp(r"[\r\n]"));
  lines.removeWhere((element) => element.trim().length == 0);

  List<String> removeLinesStartingWith = ['.', '---']; //TODO add all
  lines.removeWhere((element) => removeLinesStartingWith.contains(element[0]));
  //lines.removeWhere((element) => element.codeUnitAt(0) > 12);

  String verseType = "";
  int verseNumber = 0;
  List<Slide>? thisVerseSlides;
  List<String>? thisSlideLines;
  SongTheme? thisSlideTheme;

  int i = 0;
  for (String line in lines) {
    if (RegExp(r"(?=(\[.*\]))").allMatches(line).length > 0) {
      //! Go trough each line with a verse ID
      if (thisVerseSlides != null) {
        //! Save previous verse
        verses.add(Verse(verseType, verseNumber, thisVerseSlides));
      }

      thisVerseSlides = [];

      //! Get ID of new verse

      line = line.replaceAll(RegExp(r"[\[\]]"), "");
      verseType = line.replaceAll(RegExp(r"[0-9]"), "");

      try {
        verseNumber = int.parse(line.replaceAll(RegExp(r"[a-zA-Z]"), ""));
      } catch (e) {
        print(
            "ERROR (song.dart) - Couldn't parse verse ID number as integer! Contains non-ascii letters?\n" +
                e.toString());
        verseNumber = 1;
      }

      if (!verses.any((element) =>
          element.verseID() == (verseType + verseNumber.toString()))) {}
    } else if (line.contains(" ||")) {
      if (thisSlideLines != null) {
        (thisVerseSlides ??= []).add(Slide(
            //If null, init list as well
            theme: thisSlideTheme,
            body: thisSlideLines.reduce((value, element) =>
                value + "\n" + element))); //TODO title and subtitle
      }
    } else if (line[0] == ';') {
      thisSlideTheme =
          SongTheme(name: line.substring(1)); //TODO needs resolving from xml
    } else {
      thisSlideLines ??= []; //If null, init

      thisSlideLines.add(line.trim());
    }
    i++;
  }

  return verses;
}
*/