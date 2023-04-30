import 'package:flutter/material.dart';

import '../../constants.dart';

class ValidationCustomTextFormField extends StatelessWidget {
  final String textFeildLabel;
  final IconData textFieldIcon;
  final Function onSavedFunc;
  final Function validatorFunc;

  const ValidationCustomTextFormField({
    Key? key,
    required this.textFeildLabel,
    required this.textFieldIcon,
    required this.onSavedFunc,
    required this.validatorFunc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: kSecondaryColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kDefultBorderRadius),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kDefultBorderRadius),
          borderSide: const BorderSide(color: Colors.purple),
        ),
        prefixIcon: Icon(
          textFieldIcon,
          color: kWhiteColor,
        ),
        label: Text(
          textFeildLabel,
          style: const TextStyle(
            color: kWhiteColor,
          ),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        floatingLabelAlignment: FloatingLabelAlignment.start,
      ),
      onSaved: (value) {
        onSavedFunc(value);
      },
      validator: (value) {
        return validatorFunc(value);
      },
    );
  }
}
