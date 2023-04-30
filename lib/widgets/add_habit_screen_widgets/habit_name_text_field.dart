import 'package:flutter/material.dart';

import '../../constants.dart';

class HabitNameTextField extends StatefulWidget {
  final bool validate;
  final Function onChangedFunc;

  const HabitNameTextField({
    Key? key,
    required this.onChangedFunc,
    required this.validate,
  }) : super(key: key);

  @override
  State<HabitNameTextField> createState() => _HabitNameTextFieldState();
}

class _HabitNameTextFieldState extends State<HabitNameTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        errorText: widget.validate ? "Value Can't Be Empty" : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kDefultBorderRadius),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kDefultBorderRadius),
          borderSide: const BorderSide(color: kBlackColor),
        ),
        label: const Text(
          "Habit name",
          style: TextStyle(
            color: kBlackColor,
          ),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      onChanged: (value) => widget.onChangedFunc(value),
    );
  }
}
