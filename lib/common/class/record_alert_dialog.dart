import 'package:flutter/material.dart';

class RecordAlertDialog extends StatelessWidget {
  const RecordAlertDialog(
      {Key? key, required this.title, required this.content})
      : super(key: key);

  final Widget title;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: title,
        content: content,
      ),
    );
  }
}
