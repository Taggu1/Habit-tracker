import 'package:dialogs/dialogs/message_dialog.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class CustomMessageDialog extends StatelessWidget {
  const CustomMessageDialog({
    Key? key,
    required this.message,
    required this.title,
  }) : super(key: key);

  final String message;
  final String title;
  @override
  Widget build(BuildContext context) {
    return MessageDialog(
      message: message,
      title: title,
      titleColor: Colors.white,
      dialogBackgroundColor: kBlackColor,
      messageColor: kWhiteColor,
    );
  }
}
