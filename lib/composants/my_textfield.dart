import 'package:flutter/material.dart';

class MyTextfield extends StatefulWidget {
  final String message;
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final IconData? icon;

  const MyTextfield(
      {super.key,
      required this.message,
      this.hintText,
      this.labelText,
      this.controller, this.onChanged, this.icon});

  @override
  State<MyTextfield> createState() => _MyTextfieldState();
}

class _MyTextfieldState extends State<MyTextfield> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      child: TextFormField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: widget.hintText,
          labelText: widget.labelText,
          prefixIcon: Icon(widget.icon),
          labelStyle: TextStyle(color: Theme.of(context).colorScheme.tertiary),
          filled: true,
          fillColor: Theme.of(context).colorScheme.primary,
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.secondary),
            borderRadius: BorderRadius.circular(5.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.secondary),
            borderRadius: BorderRadius.circular(5.5),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return widget.message;
          }
          return null;
        },
      ),
    );
  }
}
