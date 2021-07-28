import 'package:flutter/material.dart';

ButtonStyle bntStyle(BuildContext context, Color color) {
  return ButtonStyle(
    backgroundColor: MaterialStateProperty.all(color),
    padding: MaterialStateProperty.all(
      EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
    ),
    textStyle: MaterialStateProperty.all(
      TextStyle(
        fontSize: 28.0,
      ),
    ),
  );
}

InputDecoration fieldBorder(hintText, ThemeData theme) {
  return InputDecoration(
    contentPadding: EdgeInsets.symmetric(
      vertical: 30.0,
      horizontal: 40.0,
    ),
    hintText: hintText,
    hintStyle: TextStyle(
      color: theme.accentColor,
      fontSize: 22.0,
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        width: 4,
        color: theme.primaryColor,
      ),
      borderRadius: BorderRadius.circular(4.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        width: 4,
        color: theme.primaryColor,
      ),
      borderRadius: BorderRadius.circular(4.0),
    ),
  );
}
