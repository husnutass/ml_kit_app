// import '../flutter_flow/flutter_flow_theme.dart';
// import '../flutter_flow/flutter_flow_widgets.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class HomePageWidget extends StatefulWidget {
//   HomePageWidget({Key key}) : super(key: key);

//   @override
//   _HomePageWidgetState createState() => _HomePageWidgetState();
// }

// class _HomePageWidgetState extends State<HomePageWidget> {
//   final scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: scaffoldKey,
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Column(
//           mainAxisSize: MainAxisSize.max,
//           children: [
//             Spacer(),
//             Padding(
//               padding: EdgeInsets.fromLTRB(0, 0, 0, 1),
//               child: Text(
//                 'Scan Business Cards From Camera or Select From Your Phone\'s Gallery and Add to Your Contacts.',
//                 textAlign: TextAlign.center,
//                 style: FlutterFlowTheme.bodyText1.override(
//                   fontFamily: 'Poppins',
//                   color: Color(0xFFDDDDDD),
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//             Spacer(),
//             FFButtonWidget(
//               onPressed: () {
//                 print('Button pressed ...');
//               },
//               text: 'Button',
//               options: FFButtonOptions(
//                 width: 300,
//                 height: 40,
//                 color: Color(0xFFFFE500),
//                 textStyle: FlutterFlowTheme.subtitle2.override(
//                   fontFamily: 'Poppins',
//                   color: Colors.black,
//                 ),
//                 borderSide: BorderSide(
//                   color: Colors.transparent,
//                   width: 1,
//                 ),
//                 borderRadius: 12,
//               ),
//             ),
//             FFButtonWidget(
//               onPressed: () {
//                 print('Button pressed ...');
//               },
//               text: 'Button',
//               options: FFButtonOptions(
//                 width: 300,
//                 height: 40,
//                 color: Colors.black,
//                 textStyle: FlutterFlowTheme.subtitle2.override(
//                   fontFamily: 'Poppins',
//                   color: Color(0xFFFFE500),
//                 ),
//                 borderSide: BorderSide(
//                   color: Color(0xFFFFE500),
//                   width: 1,
//                 ),
//                 borderRadius: 12,
//               ),
//             ),
//             Spacer()
//           ],
//         ),
//       ),
//     );
//   }
// }
