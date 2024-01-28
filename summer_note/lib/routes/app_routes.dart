import 'package:flutter/material.dart';
import 'package:summer_note/models/summary_model.dart';
import 'package:summer_note/presentation/filechat/chat_page.dart';
import 'package:summer_note/presentation/fileuploadchat_screen/fileuploadchat_screen.dart';
import 'package:summer_note/presentation/intro_screen/intro_screen.dart';
import 'package:summer_note/presentation/welcome_screen/welcome_screen.dart';
import 'package:summer_note/presentation/homepage_screen/homepage_screen.dart';
import 'package:summer_note/presentation/history_screen/history_screen.dart';
import 'package:summer_note/presentation/settings_screen/settings_screen.dart';
import 'package:summer_note/presentation/doc_summarizer_screen/doc_summarizer_screen.dart';
import 'package:summer_note/presentation/pdfupload_screen/pdfupload_screen.dart';
import 'package:summer_note/presentation/docupload_screen/docupload_screen.dart';
import 'package:summer_note/presentation/text_summarizer_screen/text_summarizer_screen.dart';
import 'package:summer_note/presentation/link_summarizer_screen/link_summarizer_screen.dart';
import 'package:summer_note/presentation/textupload_screen/textupload_screen.dart';
import 'package:summer_note/presentation/linkupload_screen/linkupload_screen.dart';
import 'package:summer_note/presentation/app_navigation_screen/app_navigation_screen.dart';

class AppRoutes {
  static List<Summary> summaries = List.empty(growable: true);

  static const String introScreen = '/intro_screen';

  static const String welcomeScreen = '/welcome_screen';

  static const String homepageScreen = '/homepage_screen';

  static const String historyScreen = '/history_screen';

  static const String settingsScreen = '/settings_screen';

  static const String pdfSummarizerScreen = '/pdf_summarizer_screen';

  static const String docSummarizerScreen = '/doc_summarizer_screen';

  static const String pdfuploadScreen = '/pdfupload_screen';

  static const String docuploadScreen = '/docupload_screen';

  static const String textSummarizerScreen = '/text_summarizer_screen';

  static const String linkSummarizerScreen = '/link_summarizer_screen';

  static const String textuploadScreen = '/textupload_screen';

  static const String linkuploadScreen = '/linkupload_screen';

  static const String appNavigationScreen = '/app_navigation_screen';

  static const String chatPage = '/chat_page';

  static const String fileuploadchatScreen = '/fileuploadchat_screen';

  static Map<String, WidgetBuilder> routes = {
    introScreen: (context) => IntroScreen(),
    welcomeScreen: (context) => WelcomeScreen(),
    homepageScreen: (context) => HomepageScreen(summaries: summaries),
    historyScreen: (context) => HistoryScreen(),
    settingsScreen: (context) => SettingsScreen(),
    //pdfSummarizerScreen: (context) => PdfSummarizerScreen(),
    docSummarizerScreen: (context) => DocSummarizerScreen(),
    pdfuploadScreen: (context) => PdfuploadScreen(),
    docuploadScreen: (context) => DocuploadScreen(),
    //textSummarizerScreen: (context) => TextSummarizerScreen(),
    linkSummarizerScreen: (context) => LinkSummarizerScreen(),
    textuploadScreen: (context) => TextuploadScreen(),
    linkuploadScreen: (context) => LinkuploadScreen(),
    appNavigationScreen: (context) => AppNavigationScreen(),
    chatPage: (context) => ChatPage(),
    fileuploadchatScreen: (context) => FileuploadChatScreen(),
  };
}
