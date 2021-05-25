import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ml_kit_app/view/screens/homescreen.dart';

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
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      theme: ThemeData(
        canvasColor: Colors.transparent,
      ),
      home: FutureBuilder(
        future: _firebaseApp,
        builder: (context, snapshot) {
          return HomeScreen();
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
      return HomeScreen();
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
