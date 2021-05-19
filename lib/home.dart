import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image_picker/image_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart' as http;

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
  List<String> site = [];

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null && s.length >= 10;
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      email = [];
      phone = [];
      address = [];
      site = [];
      _image = File(pickedFile.path);
      final FirebaseVisionImage visionImage =
          FirebaseVisionImage.fromFile(_image);
      final TextRecognizer textRecognizer =
          FirebaseVision.instance.textRecognizer();
      final VisionText visionText =
          await textRecognizer.processImage(visionImage);

      print(visionText.text);

      var requestData = [];

      for (TextBlock block in visionText.blocks) {
        final Rect boundingBox = block.boundingBox;
        final String area =
            (boundingBox.size.width * boundingBox.size.height).toString();
        print("boundingBoxArea: " + area);
        final List<Offset> cornerPoints = block.cornerPoints;
        print("cornerPoints: " + cornerPoints.toString());
        final String text = block.text;
        print("text: " + text);

        var ocrData = {
          "text": text ?? "",
          "boundingBoxArea": area ?? "",
          "cornerPointsDx": cornerPoints[0].dx.toString() ?? "",
          "cornerPointsDy": cornerPoints[0].dy.toString() ?? "",
        };

        requestData.add(ocrData);
        final List<RecognizedLanguage> languages = block.recognizedLanguages;
        // print("languages: " + languages.toString());
        /*

        for (TextLine line in block.lines) {
          // Same getters as TextBlock
          print("line: " + line.text);
          if (EmailValidator.validate(line.text)) {
            if (phone != null) {
              setState(() {
                email.add(line.text);
              });
            }
          } else if (isNumeric(line.text.replaceAll(
              // RegExp(r"\b(\w*tel\w*)|(\w*gsm\w*)\b|(\s)", caseSensitive: false),
              ' ',
              ''))) {
            if (phone != null) {
              setState(() {
                phone.add(line.text);
              });
            }
          } else if (line.text.contains("www")) {
            if (site != null) {
              setState(() {
                site.add(line.text);
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
        */
      }
      writeToCsv(requestData);
    } else {
      print('No image selected.');
    }
  }

  Future<http.Response> writeToCsv(List data) {
    return http.post(
      Uri.http("192.168.1.36:4444", "/api/dataset"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(children: [
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
        createRow("Site", site),
        Spacer(),
        FloatingActionButton(
          onPressed: getImage,
          child: Icon(Icons.photo),
        ),
      ]),
    );
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