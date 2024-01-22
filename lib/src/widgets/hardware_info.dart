import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logging/logging.dart';
import 'dart:developer' as developer;

import '../services/esp32_client.dart';

class HardwareInfo extends StatefulWidget {
  final String label;
  final IconData icon;

  const HardwareInfo({
    Key? key,
    required this.label,
    required this.icon,
  }) : super(key: key);

  @override
  _HardwareInfoState createState() => _HardwareInfoState();
}

class _HardwareInfoState extends State<HardwareInfo> {
  String _id = 'Chargement...'; // Valeur initiale
  ESP32Client esp32client = ESP32Client();
  final log = Logger('HardwareInfo');

  final DatabaseReference _readingsRef =
      FirebaseDatabase.instance.ref('readings');
  dynamic valueDisplay = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DatabaseEvent>(
      stream: _readingsRef.onValue,
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            !snapshot.hasError &&
            snapshot.data!.snapshot.value != null) {
          Map<dynamic, dynamic> readings =
              Map<dynamic, dynamic>.from(snapshot.data!.snapshot.value as Map);
          if (widget.label == 'RAM') {
            valueDisplay = readings['ram'];
          } else {
            valueDisplay = readings['cpu'];
          }

          // Vous pouvez maintenant utiliser ces valeurs pour les afficher dans votre UI
          // Par exemple, si ce DataDisplay est pour la température:
          return _render();
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Container _render() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(widget.icon, size: 40, color: Colors.blue),
              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              "${valueDisplay.toString()}%", // Affiche l'ID ou le message de chargement
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 45,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}
