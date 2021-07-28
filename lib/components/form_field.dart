import 'package:flutter/material.dart';
import 'package:sudachad/theme/btn_styles.dart';

class Field extends StatelessWidget {
  const Field({
    Key? key,
    this.callBack,
    this.errorMssg,
    this.label,
    this.theme,
  }) : super(key: key);

  final theme;
  final errorMssg;
  final callBack;
  final label;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: fieldBorder(label, theme),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return errorMssg;
        }
        return null;
      },
      onChanged: callBack,
    );
  }
}
