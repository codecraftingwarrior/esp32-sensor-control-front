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

  @override
  void initState() {
    super.initState();
    //_fetchData();
  }



  Future<void> _fetchData() async {
    const String apiUrl =
        'https://quizzapi.jomoreschi.fr/api/v1/quiz?limit=5&category=tv_cinema&difficulty=facile';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      final data = json.decode(response.body);
      if (response.statusCode == 200 && data.quizzes is List && data.isNotEmpty) {
        setState(() {
          _id = data[0]["_id"] ??
              'ID non trouvé'; // Met à jour avec l'ID, sinon affiche 'ID non trouvé'
        });
      } else {
        setState(() {
          _id = 'Erreur de chargement'; // En cas d'erreur de réponse
        });
        developer.log(response.body, name: 'rest api call');
      }
    } catch (e) {
      setState(() {
        _id = 'Erreur de connexion'; // En cas d'exception réseau
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              '10%', // Affiche l'ID ou le message de chargement
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
