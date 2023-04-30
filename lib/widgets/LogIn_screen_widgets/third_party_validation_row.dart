import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';

import '../../providers/providers.dart';
import '../../screens/home_screen.dart';
import '../../constants.dart';
import '../app_snackbar.dart';

class ThirdPartyValidationRow extends ConsumerWidget {
  const ThirdPartyValidationRow({Key? key}) : super(key: key);

  Widget customIconButton(
    Function onPressedFunc,
    IconData buttonIcon,
  ) {
    return IconButton(
      onPressed: () => onPressedFunc(),
      icon: Icon(
        buttonIcon,
        color: kWhiteColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Never trust facebook
        // customIconButton(() async {}, FontAwesome5.facebook),
        customIconButton(() async {
          try {
            await ref.read(userProvider.notifier).signInWithGoogle();
            Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
          } catch (e) {
            showAppDefultSnackbar(context, e.toString().split(":")[1]);
          }
        }, FontAwesome5.google),
      ],
    );
  }
}
