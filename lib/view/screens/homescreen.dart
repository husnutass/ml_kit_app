import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ml_kit_app/utils/functions.dart';
import 'package:ml_kit_app/view/components/filled_button.dart';
import 'package:ml_kit_app/view/components/transparent_button.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final double pageWidth = MediaQuery.of(context).size.width;
    final double pageHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: pageWidth * .05,
            vertical: pageHeight * .08,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildAppLogo(),
              SizedBox(height: 12),
              buildDescriptionText(),
              SizedBox(height: 12),
              buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Center buildAppLogo() {
    return Center(
      child: Column(
        children: [
          SvgPicture.asset('assets/icons/logo.svg'),
          SizedBox(height: 20),
          Text(
            "CardScanner",
            style: TextStyle(
                color: Color(0xFFFFE500),
                fontSize: 24.0,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  RichText buildDescriptionText() {
    const homeText_tr = const <TextSpan>[
      TextSpan(text: 'Kartvizitleri '),
      TextSpan(text: 'Kamera', style: TextStyle(fontWeight: FontWeight.bold)),
      TextSpan(text: 'dan Tarayın veya Telefonunuzun '),
      TextSpan(text: 'Galeri', style: TextStyle(fontWeight: FontWeight.bold)),
      TextSpan(text: 'sinden Seçin ve '),
      TextSpan(text: 'Rehber', style: TextStyle(fontWeight: FontWeight.bold)),
      TextSpan(text: 'inize Ekleyin.'),
    ];

    const homeText_en = const <TextSpan>[
      TextSpan(text: 'Scan Business Cards From '),
      TextSpan(text: 'Camera ', style: TextStyle(fontWeight: FontWeight.bold)),
      TextSpan(text: 'or Select From Your Phone\'s '),
      TextSpan(text: 'Gallery ', style: TextStyle(fontWeight: FontWeight.bold)),
      TextSpan(text: 'and Add to Your '),
      TextSpan(text: 'Contacts', style: TextStyle(fontWeight: FontWeight.bold)),
      TextSpan(text: '.'),
    ];

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          height: 1.3,
        ),
        children: homeText_tr,
      ),
    );
  }

  Column buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            text: "Kamera",
            func: () {
              getImage(ImageSource.camera, context);
            },
          ),
        ),
        SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: TransparentButton(
            text: "Galeri",
            func: () {
              getImage(ImageSource.gallery, context);
            },
          ),
        ),
      ],
    );
  }
}
