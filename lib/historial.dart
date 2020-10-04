import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:progreso_corporal_app/widgets/metrics.dart';
import 'package:progreso_corporal_app/database.dart';
import 'package:progreso_corporal_app/grafico.dart';
import 'package:progreso_corporal_app/registrar.dart';

class Historial extends StatefulWidget {
  @override
  _HistorialState createState() => _HistorialState();
}

List<Metrics> data = [];

class _HistorialState extends State<Historial> {
  HistorialDB _historialDB = HistorialDB();
  bool save = false;
  String grasa;
  String musculo;
  String peso;
  DateTime date;
  File image;

  @override
  void initState() {
    _historialDB.initializeDatabase();
    data = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: const Text('Historial'),
      actions: [
        IconButton(
          icon: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Registro(),
              ),
            ).then((_) {
              setState(() {});
            });
          },
        )
      ],
    );

    return Scaffold(
      appBar: appBar,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          data = [];
          _historialDB.selectAllQuotesGraph().then(
            (value) {
              for (int i = 0; i < value.length; i++) {
                data.add(value[i]);
              }
              if (data.length > 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Grafico(data),
                  ),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text(
                        "No hay suficientes datos para mostrar un gráfico",
                      ),
                      actions: [
                        FlatButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("OK"),
                        )
                      ],
                    );
                  },
                );
              }
            },
          );
        },
        child: Icon(
          Icons.insert_chart,
        ),
        backgroundColor: Colors.indigo,
      ),
      body: FutureBuilder(
        future: _historialDB.selectAllQuotes(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.orange),
              ),
            );
          } else if (snapshot.data.length == 0) {
            return Center(
              child: Text(
                'No hay datos',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            );
          } else {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data.length,
              itemBuilder: (ctx, index) {
                var item = snapshot.data[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      Dismissible(
                        key: ObjectKey(item),
                        onDismissed: (_) {
                          setState(() {
                            snapshot.data.removeAt(index);
                            _historialDB.delete(item);
                            //data.removeAt(index);
                            //save = false;
                          });
                        },
                        confirmDismiss: (DismissDirection direction) async {
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Confirmar"),
                                content: const Text(
                                    "¿Estás seguro de querer eliminar este registro?"),
                                actions: [
                                  FlatButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text("CANCELAR"),
                                  ),
                                  FlatButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text("ELIMINAR"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: AlignmentDirectional.centerEnd,
                          color: Colors.red,
                          child: Text(
                            'ELIMINAR',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  "${item.date.day}/${item.date.month}/${item.date.year}",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFDB556B),
                                      decoration: TextDecoration.underline),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width - 10,
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    ),
                                    title: Text(
                                      'Peso: ${(double.parse(item.peso)).toStringAsFixed(2)} kgs.',
                                      style: TextStyle(
                                        fontSize: 21,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        //color: Colors.green),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width - 10,
                                  child: ListTile(
                                    leading: item.grasa != null
                                        ? Icon(
                                            Icons.check,
                                            color: Colors.green,
                                          )
                                        : Icon(Icons.close, color: Colors.red),
                                    title: item.grasa != null
                                        ? Text(
                                            'Grasa: ${((double.parse(item.grasa) * 0.01 * (double.parse(item.peso)))).toStringAsFixed(2)} kgs.',
                                            style: TextStyle(
                                                fontSize: 21,
                                                //color: Colors.green,
                                                fontWeight: FontWeight.bold),
                                          )
                                        : Text(
                                            'Grasa: -',
                                            style: TextStyle(
                                                fontSize: 21,
                                                //color: Colors.red,
                                                fontWeight: FontWeight.bold),
                                          ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width - 10,
                                  child: ListTile(
                                    leading: item.musculo != null
                                        ? Icon(
                                            Icons.check,
                                            color: Colors.green,
                                          )
                                        : Icon(Icons.close, color: Colors.red),
                                    title: item.musculo != null
                                        ? Text(
                                            'Músculo: ${((double.parse(item.musculo) * 0.01 * (double.parse(item.peso)))).toStringAsFixed(2)} kgs.',
                                            style: TextStyle(
                                                fontSize: 21,
                                                fontWeight: FontWeight.bold),
                                          )
                                        : Text(
                                            'Músculo: -',
                                            style: TextStyle(
                                                fontSize: 21,
                                                //color: Colors.redAccent,
                                                fontWeight: FontWeight.bold),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      item.imageName == null
                          ? Expanded(
                              child: Center(
                                child: Container(
                                  child: Padding(
                                    padding: EdgeInsets.all(100),
                                    child: Image.network(
                                      "https://www.thegreenhome.com.mx/images/large/no_image.jpg",
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Expanded(
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: ListView(
                                  children: [
                                    Image.file(
                                      File(item.imageName),
                                      fit: BoxFit.fill,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
