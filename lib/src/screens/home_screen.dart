import 'package:flutter/material.dart';
import 'package:sensor_control_front/src/widgets/LineChartSample.dart';
import '../models/Sensor.dart';
import '../models/led.dart';
import '../models/sensor_type.dart';
import '../services/esp32_client.dart';
import '../widgets/data_display.dart';
import '../widgets/led_toggle.dart';
import '../widgets/hardware_info.dart';
import 'dart:developer' as developer;

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ESP32Client esp32client = ESP32Client();
  List<LED> leds = []; // Initialisez la liste des LEDs à vide
  List<Sensor> sensors = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _fetchLEds();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: const Text(
                'SmartControl',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    fontSize: 30),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome to your smart device',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: DataDisplay(
                            icon: Icons.thermostat_outlined,
                            sensor: sensors.last,
                            description:
                                "La température détectée par le capteur est de : ",
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: DataDisplay(
                            icon: Icons.wb_sunny,
                            sensor: sensors.first,
                            description:
                                "La quantité de lumière perçue par le capteur est de : ",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: LedToggle(ledLabel: 'Led 1', led: leds.first),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: LedToggle(ledLabel: 'Led 2', led: leds.last),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: HardwareInfo(
                            label: 'RAM',
                            icon: Icons.storage,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: HardwareInfo(
                            label: 'CPU',
                            icon: Icons.memory,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 17, vertical: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Evolution lumiére 3 derniers Jour', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            LineChartSample(type: SensorType.brightness),
                          ],
                        )
                    ),
                    SizedBox(height: 18),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 17, vertical: 15),
                      decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Evolution température 3 derniers Jour', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            LineChartSample(type: SensorType.temperature),
                          ],
                        )
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Future<void> _fetchLEds() async {
    try {
      _loading = true;
      List<LED> fetchedLeds = await esp32client.fetchLEDs();
      List<Sensor> fetchedSensors = await esp32client.fetchSensors();

      setState(() {
        leds =
            fetchedLeds; // Met à jour les LEDs après avoir chargé les données
        sensors = fetchedSensors;
      });
      if (leds.isNotEmpty) {
        developer.log(leds[0].name, name: 'fetched led array');
      }
    } catch (e) {
      developer.log(e.toString());
    } finally {
      _loading = false;
    }
  }
}
