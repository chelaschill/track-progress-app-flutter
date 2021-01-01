import 'package:flutter/material.dart';
import 'package:bezier_chart/bezier_chart.dart';
import 'package:intl/intl.dart' as intl;

import 'package:progreso_corporal_app/database.dart';
import 'package:progreso_corporal_app/widgets/metrics.dart';

class Grafico extends StatefulWidget {
  static const routeName = 'grafico-screen';

  final List<Metrics> data;

  Grafico(this.data);

  @override
  _GraficState createState() => _GraficState();
}

class _GraficState extends State<Grafico> {
  double missingValue(String medida) {
    double suma = 0;
    double promedio;
    int contador = 0;
    if (medida == 'grasa') {
      for (int i = 0; i < widget.data.length; i++) {
        if (widget.data[i].grasa != null) {
          suma += double.parse(widget.data[i].grasa) *
              0.01 *
              double.parse(widget.data[i].peso);
          contador++;
        }
      }
      if (contador == 0) {
        return 0;
      }
      promedio = suma / contador;
      return double.parse(double.parse(promedio.toString()).toStringAsFixed(2));
    } else if (medida == 'musculo') {
      for (int i = 0; i < widget.data.length; i++) {
        if (widget.data[i].musculo != null) {
          suma += double.parse(widget.data[i].musculo) *
              0.01 *
              double.parse(widget.data[i].peso);
          contador++;
        }
      }
      if (contador == 0) {
        return 0;
      }
      promedio = suma / contador;
      return double.parse(double.parse(promedio.toString()).toStringAsFixed(2));
    } else if (medida == 'peso') {
      for (int i = 0; i < widget.data.length; i++) {
        if (widget.data[i].peso != null) {
          suma += double.parse(widget.data[i].peso);
          contador++;
        }
      }
      if (contador == 0) {
        return 0;
      }
      promedio = suma / contador;
      return double.parse(
        double.parse(promedio.toString()).toStringAsFixed(2),
      );
    }
  }

  List<DataPoint<DateTime>> showPeso() {
    List<DataPoint<DateTime>> points = [];
    for (int i = 0; i < widget.data.length; i++) {
      if (!points.contains(widget.data[i].date)) {
        points.add(
          DataPoint<DateTime>(
              value: double.parse(
                (double.parse(widget.data[i].peso).toStringAsFixed(2)),
              ),
              xAxis: widget.data[i].date),
        );
      }
    }
    return points;
  }

  List<DataPoint<DateTime>> dataMensual(String medida) {
    List<DataPoint<DateTime>> mensual = [];
    List<List<Metrics>> separadorAnio = [];

    int anioInicial = widget.data[0].date.year;
    int anioFinal = widget.data[widget.data.length - 1].date.year;

    for (int w = anioInicial; w <= anioFinal; w++) {
      List<Metrics> temp = [];
      for (int x = 0; x < widget.data.length; x++) {
        if (widget.data[x].date.year == w) {
          temp.add(widget.data[x]);
        }
      }
      separadorAnio.add(temp);
    }

    if (medida == 'peso') {
      for (int n = 0; n < separadorAnio.length; n++) {
        int mesInicial = separadorAnio[n][0].date.month;
        int mesFinal = separadorAnio[n][separadorAnio[n].length - 1].date.month;
        for (int i = mesInicial; i <= mesFinal; i++) {
          int contador = 0;
          double suma = 0;
          double promedio = 0;
          int index = 0;
          for (int j = 0; j < separadorAnio[n].length; j++) {
            if (separadorAnio[n][j].date.month == i) {
              suma += double.parse(separadorAnio[n][j].peso);
              contador++;
            }
          }
          if (contador != 0) {
            promedio = suma / contador;
            for (int k = 0; k < separadorAnio.length; k++) {
              if (separadorAnio[n][k].date.month == i) {
                index = k;
                break;
              }
            }
            mensual.add(
              DataPoint<DateTime>(
                  value: double.parse(
                    (promedio).toStringAsFixed(2),
                  ),
                  xAxis: separadorAnio[n][index].date),
            );
          }
        }
      }
      return mensual;
    } else if (medida == 'grasa') {
      for (int n = 0; n < separadorAnio.length; n++) {
        int mesInicial = separadorAnio[n][0].date.month;
        int mesFinal = separadorAnio[n][separadorAnio[n].length - 1].date.month;
        for (int i = mesInicial; i <= mesFinal; i++) {
          int contador = 0;
          double suma = 0;
          double promedio = 0;
          int index = 0;
          for (int j = 0; j < separadorAnio[n].length; j++) {
            if (separadorAnio[n][j].date.month == i &&
                separadorAnio[n][j].grasa != null) {
              suma += double.parse(separadorAnio[n][j].grasa) *
                  0.01 *
                  double.parse(separadorAnio[n][j].peso);
              contador++;
            }
          }
          if (contador != 0) {
            promedio = suma / contador;
            for (int k = 0; k < separadorAnio.length; k++) {
              if (separadorAnio[n][k].date.month == i) {
                index = k;
                break;
              }
            }
            mensual.add(
              DataPoint<DateTime>(
                  value: double.parse((promedio).toStringAsFixed(2)),
                  xAxis: separadorAnio[n][index].date),
            );
          }
        }
      }
      return mensual;
    } else if (medida == 'musculo') {
      for (int n = 0; n < separadorAnio.length; n++) {
        int mesInicial = separadorAnio[n][0].date.month;
        int mesFinal = separadorAnio[n][separadorAnio[n].length - 1].date.month;
        for (int i = mesInicial; i <= mesFinal; i++) {
          int contador = 0;
          double suma = 0;
          double promedio = 0;
          int index = 0;
          for (int j = 0; j < separadorAnio[n].length; j++) {
            if (separadorAnio[n][j].date.month == i &&
                separadorAnio[n][j].musculo != null) {
              suma += double.parse(separadorAnio[n][j].musculo) *
                  0.01 *
                  double.parse(separadorAnio[n][j].peso);
              contador++;
            }
          }
          if (contador != 0) {
            promedio = suma / contador;
            for (int k = 0; k < separadorAnio.length; k++) {
              if (separadorAnio[n][k].date.month == i) {
                index = k;
                break;
              }
            }
            mensual.add(
              DataPoint<DateTime>(
                  value: double.parse((promedio).toStringAsFixed(2)),
                  xAxis: separadorAnio[n][index].date),
            );
          }
        }
      }
      return mensual;
    }
  }

  List<DataPoint<DateTime>> dataAnual(String medida) {
    List<DataPoint<DateTime>> anual = [];

    int anioInicial = widget.data[0].date.year;
    int anioFinal = widget.data[widget.data.length - 1].date.year;

    if (medida == 'peso') {
      for (int i = anioInicial; i <= anioFinal; i++) {
        int contador = 0;
        double suma = 0;
        double promedio = 0;
        int index = 0;
        for (int j = 0; j < widget.data.length; j++) {
          if (widget.data[j].date.year == i) {
            suma += double.parse(widget.data[j].peso);
            contador++;
          } else if (widget.data[j].date.year > i) {
            break;
          }
        }
        if (contador != 0) {
          promedio = suma / contador;
          for (int k = 0; k < widget.data.length; k++) {
            if (widget.data[k].date.year == i) {
              index = k;
              break;
            }
          }
          anual.add(DataPoint<DateTime>(
              value: double.parse((promedio).toStringAsFixed(2)),
              xAxis: widget.data[index].date));
        }
      }
      return anual;
    } else if (medida == 'grasa') {
      for (int i = anioInicial; i <= anioFinal; i++) {
        int contador = 0;
        double suma = 0;
        double promedio = 0;
        int index = 0;
        for (int j = 0; j < widget.data.length; j++) {
          if (widget.data[j].date.year == i && widget.data[j].grasa != null) {
            suma += double.parse(widget.data[j].grasa) *
                0.01 *
                double.parse(widget.data[j].peso);
            contador++;
          } else if (widget.data[j].date.year > i) {
            break;
          }
        }
        if (contador != 0) {
          promedio = suma / contador;
          for (int k = 0; k < widget.data.length; k++) {
            if (widget.data[k].date.year == i) {
              index = k;
              break;
            }
          }
          anual.add(
            DataPoint<DateTime>(
                value: double.parse((promedio).toStringAsFixed(2)),
                xAxis: widget.data[index].date),
          );
        }
      }
      return anual;
    } else if (medida == 'musculo') {
      for (int i = anioInicial; i <= anioFinal; i++) {
        int contador = 0;
        double suma = 0;
        double promedio = 0;
        int index = 0;
        for (int j = 0; j < widget.data.length; j++) {
          if (widget.data[j].date.year == i && widget.data[j].musculo != null) {
            suma += double.parse(widget.data[j].musculo) *
                0.01 *
                double.parse(widget.data[j].peso);
            contador++;
          } else if (widget.data[j].date.year > i) {
            break;
          }
        }
        if (contador != 0) {
          promedio = suma / contador;
          for (int k = 0; k < widget.data.length; k++) {
            if (widget.data[k].date.year == i) {
              index = k;
              break;
            }
          }
          anual.add(
            DataPoint<DateTime>(
                value: double.parse((promedio).toStringAsFixed(2)),
                xAxis: widget.data[index].date),
          );
        }
      }
      return anual;
    }
  }

  List<DataPoint<DateTime>> showMetric(String medida) {
    List<DataPoint<DateTime>> points = [];
    if (medida == 'grasa') {
      for (int i = 0; i < widget.data.length; i++) {
        var bandera = false;
        if (widget.data[i].grasa == null) {
          bandera = true;
        }
        if (!points.contains(widget.data[i].date)) {
          if (!bandera) {
            points.add(DataPoint<DateTime>(
                value: double.parse((double.parse(widget.data[i].grasa) *
                        0.01 *
                        double.parse(widget.data[i].peso))
                    .toStringAsFixed(2)),
                xAxis: widget.data[i].date));
          }
        }
      }
    } else if (medida == 'musculo') {
      for (int i = 0; i < widget.data.length; i++) {
        var bandera = false;
        if (widget.data[i].musculo == null) {
          bandera = true;
        }
        if (!points.contains(widget.data[i].date)) {
          if (!bandera) {
            points.add(DataPoint<DateTime>(
                value: double.parse((double.parse(widget.data[i].musculo) *
                        0.01 *
                        double.parse(widget.data[i].peso))
                    .toStringAsFixed(2)),
                xAxis: widget.data[i].date));
          }
        }
      }
    }
    return points;
  }

  List<double> xAxisValues() {
    List<double> points = [];
    for (int i = 0; i < widget.data.length; i++) {
      points.add(double.parse((widget.data[i].date.month).toString()));
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
    final fromDate = widget.data[0].date;
    final toDate = widget.data[widget.data.length - 1].date;
    final appBar = AppBar(
      backgroundColor: Colors.blueGrey,
      title: const Text('Gráfico'),
    );

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Column(
                children: [
                  Text(
                    'SEMANAL',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  Container(
                    color: Colors.blueGrey,
                    height: MediaQuery.of(context).size.height * 0.75,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: BezierChart(
                      bezierChartScale: BezierChartScale.WEEKLY,
                      fromDate: fromDate,
                      toDate: toDate,
                      selectedDate: toDate,
                      footerDateTimeBuilder:
                          (DateTime value, BezierChartScale scaleType) {
                        final newFormat = intl.DateFormat('dd/MM');
                        return newFormat.format(value);
                      },
                      series: showLines("weekly"),
                      config: BezierChartConfig(
                        showDataPoints: true,
                        displayYAxis: true,
                        stepsYAxis: 15,
                        bubbleIndicatorLabelStyle:
                            TextStyle(color: Colors.black),
                        displayLinesXAxis: false,
                        pinchZoom: false,
                        displayDataPointWhenNoValue: false,
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
                        startYAxisFromNonZeroValue: false,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'MENSUAL',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  Container(
                    color: Colors.blueGrey,
                    height: MediaQuery.of(context).size.height * 0.75,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: BezierChart(
                      bezierChartScale: BezierChartScale.MONTHLY,
                      fromDate: fromDate,
                      toDate: toDate,
                      selectedDate: toDate,
                      series: showLines("monthly"),
                      config: BezierChartConfig(
                        showDataPoints: true,
                        displayYAxis: true,
                        stepsYAxis: 15,
                        bubbleIndicatorLabelStyle:
                            TextStyle(color: Colors.black),
                        displayLinesXAxis: false,
                        pinchZoom: false,
                        displayDataPointWhenNoValue: false,
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
                        startYAxisFromNonZeroValue: false,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'ANUAL',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    Container(
                      color: Colors.blueGrey,
                      height: MediaQuery.of(context).size.height * 0.75,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: BezierChart(
                        bezierChartScale: BezierChartScale.YEARLY,
                        fromDate: fromDate,
                        toDate: toDate,
                        selectedDate: toDate,
                        series: showLines("yearly"),
                        config: BezierChartConfig(
                          showDataPoints: true,
                          displayYAxis: true,
                          stepsYAxis: 15,
                          bubbleIndicatorLabelStyle:
                              TextStyle(color: Colors.black),
                          displayLinesXAxis: false,
                          pinchZoom: false,
                          displayDataPointWhenNoValue: false,
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
                          startYAxisFromNonZeroValue: false,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
