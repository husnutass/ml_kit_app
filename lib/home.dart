import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image_picker/image_picker.dart';
import 'package:email_validator/email_validator.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File _image;
  final picker = ImagePicker();
  List<String> email = [];
  List<String> phone = [];
  List<String> address = [];

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null && s.length >= 10;
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      email = [];
      phone = [];
      address = [];
      _image = File(pickedFile.path);
      final FirebaseVisionImage visionImage =
          FirebaseVisionImage.fromFile(_image);
      final TextRecognizer textRecognizer =
          FirebaseVision.instance.textRecognizer();
      final VisionText visionText =
          await textRecognizer.processImage(visionImage);

      print(visionText.text);

      for (TextBlock block in visionText.blocks) {
        final Rect boundingBox = block.boundingBox;
        print("boundingBox: " + boundingBox.toString());
        final List<Offset> cornerPoints = block.cornerPoints;
        print("cornerPoints: " + cornerPoints.toString());
        final String text = block.text;
        print("text: " + text);

        final List<RecognizedLanguage> languages = block.recognizedLanguages;
        // print("languages: " + languages.toString());

        for (TextLine line in block.lines) {
          // Same getters as TextBlock
          print("line: " + line.text);
          if (EmailValidator.validate(line.text)) {
            if (phone != null) {
              setState(() {
                email.add(line.text);
              });
            }
          } else if (isNumeric(line.text.replaceAll(' ', ''))) {
            if (phone != null) {
              setState(() {
                phone.add(line.text);
              });
            }
          } else {
            if (address != null) {
              setState(() {
                address.add(line.text);
              });
            }
          }
          for (TextElement element in line.elements) {
            // Same getters as TextBlock
            // print("element: " + element.toString());
          }
        }
      }

      print("email: " + email.toString());
      print("phone: " + phone.toString());
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      createRow("Email", email),
      SizedBox(
        height: 30,
      ),
      createRow("Telefon", phone),
      SizedBox(
        height: 30,
      ),
      createRow("Adres", address),
      SizedBox(
        height: 30,
      ),
      FloatingActionButton(
        onPressed: getImage,
        child: Icon(Icons.photo),
      ),
    ]);
  }

  Row createRow(String name, List<String> list) {
    if (list.length > 0) {
      return Row(
        children: [
          Text("$name: ", style: TextStyle(fontSize: 20)),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                return Text(list[index], style: TextStyle(fontSize: 20));
              },
            ),
          ),
        ],
      );
    }
    return Row(
      children: [
        Text(
          "$name boş",
          style: TextStyle(fontSize: 20),
        )
      ],
    );
  }
}
