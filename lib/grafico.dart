import 'package:flutter/material.dart';
import 'package:bezier_chart/bezier_chart.dart';
import 'package:intl/intl.dart' as intl;

import 'package:progreso_corporal_app/widgets/metrics.dart';
import 'package:progreso_corporal_app/database.dart';
import 'package:progreso_corporal_app/historial.dart';

class Grafico extends StatefulWidget {
  static const routeName = 'grafico-screen';

  @override
  _GraficState createState() => _GraficState();
}

class _GraficState extends State<Grafico> {
  HistorialDB _historialDB = HistorialDB();

  double missingValue(String medida) {
    double suma = 0;
    double promedio;
    int contador = 0;
    if (medida == 'grasa') {
      for (int i = 0; i < data.length; i++) {
        if (data[i].grasa != null) {
          suma +=
              double.parse(data[i].grasa) * 0.01 * double.parse(data[i].peso);
          contador++;
        }
      }
      if (contador == 0) {
        return 0;
      }
      promedio = suma / contador;
      return double.parse(double.parse(promedio.toString()).toStringAsFixed(2));
    } else if (medida == 'musculo') {
      for (int i = 0; i < data.length; i++) {
        if (data[i].musculo != null) {
          suma +=
              double.parse(data[i].musculo) * 0.01 * double.parse(data[i].peso);
          contador++;
        }
      }
      if (contador == 0) {
        return 0;
      }
      promedio = suma / contador;
      return double.parse(double.parse(promedio.toString()).toStringAsFixed(2));
    } else if (medida == 'peso') {
      for (int i = 0; i < data.length; i++) {
        if (data[i].peso != null) {
          suma += double.parse(data[i].peso);
        }
      }
      promedio = suma / data.length;
      return double.parse(double.parse(promedio.toString()).toStringAsFixed(2));
    }
  }

  List<DataPoint<DateTime>> showPeso() {
    List<DataPoint<DateTime>> points = [];
    for (int i = 0; i < data.length; i++) {
      if (!points.contains(data[i].date)) {
        points.add(DataPoint<DateTime>(
            value:
                double.parse((double.parse(data[i].peso).toStringAsFixed(2))),
            xAxis: data[i].date));
      }
    }
    return points;
  }

  List<DataPoint<DateTime>> dataMensual(String medida) {
    List<DataPoint<DateTime>> mensual = [];

    int mesInicial = data[0].date.month;
    int mesFinal = data[data.length - 1].date.month;

    if (medida == 'peso') {
      for (int i = mesInicial; i <= mesFinal; i++) {
        int contador = 0;
        double suma = 0;
        double promedio = 0;
        int index = 0;
        for (int j = 0; j < data.length; j++) {
          if (data[j].date.month == i) {
            suma += double.parse(data[j].peso);
            contador++;
          } else if (data[j].date.month > i) {
            break;
          }
        }
        promedio = suma / contador;
        for (int k = 0; k < data.length; k++) {
          if (data[k].date.month == i) {
            index = k;
            break;
          }
        }
        mensual.add(
          DataPoint<DateTime>(
              value: double.parse((promedio).toStringAsFixed(2)),
              xAxis: data[index].date),
        );
      }
      return mensual;
    } else if (medida == 'grasa') {
      for (int i = mesInicial; i <= mesFinal; i++) {
        int contador = 0;
        double suma = 0;
        double promedio = 0;
        int index = 0;
        for (int j = 0; j < data.length; j++) {
          if (data[j].date.month == i && data[j].grasa != null) {
            suma +=
                double.parse(data[j].grasa) * 0.01 * double.parse(data[j].peso);
            contador++;
          } else if (data[j].date.month > i) {
            break;
          }
        }
        if (contador == 0) {
          return mensual;
        }
        promedio = suma / contador;
        for (int k = 0; k < data.length; k++) {
          if (data[k].date.month == i) {
            index = k;
            break;
          }
        }
        mensual.add(DataPoint<DateTime>(
            value: double.parse((promedio).toStringAsFixed(2)),
            xAxis: data[index].date));
      }
      return mensual;
    } else if (medida == 'musculo') {
      for (int i = mesInicial; i <= mesFinal; i++) {
        int contador = 0;
        double suma = 0;
        double promedio = 0;
        int index = 0;
        for (int j = 0; j < data.length; j++) {
          if (data[j].date.month == i && data[j].musculo != null) {
            suma += double.parse(data[j].musculo) *
                0.01 *
                double.parse(data[j].peso);
            contador++;
          } else if (data[j].date.month > i) {
            break;
          }
        }
        if (contador == 0) {
          return mensual;
        }
        promedio = suma / contador;
        for (int k = 0; k < data.length; k++) {
          if (data[k].date.month == i) {
            index = k;
            break;
          }
        }
        mensual.add(
          DataPoint<DateTime>(
              value: double.parse((promedio).toStringAsFixed(2)),
              xAxis: data[index].date),
        );
      }
      return mensual;
    }
  }

  List<DataPoint<DateTime>> dataAnual(String medida) {
    List<DataPoint<DateTime>> anual = [];

    int anioInicial = data[0].date.year;
    int anioFinal = data[data.length - 1].date.year;

    if (medida == 'peso') {
      for (int i = anioInicial; i <= anioFinal; i++) {
        int contador = 0;
        double suma = 0;
        double promedio = 0;
        int index = 0;
        for (int j = 0; j < data.length; j++) {
          if (data[j].date.year == i) {
            suma += double.parse(data[j].peso);
            contador++;
          } else if (data[j].date.year > i) {
            break;
          }
        }
        promedio = suma / contador;
        for (int k = 0; k < data.length; k++) {
          if (data[k].date.year == i) {
            index = k;
            break;
          }
        }
        anual.add(DataPoint<DateTime>(
            value: double.parse((promedio).toStringAsFixed(2)),
            xAxis: data[index].date));
      }
      return anual;
    } else if (medida == 'grasa') {
      for (int i = anioInicial; i <= anioFinal; i++) {
        int contador = 0;
        double suma = 0;
        double promedio = 0;
        int index = 0;
        for (int j = 0; j < data.length; j++) {
          if (data[j].date.year == i && data[j].grasa != null) {
            suma +=
                double.parse(data[j].grasa) * 0.01 * double.parse(data[j].peso);
            contador++;
          } else if (data[j].date.year > i) {
            break;
          }
        }
        if (contador == 0) {
          return anual;
        }
        promedio = suma / contador;
        for (int k = 0; k < data.length; k++) {
          if (data[k].date.year == i) {
            index = k;
            break;
          }
        }
        anual.add(DataPoint<DateTime>(
            value: double.parse((promedio).toStringAsFixed(2)),
            xAxis: data[index].date));
      }
      return anual;
    } else if (medida == 'musculo') {
      for (int i = anioInicial; i <= anioFinal; i++) {
        int contador = 0;
        double suma = 0;
        double promedio = 0;
        int index = 0;
        for (int j = 0; j < data.length; j++) {
          if (data[j].date.year == i && data[j].musculo != null) {
            suma += double.parse(data[j].musculo) *
                0.01 *
                double.parse(data[j].peso);
            contador++;
          } else if (data[j].date.year > i) {
            break;
          }
        }
        if (contador == 0) {
          return anual;
        }
        promedio = suma / contador;
        for (int k = 0; k < data.length; k++) {
          if (data[k].date.year == i) {
            index = k;
            break;
          }
        }
        anual.add(
          DataPoint<DateTime>(
              value: double.parse((promedio).toStringAsFixed(2)),
              xAxis: data[index].date),
        );
      }
      return anual;
    }
  }

  List<DataPoint<DateTime>> showMetric(String medida) {
    List<DataPoint<DateTime>> points = [];
    if (medida == 'grasa') {
      for (int i = 0; i < data.length; i++) {
        var bandera = false;
        if (data[i].grasa == null) {
          bandera = true;
        }
        if (!points.contains(data[i].date)) {
          if (!bandera) {
            points.add(DataPoint<DateTime>(
                value: double.parse((double.parse(data[i].grasa) *
                        0.01 *
                        double.parse(data[i].peso))
                    .toStringAsFixed(2)),
                xAxis: data[i].date));
          }
        }
      }
    } else if (medida == 'musculo') {
      for (int i = 0; i < data.length; i++) {
        var bandera = false;
        if (data[i].musculo == null) {
          bandera = true;
        }
        if (!points.contains(data[i].date)) {
          if (!bandera) {
            points.add(DataPoint<DateTime>(
                value: double.parse((double.parse(data[i].musculo) *
                        0.01 *
                        double.parse(data[i].peso))
                    .toStringAsFixed(2)),
                xAxis: data[i].date));
          }
        }
      }
    }
    return points;
  }

  List<double> xAxisValues() {
    List<double> points = [];
    for (int i = 0; i < data.length; i++) {
      points.add(double.parse((data[i].date.month).toString()));
    }
    return points;
  }

  List<BezierLine> showLines(String scale) {
    List<BezierLine> lines = [];

    if (scale == "weekly") {
      lines.add(
        BezierLine(
          lineColor: Colors.black45,
          label: "Peso",
          onMissingValue: (_) => missingValue('peso'),
          data: showPeso(),
        ),
      );
      for (int i = 0; i < showMetric("grasa").length; i++) {
        if (showMetric("grasa")[i].value != 0) {
          lines.add(
            BezierLine(
              lineColor: Colors.orange,
              label: "Grasa",
              onMissingValue: (_) => missingValue('grasa'),
              data: showMetric('grasa'),
            ),
          );
          break;
        }
      }
      for (int i = 0; i < showMetric("musculo").length; i++) {
        if (showMetric("musculo")[i].value != 0) {
          lines.add(
            BezierLine(
              lineColor: Colors.red,
              label: "Músculo",
              onMissingValue: (_) => missingValue('musculo'),
              data: showMetric('musculo'),
            ),
          );
          break;
        }
      }
    } else if (scale == "monthly") {
      lines.add(
        BezierLine(
          lineColor: Colors.black45,
          label: "Peso",
          onMissingValue: (_) => missingValue('peso'),
          data: dataMensual("peso"),
        ),
      );
      for (int i = 0; i < showMetric("grasa").length; i++) {
        if (showMetric("grasa")[i].value != 0) {
          lines.add(
            BezierLine(
              lineColor: Colors.orange,
              label: "Grasa",
              onMissingValue: (_) => missingValue('grasa'),
              data: dataMensual("grasa"),
            ),
          );
          break;
        }
      }
      for (int i = 0; i < showMetric("musculo").length; i++) {
        if (showMetric("musculo")[i].value != 0) {
          lines.add(
            BezierLine(
              lineColor: Colors.red,
              label: "Músculo",
              onMissingValue: (_) => missingValue('musculo'),
              data: dataMensual("musculo"),
            ),
          );
          break;
        }
      }
    } else if (scale == "yearly") {
      lines.add(
        BezierLine(
          lineColor: Colors.black45,
          label: "Peso",
          onMissingValue: (_) => missingValue('peso'),
          data: dataAnual("peso"),
        ),
      );
      for (int i = 0; i < showMetric("grasa").length; i++) {
        if (showMetric("grasa")[i].value != 0) {
          lines.add(
            BezierLine(
              lineColor: Colors.orange,
              label: "Grasa",
              onMissingValue: (_) => missingValue('grasa'),
              data: dataAnual('grasa'),
            ),
          );
          break;
        }
      }
      for (int i = 0; i < showMetric("musculo").length; i++) {
        if (showMetric("musculo")[i].value != 0) {
          lines.add(
            BezierLine(
              lineColor: Colors.red,
              label: "Músculo",
              onMissingValue: (_) => missingValue('musculo'),
              data: dataAnual('musculo'),
            ),
          );
          break;
        }
      }
    }

    return lines;
  }

  @override
  Widget build(BuildContext context) {
    final fromDate = data[0].date; //la menor fecha
    final toDate = data[data.length - 1].date; // la maxima fecha
    final appBar = AppBar(
      title: Text('Gráfico'),
    );

    return Scaffold(
        appBar: appBar,
        body: ListView(
          children: [
            Column(
              children: [
                Container(
                  color: Colors.grey,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: BezierChart(
                    bezierChartScale: BezierChartScale.WEEKLY,
                    //xAxisCustomValues: xAxisValues(),
                    fromDate: fromDate,
                    toDate: toDate,
                    selectedDate: toDate,
                    footerDateTimeBuilder:
                        (DateTime value, BezierChartScale scaleType) {
                      final newFormat = intl.DateFormat('dd/MM');
                      return newFormat.format(value);
                    },
                    /*footerValueBuilder: (double value) {
                      return "${value.toInt()}\nHrs";
                    },*/
                    series: showLines("weekly"), //showLines("weekly"),
                    config: BezierChartConfig(
                        showDataPoints: true, //muestra los puntos
                        displayYAxis: true,
                        stepsYAxis: 15,
                        bubbleIndicatorLabelStyle:
                            TextStyle(color: Colors.black),
                        /*backgroundGradient: LinearGradient(
                        colors: [Colors.deepPurpleAccent, Colors.deepOrangeAccent],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight),*/
                        displayLinesXAxis: true,
                        pinchZoom: false,
                        //xLinesColor: Colors.deepPurpleAccent,
                        //ni idea que hacen
                        displayDataPointWhenNoValue:
                            false, //esconde puntos no registrados
                        updatePositionOnTap: true,
                        verticalIndicatorStrokeWidth: 3.0,
                        verticalIndicatorColor: Colors.black26,
                        bubbleIndicatorColor: Colors.white60,
                        bubbleIndicatorTitleStyle: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        showVerticalIndicator: false,
                        verticalIndicatorFixedPosition: false,
                        backgroundColor: Colors.transparent,
                        footerHeight: 35.0,
                        xAxisTextStyle: TextStyle(color: Colors.black),
                        yAxisTextStyle:
                            TextStyle(color: Colors.black, fontSize: 10),
                        startYAxisFromNonZeroValue: false),
                  ),
                ),
                Container(
                  color: Colors.grey,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: BezierChart(
                    bezierChartScale: BezierChartScale.MONTHLY,
                    //xAxisCustomValues: xAxisValues(),
                    fromDate: fromDate,
                    toDate: toDate,
                    selectedDate: toDate,
                    series: showLines("monthly"),
                    config: BezierChartConfig(
                        showDataPoints: true, //muestra los puntos
                        displayYAxis: true,
                        stepsYAxis: 15,
                        bubbleIndicatorLabelStyle:
                            TextStyle(color: Colors.black),
                        /*backgroundGradient: LinearGradient(
                        colors: [Colors.deepPurpleAccent, Colors.deepOrangeAccent],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight),*/
                        displayLinesXAxis: true,
                        pinchZoom: false,
                        //xLinesColor: Colors.deepPurpleAccent,
                        //ni idea que hacen
                        displayDataPointWhenNoValue:
                            false, //esconde puntos no registrados
                        updatePositionOnTap: false,
                        verticalIndicatorStrokeWidth: 3.0,
                        verticalIndicatorColor: Colors.black26,
                        bubbleIndicatorColor: Colors.white60,
                        bubbleIndicatorTitleStyle: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        showVerticalIndicator: false,
                        verticalIndicatorFixedPosition: false,
                        backgroundColor: Colors.transparent,
                        footerHeight: 35.0,
                        xAxisTextStyle: TextStyle(color: Colors.black),
                        yAxisTextStyle:
                            TextStyle(color: Colors.black, fontSize: 10),
                        startYAxisFromNonZeroValue: false),
                  ),
                ),
                Container(
                  color: Colors.grey,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: BezierChart(
                    bezierChartScale: BezierChartScale.YEARLY,
                    //xAxisCustomValues: xAxisValues(),
                    fromDate: fromDate,
                    toDate: toDate,
                    selectedDate: toDate,
                    series: showLines("yearly"),
                    config: BezierChartConfig(
                        showDataPoints: true, //muestra los puntos
                        displayYAxis: true,
                        stepsYAxis: 15,
                        bubbleIndicatorLabelStyle:
                            TextStyle(color: Colors.black),
                        /*backgroundGradient: LinearGradient(
                        colors: [Colors.deepPurpleAccent, Colors.deepOrangeAccent],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight),*/
                        displayLinesXAxis: true,
                        pinchZoom: false,
                        //xLinesColor: Colors.deepPurpleAccent,
                        //ni idea que hacen
                        displayDataPointWhenNoValue:
                            false, //esconde puntos no registrados
                        updatePositionOnTap: false,
                        verticalIndicatorStrokeWidth: 3.0,
                        verticalIndicatorColor: Colors.black26,
                        bubbleIndicatorColor: Colors.white60,
                        bubbleIndicatorTitleStyle: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        showVerticalIndicator: false,
                        verticalIndicatorFixedPosition: false,
                        backgroundColor: Colors.transparent,
                        footerHeight: 35.0,
                        xAxisTextStyle: TextStyle(color: Colors.black),
                        yAxisTextStyle:
                            TextStyle(color: Colors.black, fontSize: 10),
                        startYAxisFromNonZeroValue: false),
                  ),
                ),
              ],
            )
          ],
        ));
  }
}
