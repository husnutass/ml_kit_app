import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ml_kit_app/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final Future<FirebaseApp> _firebaseApp = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: FutureBuilder(
        future: _firebaseApp,
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: Text('ML'),
            ),
            body: appBody(snapshot),
          );
        },
      ),
    );
  }

  Widget appBody(snapshot) {
    if (snapshot.hasError) {
      print("Error ${snapshot.error.toString()}");
      return Center(
        child: Text("ERROR"),
      );
    } else if (snapshot.hasData) {
      return Home();
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
