import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants.dart';
import '../../screens/home_screen.dart';

class LoginAndSignUpButton extends StatelessWidget {
  final WidgetRef ref;
  final bool isLogin;
  final Function signUpAndLogin;
  const LoginAndSignUpButton(
      {Key? key,
      required this.ref,
      required this.isLogin,
      required this.signUpAndLogin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          signUpAndLogin(ref);
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.purple,
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kDefultBorderRadius),
          ),
        ),
        child: Text(isLogin ? "Login" : "SignUp"),
      ),
    );
  }
}
