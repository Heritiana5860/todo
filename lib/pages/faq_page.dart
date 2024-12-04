import 'package:flutter/material.dart';
import 'package:todo/composants/my_text.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const MyText(text: "F.A.Q"),
      ),
      body: const Center(
        child: MyText(text: "F.A.Q"),
      ),
    );
  }
}
