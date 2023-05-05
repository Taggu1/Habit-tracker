import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:habbit_tracker/constants.dart';
import 'package:habbit_tracker/screens/login_signup_screen.dart';
import 'package:habbit_tracker/widgets/app_snackbar.dart';

import 'firebase_options.dart';

import './screens/add_habit_screen.dart';
import './screens/home_screen.dart';
import './screens/splash_screen.dart';

void notificationInit() async {
  await AwesomeNotifications().initialize(
    'resource://drawable/res_custom_notification',
    [
      NotificationChannel(
        channelKey: "basic_channel",
        channelName: "Basic notifications",
        channelDescription: 'Notification channel for basic tests',
        importance: NotificationImportance.High,
        defaultColor: Colors.black,
      ),
      NotificationChannel(
        channelKey: "scheduled_channel",
        channelName: "Basic notifications",
        channelDescription: 'Notification channel for basic tests',
        importance: NotificationImportance.High,
        defaultColor: Colors.black,
      ),
    ],
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  notificationInit();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
      ),
      home: const AppSplashScreen(),
      routes: {
        HomeScreen.routeName: (ctx) => const HomeScreen(),
        AddHabitScreen.routeName: (ctx) => const AddHabitScreen(),
        LoginSignupScreen.routeName: (ctx) => const LoginSignupScreen(),
      },
    );
  }
}
