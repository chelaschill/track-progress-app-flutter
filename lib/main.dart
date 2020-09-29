import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:progreso_corporal_app/grafico.dart';
import 'package:progreso_corporal_app/historial.dart';

void main() => runApp(MazetaApp());

class MazetaApp extends StatefulWidget {
  @override
  _MazetaAppState createState() => _MazetaAppState();
}

class _MazetaAppState extends State<MazetaApp> {
  final _toGrasaFocusNode = FocusNode();
  final _toMusculoFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();
  var _validate = false;
  bool _save;
  DateTime currDate;
  File image;
  String peso;
  String grasa;
  String musculo;
  TextEditingController pcontroller = TextEditingController();
  TextEditingController gcontroller = TextEditingController();
  TextEditingController mcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    currDate = DateTime.now();
  }

  @override
  void dispose() {
    _toGrasaFocusNode.dispose();
    _toMusculoFocusNode.dispose();
    super.dispose();
  }

  void _pickDate(BuildContext context) async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(2020, 1), //DateTime(DateTime.now().year - 5),
      lastDate: DateTime.now(), //DateTime(DateTime.now().year + 5),
      initialDate: currDate,
    );

    if (date != null) {
      setState(() {
        currDate = date;
      });
    }
  }

  void _pickFromGallery() async {
    PickedFile pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    image = File(pickedFile.path);
    setState(() {});
  }

  void _takePicture() async {
    PickedFile pickedFile =
        await ImagePicker().getImage(source: ImageSource.camera);
    image = File(pickedFile.path);
    setState(() {});
  }

  createAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text("¿De dónde quieres obtener la imagen?"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text("Galería"),
                      onTap: () {
                        _pickFromGallery();
                        Navigator.of(context).pop();
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text("Cámara"),
                      onTap: () {
                        _takePicture();
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              ));
        });
  }

  void saveMetrics(BuildContext context) {
    Navigator.pushNamed(context, Historial.routeName).then(
      (_) {
        pcontroller.clear();
        gcontroller.clear();
        grasa = null;
        mcontroller.clear();
        musculo = null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: {
          Historial.routeName: (ctx) => Historial(
              save: _save,
              peso: peso,
              grasa: grasa,
              musculo: musculo,
              date: currDate,
              image: image),
        },
        home: Scaffold(
          appBar: AppBar(
            title: Text('Registra tu progreso'),
            backgroundColor: Colors.redAccent,
          ),
          body: Builder(builder: (context) {
            return ListView(
              children: [
                Column(
                  children: [
                    Container(
                      width: 300,
                      child: ListTile(
                        leading: Icon(Icons.calendar_today),
                        title: Text(
                          "${currDate.day}/${currDate.month}/${currDate.year}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.black45),
                        ),
                        trailing: Icon(Icons.keyboard_arrow_down),
                        onTap: () {
                          _pickDate(context);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(children: [
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          Container(
                            //height: 40,
                            width: 110,
                            child: TextField(
                              decoration: InputDecoration(
                                  errorText: pcontroller.text.isEmpty
                                      ? '*OBLIGATORIO'
                                      : null,
                                  border: OutlineInputBorder(),
                                  labelText: 'Peso'),
                              keyboardType: TextInputType.number,
                              controller: pcontroller,
                              onChanged: (value) {
                                peso = value;
                              },
                              textInputAction: TextInputAction.next,
                              onSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_toGrasaFocusNode);
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            //height: 40,
                            width: 110,
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: '%Grasa',
                              ),
                              keyboardType: TextInputType.number,
                              controller: gcontroller,
                              onChanged: (value) {
                                grasa = value;
                              },
                              textInputAction: TextInputAction.next,
                              focusNode: _toGrasaFocusNode,
                              onSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_toMusculoFocusNode);
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            //height: 40,
                            width: 110,
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: '%Músculo',
                              ),
                              keyboardType: TextInputType.number,
                              controller: mcontroller,
                              onChanged: (value) {
                                musculo = value;
                              },
                              textInputAction: TextInputAction.done,
                              focusNode: _toMusculoFocusNode,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: image == null
                            ? Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Container(
                                  decoration:
                                      BoxDecoration(border: Border.all()),
                                  height: 300,
                                  child: Center(
                                      child: IconButton(
                                          icon: Icon(Icons.camera_alt),
                                          onPressed: () {
                                            createAlertDialog(context);
                                          })),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: GestureDetector(
                                  child: Container(
                                    child: Image.file(
                                      image,
                                    ),
                                  ),
                                  onTap: () {
                                    createAlertDialog(context);
                                  },
                                  onDoubleTap: () {
                                    setState(() {
                                      image = null;
                                    });
                                  },
                                ),
                              ),
                      )
                    ]),
                    SizedBox(
                      width: 1,
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (image != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 135),
                        child: Text('Doble toque para borrar la imagen',
                            style: TextStyle(color: Colors.redAccent)),
                      ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 8, right: 8, top: 20),
                      child: Container(
                        height: 50,
                        child: RaisedButton(
                          elevation: 10,
                          onPressed: () {
                            setState(() {
                              pcontroller.text.isEmpty
                                  ? _validate = true
                                  : _validate = false;
                            });
                            if (!_validate) {
                              _save = true;
                              saveMetrics(context);
                            }
                          },
                          child: Text("Registrar"),
                          color: Colors.blueGrey,
                          textColor: Colors.white60,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                      child: Container(
                        height: 50,
                        child: RaisedButton(
                          child: Text("Ver Historial "),
                          elevation: 10,
                          color: Colors.redAccent,
                          textColor: Colors.white60,
                          onPressed: () {
                            _save = false;
                            Navigator.pushNamed(context, Historial.routeName);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        ));
  }
}
