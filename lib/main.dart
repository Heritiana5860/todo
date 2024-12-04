import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:todo/pages/faq_page.dart';
import 'package:todo/pages/help_page.dart';
import 'package:todo/pages/home_page.dart';
import 'package:todo/theme/theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todo List',
        theme: Provider.of<ThemeProvider>(context).getThemeData,
        home: ShowCaseWidget(
          builder: (context) => const HomePage(),
        ),
        routes: {
          '/faq': (context) => const FaqPage(),
          '/help': (context) => const HelpPage(),
        });
  }
}
