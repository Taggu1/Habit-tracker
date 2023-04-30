import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habbit_tracker/providers/providers.dart';
import 'package:habbit_tracker/screens/login_signup_screen.dart';
import 'package:habbit_tracker/widgets/home_screen/habits_list.dart';

import '../constants.dart';
import '../widgets/custom_alirt_dialog.dart';
import './add_habit_screen.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home-screen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlackColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kBlackColor,
        automaticallyImplyLeading: false,
        actions: const [
          LogOutButton(),
        ],
      ),
      body: const HabitsList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.of(context).pushNamed(AddHabitScreen.routeName);
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class LogOutButton extends ConsumerWidget {
  const LogOutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (ctx) => CustomAlertDialog(
                message: "",
                title: "Do you want to LogOut?",
                onPressedFunc: () {
                  ref.read(userProvider.notifier).logOut();
                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .pushReplacementNamed(LoginSignupScreen.routeName);
                }));
      },
      icon: const Icon(Icons.logout),
    );
  }
}
