import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image_picker/image_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart' as http;
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

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
  List<String> mobilePhone = [];
  List<String> businessPhone = [];
  List<String> address = [];
  List<String> site = [];
  List<String> personName = [];

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null && s.length >= 10;
  }

  String getWebSite(String url) {
    RegExp regExp = new RegExp(
      r"[(http(s)?):\/\/(www\.)?a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)",
      caseSensitive: false,
      multiLine: false,
    );

    // print("hasMatch : " + regExp.hasMatch(url).toString());
    // print("stringMatch : " + regExp.stringMatch(url).toString());

    if (regExp.hasMatch(url)) {
      return regExp.stringMatch(url).toString();
    }
    return null;
  }

  String getPhoneNumber(String phone) {
    RegExp regExp = new RegExp(
      r"(([\+]90?)|([0]?))([ ]?)((\([0-9]{3}\))|([0-9]{3}))([ ]?)([0-9]{3})(\s*[\-]?)([0-9]{2})(\s*[\-]?)([0-9]{2})",
      caseSensitive: false,
      multiLine: false,
    );

    if (regExp.hasMatch(phone)) {
      return regExp.stringMatch(phone).toString();
    }
    return null;
  }

  /// returns whether the given phone number is mobile or business
  String checkPhoneNumberType(String phone) {
    if (phone[0] == "0") {
      if (phone[1] == "(") {
        if (phone[2] == "5") {
          return "mobile";
        } else {
          return "business";
        }
      } else {
        if (phone[1] == "5") {
          return "mobile";
        } else {
          return "business";
        }
      }
    } else if (phone[0] == "(") {
      if (phone[1] == "0") {
        if (phone[2] == "5") {
          return "mobile";
        } else {
          return "business";
        }
      } else if (phone[1] == "5") {
        return "mobile";
      } else {
        return "business";
      }
    } else if (phone[0] == "5") {
      return "mobile";
    } else {
      return "business";
    }
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      email = [];
      phone = [];
      mobilePhone = [];
      businessPhone = [];
      address = [];
      site = [];
      personName = [];
      _image = File(pickedFile.path);

      final FirebaseVisionImage visionImage =
          FirebaseVisionImage.fromFile(_image);
      final TextRecognizer textRecognizer =
          FirebaseVision.instance.textRecognizer();
      final VisionText visionText =
          await textRecognizer.processImage(visionImage);

      for (TextBlock block in visionText.blocks) {
        for (TextLine line in block.lines) {
          if (EmailValidator.validate(line.text)) {
            if (email != null) {
              setState(() {
                email.add(line.text);
              });
            }
          } else if (getPhoneNumber(line.text.replaceAll(' ', '')) != null) {
            var phoneNumber = getPhoneNumber(line.text.replaceAll(' ', ''));
            if (checkPhoneNumberType(phoneNumber) == "mobile")
              mobilePhone.add(phoneNumber);
            else if (checkPhoneNumberType(phoneNumber) == "business")
              businessPhone.add(phoneNumber);
            phone.add(phoneNumber);
          } else if (getWebSite(line.text) != null) {
            if (site != null) {
              setState(() {
                site.add(getWebSite(line.text));
              });
            }
          } else {
            if (address != null) {
              setState(() {
                address.add(line.text);
              });
            }
          }
        }
      }
      getName(visionText).then((value) => null);
      // addContact();
    } else {
      print('No image selected.');
    }
  }

  Future<http.Response> getName(VisionText visionText) async {
    var requestData = [];

    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        final String lineArea =
            (line.boundingBox.size.width * line.boundingBox.size.height)
                .toString();
        var ocrData = {
          "text": line.text ?? "",
          "boundingBoxArea": lineArea ?? "",
          "cornerPointsDx": line.cornerPoints[0]?.dx.toString() ?? "",
          "cornerPointsDy": line.cornerPoints[0]?.dy.toString() ?? "",
        };
        requestData.add(ocrData);
      }
    }

    final response = await http.post(
      Uri.http("iu-bitirme-app.herokuapp.com", "/api/findName"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestData),
    );

    if (response.statusCode == 200) {
      setState(() {
        personName.add(jsonDecode(response.body)['text']);
      });
    }
  }

  addContact() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted) {
      await Permission.contacts.request();
      PermissionStatus permission = await Permission.contacts.status;

      if (permission == PermissionStatus.granted) {
        if (await isAddedContact()) {
          print("added contact");
        }
      }
    } else {
      if (await isAddedContact()) {
        print("added contact");
      }
    }
  }

  List<Item> getItemFromList(
      {@required String label, @required List<String> list}) {
    List<Item> items = [];
    list.forEach((element) {
      items.add(Item(label: "mobile", value: element));
    });
    return items;
  }

  Future<bool> isAddedContact() async {
    try {
      print("adding contact...");
      Contact contact = Contact();
      contact.givenName = "name3";
      // contact.company = "company";
      if (phone.length > 0)
        contact.phones = getItemFromList(label: "mobile", list: phone);
      if (email.length > 0)
        contact.emails = getItemFromList(label: "email", list: email);
      print(contact.toMap());
      await ContactsService.addContact(contact);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
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
        createRow("Cep Telefonu", mobilePhone),
        SizedBox(
          height: 30,
        ),
        createRow("İş Telefonu", businessPhone),
        SizedBox(
          height: 30,
        ),
        createRow("Adres", address),
        SizedBox(
          height: 30,
        ),
        createRow("Site", site),
        SizedBox(
          height: 30,
        ),
        createRow("Kişi İsmi", personName),
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
