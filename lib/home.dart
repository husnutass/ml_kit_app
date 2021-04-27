import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
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
          // print("line: " + line.toString());
          for (TextElement element in line.elements) {
            // Same getters as TextBlock
            // print("element: " + element.toString());
          }
        }
      }
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FloatingActionButton(
        onPressed: getImage,
        child: Icon(Icons.photo),
      ),
    );
  }
}
