import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      //TODO: #14
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset("assets/animations/done.json", fit: BoxFit.fitWidth),
          SizedBox(height: 6),
          buildMessageText(context),
        ],
      ),
    );
  }

  Expanded buildSvgPicture() {
    return Expanded(
      child: Lottie.asset("assets/animations/done.json"),
    );
  }

  Text buildMessageText(BuildContext context) {
    return Text(
      "Kişi rehbere eklendi",
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      textAlign: TextAlign.center,
    );
  }
}
