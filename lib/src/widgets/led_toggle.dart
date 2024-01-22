import 'package:flutter/material.dart';
import 'package:sensor_control_front/src/services/esp32_client.dart';
import 'dart:developer' as developer;

import '../models/led.dart';

class LedToggle extends StatefulWidget {
  final String ledLabel;
  final LED? led;

  const LedToggle({Key? key, required this.ledLabel, this.led})
      : super(key: key);

  @override
  _LedToggleState createState() => _LedToggleState();
}

class _LedToggleState extends State<LedToggle> {
  bool isOn = false; // La variable booléenne initiale
  ESP32Client esp32client = ESP32Client();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(child: CircularProgressIndicator())
        : Container(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.white, // Fond blanc
              borderRadius: BorderRadius.circular(10), // Coins arrondis
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3), // Ombre légère
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Change l'icône en fonction de l'état de isOn
                    Icon(
                      isOn ? Icons.lightbulb : Icons.lightbulb_outline,
                      color: Colors.blue,
                      size: 32,
                    ),
                    SizedBox(height: 10),
                    //Texte qui dépasse
                    Text(
                      widget.led!.name,
                      softWrap: true,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'On',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.grey),
                    ),
                    Switch(
                      value: isOn,
                      onChanged: (newValue) {
                        toggleLED();
                      },
                      activeColor: Colors.blue,
                      // Couleur active du switch
                      inactiveThumbColor: Colors.white,
                      // Couleur inactive du rond
                      inactiveTrackColor:
                          Colors.grey[300], // Couleur inactive de la piste
                    ),
                  ],
                ),
              ],
            ),
          );
  }

  Future<void> toggleLED() async {
    try {
      _loading = true;
      bool isSuccessful = await esp32client.toggleLED(widget.led!.pinId);
      if(isSuccessful) {
        setState(() {
          isOn = !isOn;
        });
      }
    } catch (e) {
      developer.log(e.toString(), name: 'error');
    } finally {
      _loading = false;
    }
  }
}
