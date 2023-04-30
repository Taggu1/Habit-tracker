import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:habbit_tracker/notifications.dart';
import 'package:habbit_tracker/providers/providers.dart';
import 'package:habbit_tracker/screens/home_screen.dart';
import 'package:habbit_tracker/widgets/app_snackbar.dart';

import '../constants.dart';
import './login_signup_screen.dart';

class AppSplashScreen extends ConsumerStatefulWidget {
  const AppSplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AppSplashScreenState();
}

class _AppSplashScreenState extends ConsumerState<AppSplashScreen> {
  var _loading = false;
  late String? uid;

  @override
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) {
        if (!isAllowed) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text("Allow notifications"),
              content: const Text("We would like to send you notifications"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Dont allow",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await AwesomeNotifications()
                        .requestPermissionToSendNotifications();
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Allow",
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            ),
          );
        }
      },
    );
  }

  @override
  void didChangeDependencies() async {
    if (_loading == false) {
      await ref.read(userProvider.notifier).getValidationData();
    }
    _loading = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    return EasySplashScreen(
      logo: Image.asset(
        "assets/icons/habitat.png",
        color: kWhiteColor,
      ),
      title: const Text(
        "Habito",
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: kWhiteColor),
      ),
      loaderColor: kWhiteColor,
      backgroundColor: kBlackColor,
      showLoader: true,
      loadingText: const Text(
        "Loading...",
        style: TextStyle(color: kWhiteColor),
      ),
      navigator: user.isLoged ? const HomeScreen() : const LoginSignupScreen(),
      durationInSeconds: 2,
    );
  }
}
