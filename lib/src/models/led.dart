class LED {
  int pinId;
  String name;
  String color;
  bool isOn;

  LED({required this.pinId, required this.name, required this.color, required this.isOn});

  factory LED.fromJson({required Map<String, dynamic> rawJson}) {
    return switch (rawJson) {
      {
      'pinId': int pinId,
      'name': String name,
      'color': String color,
      'isOn': bool isOn
      } =>
          LED(
            pinId: pinId,
            name: name,
            color: color,
            isOn: isOn
          ),
      _ => throw const FormatException('Failed to load led.'),
    };
  }
}