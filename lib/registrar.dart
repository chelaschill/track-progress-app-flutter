import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:intl/intl.dart' as intl;

import 'package:progreso_corporal_app/widgets/metrics.dart';
import 'package:progreso_corporal_app/database.dart';

class Registro extends StatefulWidget {
  static const routeName = 'registro-screen';

  @override
  _RegistroState createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  HistorialDB _historialDB = HistorialDB();
  final _form = GlobalKey<FormState>();
  final _toGrasaFocusNode = FocusNode();
  final _toMusculoFocusNode = FocusNode();

  DateTime currDate;
  File image;
  String peso;
  String grasa;
  String musculo;
  int reemplazar;
  Function onSelectImage;
  TextEditingController pcontroller = TextEditingController();
  TextEditingController gcontroller = TextEditingController();
  TextEditingController mcontroller = TextEditingController();

  @override
  void initState() {
    currDate = DateTime.now();
    super.initState();
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

  Future _pickFromGallery() async {
    PickedFile imageFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      image = File(imageFile.path);
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await image.copy('${appDir.path}/$fileName');
    image = savedImage;
  }

  Future _takePicture() async {
    PickedFile imageFile =
        await ImagePicker().getImage(source: ImageSource.camera);
    setState(() {
      image = File(imageFile.path);
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await image.copy('${appDir.path}/$fileName');
    image = savedImage;
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

  void saveMetrics(BuildContext ctx) {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    final dateParseada = intl.DateFormat('dd/MM/yyyy');
    final total = dateParseada.format(currDate);

    if (double.tryParse(grasa.toString()) != null &&
        double.tryParse(musculo.toString()) != null) {

      var metrics = image == null
          ? Metrics(
              peso: peso,
              grasa: grasa,
              musculo: musculo,
              date: currDate,
              dateString: total,
            )
          : Metrics(
              peso: peso,
              grasa: grasa,
              musculo: musculo,
              date: currDate,
              imageName: image.path,
              dateString: total,
            );
      _historialDB.insertOrUpdate(metrics).then((value) {
        Navigator.of(context).pop();
      });
    } else if (double.tryParse(grasa.toString()) == null &&
        double.tryParse(musculo.toString()) != null) {
      var metrics = image == null
          ? Metrics(
              peso: peso,
              grasa: null,
              musculo: musculo,
              date: currDate,
              dateString: total)
          : Metrics(
              peso: peso,
              grasa: null,
              musculo: musculo,
              date: currDate,
              imageName: image.path,
              dateString: total);
      _historialDB.insertOrUpdate(metrics).then((value) {
        Navigator.of(context).pop();
      });
    } else if (double.tryParse(grasa.toString()) != null &&
        double.tryParse(musculo.toString()) == null) {
      var metrics = image == null
          ? Metrics(
              peso: peso,
              grasa: grasa,
              musculo: null,
              date: currDate,
              dateString: total)
          : Metrics(
              peso: peso,
              grasa: grasa,
              musculo: null,
              date: currDate,
              imageName: image.path,
              dateString: total);
      _historialDB.insertOrUpdate(metrics).then((value) {
        Navigator.of(context).pop();
      });
    } else if (double.tryParse(grasa.toString()) == null &&
        double.tryParse(musculo.toString()) == null) {
      var metrics = image == null
          ? Metrics(
              peso: peso,
              grasa: null,
              musculo: null,
              date: currDate,
              dateString: total)
          : Metrics(
              peso: peso,
              grasa: null,
              musculo: null,
              date: currDate,
              imageName: image.path,
              dateString: total);
      _historialDB.insertOrUpdate(metrics).then((value) {
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var _blankFocusNode = FocusNode();
    final appBar = AppBar(
      title: const Text(
        'Registra tu progreso',
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: (){
        FocusScope.of(context).requestFocus(_blankFocusNode);
      },
      child: Scaffold(
        appBar: appBar,
        body: Builder(builder: (context) {
          return ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Colors.red,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              "${currDate.day}/${currDate.month}/${currDate.year}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: Colors.black),
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      onTap: () {
                        _pickDate(context);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: _form,
                    child: Row(children: [
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          Container(
                            //height: 40,
                            width: 110,
                            child: TextFormField(
                              decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.black, width: 0.8)),
                                  border: OutlineInputBorder(),
                                  labelText: 'Peso'),
                              keyboardType: TextInputType.numberWithOptions(decimal: true,),
                              controller: pcontroller,
                              onChanged: (value) {
                                peso = value;
                              },
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_toGrasaFocusNode);
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Obligatorio';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Valor inválido';
                                }
                                if (double.parse(value) <= 0) {
                                  return 'Valor inválido.';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            //height: 40,
                            width: 110,
                            child: TextFormField(
                              decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 0.8)),
                                border: OutlineInputBorder(),
                                labelText: '%Grasa',
                              ),
                              keyboardType: TextInputType.numberWithOptions(decimal: true,),
                              controller: gcontroller,
                              onChanged: (value) {
                                grasa = value;
                              },
                              textInputAction: TextInputAction.next,
                              focusNode: _toGrasaFocusNode,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_toMusculoFocusNode);
                              },
                              validator: (value) {
                                if (value.isNotEmpty) {
                                  if (double.tryParse(value) == null ||
                                      double.tryParse(value) <= 0) {
                                    return 'Valor inválido';
                                  }
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            //height: 40,
                            width: 110,
                            child: TextFormField(
                              decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 0.8)),
                                border: OutlineInputBorder(),
                                labelText: '%Músculo',
                              ),
                              keyboardType: TextInputType.numberWithOptions(decimal: true,),
                              controller: mcontroller,
                              onChanged: (value) {
                                musculo = value;
                              },
                              textInputAction: TextInputAction.done,
                              focusNode: _toMusculoFocusNode,
                              validator: (value) {
                                if (value.isNotEmpty) {
                                  if (double.tryParse(value) == null ||
                                      double.tryParse(value) <= 0) {
                                    return 'Valor inválido';
                                  }
                                }
                                return null;
                              },
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
                                  decoration: BoxDecoration(border: Border.all()),
                                  height:
                                      MediaQuery.of(context).size.height * 0.6,
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
                      ),
                    ]),
                  ),
                  SizedBox(
                    width: 1,
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (image != null)
                    Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Text(
                            'Doble toque para borrar la imagen',
                            style:
                                TextStyle(color: Colors.redAccent, fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 20),
                    child: Container(
                      height: 50,
                      child: RaisedButton(
                        elevation: 10,
                        onPressed: () {
                          saveMetrics(context);
                          },
                        child: Text(
                          "Registrar",
                          style: TextStyle(fontSize: 20),
                        ),
                        color: Colors.teal,
                        textColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}
