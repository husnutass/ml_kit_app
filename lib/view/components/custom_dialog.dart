import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: MediaQuery.of(context).size.height * .50,
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildSvgPicture(),
            SizedBox(height: 6),
            buildMessageText(context),
          ],
        ),
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
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.center,
    );
  }
}
