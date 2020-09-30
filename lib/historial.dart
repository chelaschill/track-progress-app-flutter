import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:progreso_corporal_app/grafico.dart';
import 'package:progreso_corporal_app/widgets/metrics.dart';
import 'package:progreso_corporal_app/registrar.dart';

class Historial extends StatefulWidget {
  /*final bool save;
  final String grasa;
  final String musculo;
  final String peso;
  final DateTime date;
  final File image;

  Historial(
      {this.save, this.peso, this.grasa, this.musculo, this.date, this.image});*/

  @override
  _HistorialState createState() => _HistorialState();
}

List<Metrics> data = [];

class _HistorialState extends State<Historial> {
  bool save = false;
  String grasa;
  String musculo;
  String peso;
  DateTime date;
  File image;
  bool dismissed = false;
  bool repetido = false;

  void add() {
    bool repetido = false;
    if (data.isEmpty) {
      data.add(
        Metrics(
            peso: peso,
            grasa: grasa,
            musculo: musculo,
            date: date,
            image: image),
      );
    } else {
      for (int i = 0; i < data.length; i++) {
        if (date == data[i].date) {
          repetido = true;
        }
      }
      if (!repetido) {
        data.add(
          Metrics(
              peso: peso,
              grasa: grasa,
              musculo: musculo,
              date: date,
              image: image),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final appBar = AppBar(
      title: Text('Historial'),
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
                )).then((argumentos) {
              save = argumentos[5];
              grasa = argumentos[1];
              musculo = argumentos[2];
              peso = argumentos[0];
              date = argumentos[3];
              image = argumentos[4];
              setState(() {});
            });
          },
        )
      ],
    );

    if (save && !dismissed) {
      add();
      data.sort((a, b) => a.date.compareTo(b.date));
    }
    dismissed = false;

    return Scaffold(
      appBar: appBar,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (data.length != 0) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Grafico(data),
                ));
          } else {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text(
                      "No hay datos pra mostrar un gráfico",
                    ),
                    actions: [
                      FlatButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("OK"),
                      )
                    ],
                  );
                });
          }
        },
        child: Icon(
          Icons.insert_chart,
        ),
        backgroundColor: Colors.indigo,
      ),
      body: data.length == 0
          ? Center(
              child: Text(
                'NO HAY DATOS',
                style: TextStyle(fontSize: 30),
              ),
            )
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: data.length,
              itemBuilder: (ctx, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  child: Column(
                    children: [
                      Dismissible(
                        key: ObjectKey(data[index]),
                        onDismissed: (_) {
                          setState(() {
                            data.removeAt(index);
                            dismissed = true;
                          });
                        },
                        confirmDismiss: (DismissDirection direction) async {
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Confirmar"),
                                content: const Text(
                                    "Estás seguro de querer eliminar este registro?"),
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
                                  "${data[index].date.day}/${data[index].date.month}/${data[index].date.year}",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFDB556B),
                                      decoration: TextDecoration.underline),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    ),
                                    title: Text(
                                      'Peso: ${double.parse(data[index].peso).toStringAsFixed(2)} kgs.',
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
                                  width: MediaQuery.of(context).size.width,
                                  child: ListTile(
                                    leading: data[index].grasa != null
                                        ? Icon(
                                            Icons.check,
                                            color: Colors.green,
                                          )
                                        : Icon(Icons.close, color: Colors.red),
                                    title: data[index].grasa != null
                                        ? Text(
                                            'Grasa: ${((double.parse(data[index].grasa) * 0.01 * (double.parse(data[index].peso)))).toStringAsFixed(2)} kgs.',
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
                                  width: MediaQuery.of(context).size.width,
                                  child: ListTile(
                                    leading: data[index].musculo != null
                                        ? Icon(
                                            Icons.check,
                                            color: Colors.green,
                                          )
                                        : Icon(Icons.close, color: Colors.red),
                                    title: data[index].musculo != null
                                        ? Text(
                                            'Músculo: ${((double.parse(data[index].musculo) * 0.01 * (double.parse(data[index].peso)))).toStringAsFixed(2)} kgs.',
                                            style: TextStyle(
                                                fontSize: 21,
                                                //color: Colors.green,
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
                      data[index].image == null
                          ? Expanded(
                              child: Center(
                                child: Container(
                                  child: Padding(
                                      padding: EdgeInsets.all(100),
                                      child: Image.network(
                                        "https://www.thegreenhome.com.mx/images/large/no_image.jpg",
                                        fit: BoxFit.fill,
                                      )),
                                ),
                              ),
                            )
                          : Expanded(
                              child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: ListView(
                                    children: [
                                      Image.file(
                                        data[index].image,
                                        fit: BoxFit.fill,
                                      ),
                                    ],
                                  )),
                            ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
