import 'package:flutter/material.dart';
import 'package:habbit_tracker/constants.dart';

import '../widgets/LogIn_screen_widgets/login_signup_content.dart';
import '../widgets/LogIn_screen_widgets/third_party_validation_row.dart';

class LoginSignupScreen extends StatefulWidget {
  static const routeName = '/login-signup-screen';
  const LoginSignupScreen({Key? key}) : super(key: key);

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  var _isLogin = true;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBlackColor,
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
          top: size.height * 0.1,
          left: size.width * 0.1,
          right: size.width * 0.1,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 60,
                  bottom: 50,
                ),
                child: Text(
                  _isLogin ? "Log in" : "Sign Up",
                  style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
              LoginSignUpForm(
                isLogin: _isLogin,
              ),
              if (_isLogin) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 40,
                  ),
                  child: Text(
                    "Or Login with",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ),
                const ThirdPartyValidationRow(),
              ],
              const SizedBox(
                height: 70,
              ),
              Column(
                children: [
                  Text(
                    !_isLogin ? "Or Login with" : "Or Sign Up with",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(
                        () {
                          _isLogin = !_isLogin;
                        },
                      );
                    },
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                    ),
                    child: Text(!_isLogin ? "Login" : "Sign Up"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
