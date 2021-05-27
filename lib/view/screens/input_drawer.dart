import 'package:flutter/material.dart';
import 'package:ml_kit_app/utils/functions.dart';
import 'package:ml_kit_app/view/components/filled_button.dart';
import 'package:ml_kit_app/view/components/transparent_button.dart';
import 'package:ml_kit_app/utils/variables.dart';

class InputDrawer {
  BuildContext context;
  InputDrawer(this.context);

  TextEditingController nameController;
  TextEditingController emailController1;
  TextEditingController emailController2;
  TextEditingController phoneController1;
  TextEditingController phoneController2;
  TextEditingController phoneController3;

  openInputDrawer() {
    final double pageWidth = MediaQuery.of(context).size.width;
    final double pageHeight = MediaQuery.of(context).size.height;

    nameController = TextEditingController();
    emailController1 = TextEditingController();
    emailController2 = TextEditingController();
    phoneController1 = TextEditingController();
    phoneController2 = TextEditingController();
    phoneController3 = TextEditingController();

    if (personName.asMap().containsKey(0)) nameController.text = personName[0];
    if (phone.asMap().containsKey(0)) phoneController1.text = phone[0];
    if (phone.asMap().containsKey(1)) phoneController2.text = phone[1];
    if (phone.asMap().containsKey(2)) phoneController3.text = phone[2];
    if (email.asMap().containsKey(0)) emailController1.text = email[0];
    if (email.asMap().containsKey(1)) emailController2.text = email[1];

    addListenersToControllers();

    final inputData = [
      {
        "controller": nameController,
        "label": "İsim",
      },
      {
        "controller": phoneController1,
        "label": "Telefon",
      },
      {
        "controller": phoneController2,
        "label": "Telefon 2",
      },
      {
        "controller": phoneController3,
        "label": "Telefon 3",
      },
      {
        "controller": emailController1,
        "label": "Mail",
      },
      {
        "controller": emailController2,
        "label": "Mail 2",
      },
    ];

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            color: Color(0xff122519),
          ),
          height: MediaQuery.of(context).size.height * 0.62,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: pageWidth * .05,
              vertical: 10,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    "Kişi Bilgileri",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color(0xFFDDDDDD),
                      fontSize: 18,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: inputData.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          // height: 40,
                          margin: EdgeInsets.symmetric(vertical: 6.0),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: TextFormField(
                            style: TextStyle(
                              color: Color(0xFFDDDDDD),
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelStyle: TextStyle(
                                color: Color(0xFFFFE500),
                              ),
                              labelText: inputData[index]["label"],
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 20.0,
                              ),
                            ),
                            controller: inputData[index]["controller"],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                      text: "Rehbere Kaydet",
                      func: () {
                        addContact(context);
                      }),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: TransparentButton(
                      text: "Vazgeç",
                      func: () {
                        Navigator.pop(context);
                      }),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  void addListenersToControllers() {
    nameController.addListener(() {
      if (personName.length == 0) {
        personName.add(nameController.text);
      } else {
        personName[0] = nameController.text;
      }
    });

    phoneController1.addListener(() {
      if (phone.length == 0) {
        phone.add(phoneController1.text);
      } else {
        phone[0] = phoneController1.text;
      }
    });

    phoneController2.addListener(() {
      if (phone.length == 1) {
        phone.add(phoneController2.text);
      } else {
        phone[1] = phoneController2.text;
      }
    });

    phoneController3.addListener(() {
      if (phone.length == 2) {
        phone.add(phoneController3.text);
      } else {
        phone[2] = phoneController3.text;
      }
    });

    emailController1.addListener(() {
      if (email.length == 0) {
        email.add(emailController1.text);
      } else {
        email[0] = emailController1.text;
      }
    });

    emailController2.addListener(() {
      if (email.length == 1) {
        email.add(emailController2.text);
      } else {
        email[1] = emailController2.text;
      }
    });
  }
}
