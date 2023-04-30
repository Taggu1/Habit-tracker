import 'package:flutter/material.dart';

class ForgotPasswordbutton extends StatelessWidget {
  const ForgotPasswordbutton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        primary: Colors.grey,
      ),
      child: const Text("Forgot password?"),
    );
  }
}
