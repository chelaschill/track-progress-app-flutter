import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:progreso_corporal_app/historial.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MazetaApp());
}

class MazetaApp extends StatefulWidget {
  @override
  _MazetaAppState createState() => _MazetaAppState();
}

class _MazetaAppState extends State<MazetaApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "+ZTracker",
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.teal,
        ),
      ),
      home: Historial(),
    );
  }
}
