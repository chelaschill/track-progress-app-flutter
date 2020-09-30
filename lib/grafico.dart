import 'package:flutter/material.dart';
import 'package:bezier_chart/bezier_chart.dart';

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
    if (medida == 'grasa') {
      for (int i = 0; i < widget.data.length; i++) {
        if (widget.data[i].grasa != null) {
          suma += double.parse(widget.data[i].grasa) *
              0.01 *
              double.parse(widget.data[i].peso);
        }
      }
      promedio = suma / widget.data.length;
      return double.parse(double.parse(promedio.toString()).toStringAsFixed(2));
    } else if (medida == 'musculo') {
      for (int i = 0; i < widget.data.length; i++) {
        if (widget.data[i].musculo != null) {
          suma += double.parse(widget.data[i].musculo) *
              0.01 *
              double.parse(widget.data[i].peso);
        }
      }
      promedio = suma / widget.data.length;
      return double.parse(double.parse(promedio.toString()).toStringAsFixed(2));
    } else if (medida == 'peso') {
      for (int i = 0; i < widget.data.length; i++) {
        if (widget.data[i].peso != null) {
          suma += double.parse(widget.data[i].peso);
        }
      }
      promedio = suma / widget.data.length;
      return double.parse(double.parse(promedio.toString()).toStringAsFixed(2));
    }
  }

  List<DataPoint<DateTime>> showPeso() {
    List<DataPoint<DateTime>> points = [];
    for (int i = 0; i < widget.data.length; i++) {
      if (!points.contains(widget.data[i].date)) {
        points.add(DataPoint<DateTime>(
            value: double.parse(
                (double.parse(widget.data[i].peso).toStringAsFixed(2))),
            xAxis: widget.data[i].date));
      }
    }
    return points;
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
          points.add(DataPoint<DateTime>(
              value: bandera
                  ? 0
                  : double.parse((double.parse(widget.data[i].grasa) *
                          0.01 *
                          double.parse(widget.data[i].peso))
                      .toStringAsFixed(2)),
              xAxis: widget.data[i].date));
        }
      }
    } else if (medida == 'musculo') {
      for (int i = 0; i < widget.data.length; i++) {
        var bandera = false;
        if (widget.data[i].musculo == null) {
          bandera = true;
        }
        if (!points.contains(widget.data[i].date)) {
          points.add(DataPoint<DateTime>(
              value: bandera
                  ? 0
                  : double.parse((double.parse(widget.data[i].musculo) *
                          0.01 *
                          double.parse(widget.data[i].peso))
                      .toStringAsFixed(2)),
              xAxis: widget.data[i].date));
        }
      }
    }
    return points;
  }

  @override
  Widget build(BuildContext context) {
    final fromDate = widget.data[0].date; //la menor fecha
    final toDate = DateTime.now(); // la maxima fecha

    return Scaffold(
      appBar: AppBar(
        title: Text('GRÁFICO'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: BezierChart(
          fromDate: fromDate,
          bezierChartScale: BezierChartScale.WEEKLY,
          toDate: toDate,
          selectedDate: toDate,
          series: [
            BezierLine(
              lineColor: Colors.black45,
              label: "Peso",
              onMissingValue: (_) => missingValue('peso'),
              data: showPeso(),
            ),
            BezierLine(
              lineColor: Colors.redAccent,
              label: "Grasa",
              onMissingValue: (_) => missingValue('grasa'),
              data: showMetric('grasa'),
            ),
            BezierLine(
              lineColor: Colors.blue,
              label: "Musculo",
              onMissingValue: (_) => missingValue('musculo'),
              data: showMetric('musculo'),
            ),
          ],
          config: BezierChartConfig(
              showDataPoints: true, //muestra los puntos
              displayYAxis: true,
              stepsYAxis: 15,
              bubbleIndicatorLabelStyle: TextStyle(color: Colors.black),
              /*backgroundGradient: LinearGradient(
                  colors: [Colors.deepPurpleAccent, Colors.deepOrangeAccent],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight),*/
              /*displayLinesXAxis: true,
            pinchZoom: true,
            xLinesColor: Colors.deepPurpleAccent,
            , */ //ni idea que hacen
              displayDataPointWhenNoValue:
                  false, //esconde puntos no registrados
              updatePositionOnTap: true,
              verticalIndicatorStrokeWidth: 3.0,
              verticalIndicatorColor: Colors.black26,
              showVerticalIndicator: true,
              verticalIndicatorFixedPosition: false,
              backgroundColor: Color(0xFFC3EBF4),
              footerHeight: 35.0,
              xAxisTextStyle: TextStyle(color: Colors.black),
              yAxisTextStyle: TextStyle(color: Colors.black)),
        ),
      ),
    );
  }
}
