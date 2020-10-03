import 'dart:io';
/*import 'dart:convert';

Metrics metricsFromJson(String str) {
  final jsonData = json.decode(str);
  return Metrics.fromMap(jsonData);
}

String metricsToJson(Metrics data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}*/

class Metrics {
  final String peso;
  final String grasa;
  final String musculo;
  final DateTime date;
  final File image;
  final String imageName;
  final String dateString;

  Metrics({
    this.peso,
    this.grasa,
    this.musculo,
    this.date,
    this.image,
    this.dateString,
    this.imageName,
  });

  factory Metrics.fromMap(Map<String, dynamic> json) => Metrics(
        peso: json["peso"],
        grasa: json["grasa"],
        musculo: json["musculo"],
        date: DateTime.parse(
          json["date"],
        ),
        dateString: json["dateString"],
        imageName: json["imageName"],
      );
  Map<String, dynamic> toMap() => {
        "peso": peso,
        "grasa": grasa,
        "musculo": musculo,
        "date": date.toIso8601String(),
        "dateString": dateString,
        "imageName": imageName,
      };
}
