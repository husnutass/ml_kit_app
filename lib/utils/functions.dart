import 'dart:convert';
import 'dart:io';

import 'package:contacts_service/contacts_service.dart';
import 'package:email_validator/email_validator.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ml_kit_app/utils/variables.dart';
import 'package:ml_kit_app/view/components/custom_dialog.dart';
import 'package:ml_kit_app/view/screens/input_drawer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

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
    contact.givenName = personName[0];
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

addContact(BuildContext context) async {
  PermissionStatus permission = await Permission.contacts.status;
  if (permission != PermissionStatus.granted) {
    print("get perm");
    await Permission.contacts.request();
    PermissionStatus permission = await Permission.contacts.status;

    if (permission == PermissionStatus.granted) {
      if (await isAddedContact()) {
        print("added contact");
        Navigator.pop(context);
        _showDialog(context);
      }
    }
  } else {
    if (await isAddedContact()) {
      print("added contact");
      Navigator.pop(context);
      _showDialog(context);
    }
  }
}

Future getImage(ImageSource imgSource, BuildContext context) async {
  File _image;
  final picker = ImagePicker();

  final pickedFile = await picker.getImage(source: imgSource);

  if (pickedFile != null) {
    email = [];
    phone = [];
    mobilePhone = [];
    businessPhone = [];
    address = [];
    site = [];
    personName = [];

    final inputImage = InputImage.fromFile(File(pickedFile.path));

    final textDetector = GoogleMlKit.vision.textDetector();
    final recognisedText = await textDetector.processImage(inputImage);

    // nl
    final languageIdentifier = GoogleMlKit.nlp.languageIdentifier();
    final String response =
        await languageIdentifier.identifyLanguage(recognisedText.text);
    final entityExtractor = GoogleMlKit.nlp.entityExtractor(response);
    // final entityModelManager = GoogleMlKit.nlp.entityModelManager();
    final List<EntityAnnotation> entities =
        await entityExtractor.extractEntities(recognisedText.text);

    print("lang: $response, ext: $entities");

    for (TextBlock block in recognisedText.textBlocks) {
      for (TextLine line in block.textLines) {
        if (EmailValidator.validate(line.lineText)) {
          if (email != null) {
            email.add(line.lineText);
          }
        } else if (getPhoneNumber(line.lineText.replaceAll(' ', '')) != null) {
          var phoneNumber = getPhoneNumber(line.lineText.replaceAll(' ', ''));
          if (checkPhoneNumberType(phoneNumber) == "mobile")
            mobilePhone.add(phoneNumber);
          else if (checkPhoneNumberType(phoneNumber) == "business")
            businessPhone.add(phoneNumber);
          phone.add(phoneNumber);
        } else if (getWebSite(line.lineText) != null) {
          if (site != null) {
            site.add(getWebSite(line.lineText));
          }
        } else {
          if (address != null) {
            address.add(line.lineText);
          }
        }
      }
    }
    getName(recognisedText)
        .then((value) => InputDrawer(context).openInputDrawer());
    // addContact();
  } else {
    print('No image selected.');
  }
}

Future<http.Response> getName(RecognisedText recognisedText) async {
  var requestData = [];

  for (TextBlock block in recognisedText.textBlocks) {
    for (TextLine line in block.textLines) {
      final String lineArea =
          (line.lineRect.size.width * line.lineRect.size.height).toString();
      var ocrData = {
        "text": line.lineText ?? "",
        "boundingBoxArea": lineArea ?? "",
        "cornerPointsDx": line.linePoints[0]?.dx.toString() ?? "",
        "cornerPointsDy": line.linePoints[0]?.dy.toString() ?? "",
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
    personName.add(jsonDecode(response.body)['text']);
  }
}

Future _showDialog(BuildContext context) async {
  var data = await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      Future.delayed(Duration(milliseconds: 2400), () {
        Navigator.of(context).pop();
      });
      return CustomDialog();
    },
  );
  return data;
}
