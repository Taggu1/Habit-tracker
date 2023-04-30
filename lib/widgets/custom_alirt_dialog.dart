import 'package:dialogs/dialogs/choice_dialog.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    Key? key,
    required this.title,
    required this.onPressedFunc,
    required this.message,
  }) : super(key: key);
  final VoidCallback onPressedFunc;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return ChoiceDialog(
      title: title,
      titleColor: kWhiteColor,
      messageColor: kWhiteColor,
      dialogBackgroundColor: kSecondaryColor,
      buttonOkOnPressed: onPressedFunc,
      dialogRadius: 15,
    );
  }
}
