import 'package:flutter/material.dart';

import '../constants.dart';

ScaffoldFeatureController showAppDefultSnackbar(
    BuildContext context, String messeage) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kDefultBorderRadius),
      ),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
      backgroundColor: kBlackColor,
      content: Text(
        messeage,
        textAlign: TextAlign.center,
      ),
    ),
  );
}
