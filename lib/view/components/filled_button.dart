import 'package:flutter/material.dart';

class FilledButton extends StatelessWidget {
  const FilledButton({
    Key key,
    @required this.text,
    @required this.func,
  }) : super(key: key);

  final String text;
  final Function func;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: func,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 17, horizontal: 10),
        primary: Color(0xFFFFE500),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
