import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sensor_control_front/src/services/constants.dart';

import '../models/Sensor.dart';
import '../models/led.dart';


class ESP32Client {

  static final ESP32Client _instance = ESP32Client._internal();

  factory ESP32Client() {
    return _instance;
  }

  ESP32Client._internal();

  Future<List<LED>> fetchLEDs() async {
    http.Response response = await http.get(Uri.http(esp32BaseURI, '/leds'));

    if(response.statusCode != 200) throw Exception('Something went wrong while fetching leds');

    List<dynamic> jsonList = json.decode(response.body);

    return jsonList.reversed.skip(1).map((jsonItem) => LED.fromJson(rawJson: jsonItem)).toList();
  }

  Future<List<Sensor>> fetchSensors() async {
    http.Response response = await http.get(Uri.http(esp32BaseURI, '/sensors'));

    if(response.statusCode != 200) throw Exception('Something went wrong while fetching sensors');

    List<dynamic> jsonList = json.decode(response.body);
    print(response.body);
    return jsonList.map((jsonItem) => Sensor.fromJson(rawJson: jsonItem)).toList();
  }

  Future<bool> toggleLED(int pinId) async {
    http.Response response = await http.put(
      Uri.http(esp32BaseURI, '/toggle-leds', {'pinId': pinId.toString()}),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{})
    );

    if(response.statusCode != 200) throw Exception('Something went wrong while toggling leds.');

    Map<String, dynamic> jsonResp = jsonDecode(response.body) as Map<String, dynamic>;

    return jsonResp['state'] == 'success' ? true : false;
  }

  Future<bool> updateThreshold(String sensorType, double value) async {
    http.Response response = await http.put(
        Uri.http(esp32BaseURI, '/sensors/update-threshold', {
          'type': sensorType.toString(),
          'threshold': value.toString()
        }),
        headers: <String, String> {
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{})
    );

    if(response.statusCode != 200) throw Exception('Something went wrong while updating threshold.');

    Map<String, dynamic> jsonResp = jsonDecode(response.body) as Map<String, dynamic>;

    return jsonResp['state'] == 'success' ? true : false;
  }
}