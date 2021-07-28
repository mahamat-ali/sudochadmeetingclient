import 'package:flutter/material.dart';
import 'package:sudachad/theme/btn_styles.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton(
      {Key? key, this.callBack, this.context, this.label, this.color})
      : super(key: key);

  final context;
  final callBack;
  final label;
  final color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: callBack,
      child: Text(label),
      style: bntStyle(
        context,
        color,
      ),
    );
  }
}
