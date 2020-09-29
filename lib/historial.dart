import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:progreso_corporal_app/grafico.dart';
import 'package:progreso_corporal_app/widgets/metrics.dart';

class Historial extends StatefulWidget {
  static const routeName = 'stats-screen';

  final bool save;
  final String grasa;
  final String musculo;
  final String peso;
  final DateTime date;
  final File image;

  Historial(
      {this.save, this.peso, this.grasa, this.musculo, this.date, this.image});

  @override
  _HistorialState createState() => _HistorialState();
}

List<Metrics> data = [];

class _HistorialState extends State<Historial> {
  bool dismissed = false;

  void add() {
    bool repetido = false;
    if (data.isEmpty) {
      data.add(
        Metrics(
            peso: widget.peso,
            grasa: widget.grasa,
            musculo: widget.musculo,
            date: widget.date,
            image: widget.image),
      );
    } else {
      for (int i = 0; i < data.length; i++) {
        if (widget.date == data[i].date) {
          repetido = true;
        }
      }
      if (!repetido) {
        data.add(
          Metrics(
              peso: widget.peso,
              grasa: widget.grasa,
              musculo: widget.musculo,
              date: widget.date,
              image: widget.image),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final appBar = AppBar(
      title: Text('Tu progreso'),
    );

    if (widget.save && !dismissed) {
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
                    title: Text(
                      "NO HAY DATOS PARA MOSTRAR UN GRÁFICO",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    content: GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 120),
                        child: Text(
                          'OK',
                          style: TextStyle(fontSize: 20, color: Colors.blue),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  );
                });
          }
        },
        child: Icon(
          Icons.insert_chart,
        ),
        backgroundColor: Colors.green,
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
                                      color: Colors.blueGrey),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: ListTile(
                                    leading: Icon(Icons.check),
                                    title: Text(
                                      'Peso: ${double.parse(data[index].peso).toStringAsFixed(2)} kgs.',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: ListTile(
                                    leading: data[index].grasa != null
                                        ? Icon(Icons.check)
                                        : Icon(Icons.close),
                                    title: data[index].grasa != null
                                        ? Text(
                                            'Grasa: ${((double.parse(data[index].grasa) * 0.01 * (double.parse(data[index].peso)))).toStringAsFixed(2)} kgs.',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold),
                                          )
                                        : Text(
                                            'Grasa: -',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold),
                                          ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: ListTile(
                                    leading: data[index].musculo != null
                                        ? Icon(Icons.check)
                                        : Icon(Icons.close),
                                    title: data[index].musculo != null
                                        ? Text(
                                            'Músculo: ${((double.parse(data[index].musculo) * 0.01 * (double.parse(data[index].peso)))).toStringAsFixed(2)} kgs.',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold),
                                          )
                                        : Text(
                                            'Músculo: -',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.redAccent,
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
                          ? Container(
                              margin: EdgeInsets.symmetric(horizontal: 50),
                              child: Padding(
                                padding: EdgeInsets.all(100),
                                child: Text(
                                  "NO HAY IMAGEN",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
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
