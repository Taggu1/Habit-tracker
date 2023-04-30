import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final SharedPreferences sp = await SharedPreferences.getInstance();
            sp.remove("email");
            sp.remove("token");
          },
          child: const Icon(
            Icons.abc,
          ),
        ),
      ),
    );
  }
}
