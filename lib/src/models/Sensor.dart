
class Sensor {
  int pinId;
  String name;
  String type;
  bool isOn;
  dynamic currentValue;

  Sensor({required this.pinId,
    required this.name,
    required this.type,
    required this.isOn,
    required this.currentValue});

  factory Sensor.fromJson({required Map<String, dynamic> rawJson}) {
    var value = rawJson['currentValue'];

    if (value is double) {
      value = double.parse(value.toStringAsFixed(2));
    }

    return
          Sensor(
              pinId: rawJson['pinId'],
              name: rawJson['name'],
              type: rawJson['type'],
              isOn: rawJson['isOn'],
              currentValue: value
          );

  }
}
