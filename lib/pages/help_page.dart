import 'package:flutter/material.dart';
import 'package:todo/composants/my_text.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const MyText(text: "Help"),
      ),
      body: const Center(
        child: MyText(text: "Help"),
      ),
    );
  }
}