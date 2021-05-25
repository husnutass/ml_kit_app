import 'package:flutter/material.dart';

class TransparentButton extends StatelessWidget {
  const TransparentButton({
    Key key,
    @required this.text,
    @required this.func,
  }) : super(key: key);

  final String text;
  final Function func;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: func,
      child: Text(
        text,
        style: TextStyle(
          color: Color(0xFFFFE500),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 17, horizontal: 10),
        primary: Color(0xFFFFE500),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        side: BorderSide(
          color: Color(0xFFFFE500),
        ),
      ),
    );
  }
}
