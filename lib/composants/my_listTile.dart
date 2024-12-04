import 'package:flutter/material.dart';
import 'package:todo/composants/my_text.dart';

class MyListTile extends StatelessWidget {
  final IconData icons;
  final String texte;
  final Widget? trailing;
  final void Function()? onTap;

  const MyListTile({
    super.key,
    required this.icons,
    required this.texte,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icons),
      title: MyText(text: texte),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
