import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:progreso_corporal_app/grafico.dart';

import 'package:progreso_corporal_app/historial.dart';
import 'package:progreso_corporal_app/registrar.dart';

void main() => runApp(MazetaApp());

class MazetaApp extends StatefulWidget {
  @override
  _MazetaAppState createState() => _MazetaAppState();
}

class _MazetaAppState extends State<MazetaApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
