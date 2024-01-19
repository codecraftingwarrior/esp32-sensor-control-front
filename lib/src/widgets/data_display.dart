import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sensor_control_front/src/models/sensor_type.dart';
import 'package:sensor_control_front/src/services/esp32_client.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/Sensor.dart';

class DataDisplay extends StatefulWidget {
  final IconData icon;
  final String description; // Paramètre supplémentaire pour le texte descriptif
  final Sensor sensor;

  const DataDisplay({
    Key? key,
    required this.icon,
    required this.description, // Ne pas oublier d'ajouter le paramètre au constructeur
    required this.sensor,
  }) : super(key: key);

  @override
  State<DataDisplay> createState() => _DataDisplayState();
}

class _DataDisplayState extends State<DataDisplay> {
  ESP32Client esp32client = ESP32Client();
  final DatabaseReference _readingsRef =
      FirebaseDatabase.instance.ref('readings');
  dynamic valueDisplay = 0;

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
          if (widget.sensor.type == SensorType.brightness.name) {
            dynamic brightness = readings['brightness'];
            if (brightness is double) {
              brightness = double.parse(brightness.toStringAsFixed(2));
            }
            valueDisplay = brightness;
          } else {
            dynamic temperature = readings['temperature'];
            if (temperature is double) {
              temperature = double.parse(temperature.toStringAsFixed(2));
            }
            valueDisplay = temperature;
          }

          // Vous pouvez maintenant utiliser ces valeurs pour les afficher dans votre UI
          // Par exemple, si ce DataDisplay est pour la température:
          return _buildSensorDisplay(context);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  InkWell _buildSensorDisplay(BuildContext context) {
    return InkWell(
      onTap: () => _showPopup(context),
      onLongPress: () => _showBottomSheet(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(widget.icon, size: 40, color: Colors.blue),
            Text(
              widget.sensor.type == SensorType.temperature.name
                  ? '$valueDisplay°C'
                  : valueDisplay.toString(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.tune),
                // Icône pour "Modifier la valeur seuil"
                title: const Text('Modifier la valeur seuil'),
                onTap: () {
                  // Logique pour "Modifier la valeur seuil"
                  Navigator.pop(
                      context); // Ferme le Bottom Sheet après la sélection
                  _showEditThresholdDialog(
                      context); // Affiche la boîte de dialogue d'édition
                },
              ),
              ListTile(
                leading: const Icon(Icons.bar_chart),
                // Icône pour "Voir les statistiques"
                title: const Text('Voir les statistiques'),
                onTap: () {
                  // Logique pour "Voir les statistiques"
                  Navigator.pop(
                      context); // Ferme le Bottom Sheet après la sélection
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible:
          true, // Permet de fermer la pop-up en cliquant en dehors
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Icon(widget.icon,
              size: 40, color: Colors.blue), // Icône du container correspondant
          content: SingleChildScrollView(
            child: RichText(
              // Utilisez RichText pour le texte en ligne
              text: TextSpan(
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16.0), // Style par défaut pour le texte
                children: <TextSpan>[
                  TextSpan(text: widget.description), // Texte descriptif
                  TextSpan(
                    text: ' ${widget.sensor.currentValue}', // Valeur en gras
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showEditThresholdDialog(BuildContext context) {
    final TextEditingController _thresholdController = TextEditingController();
    bool updating = false;

    // Affiche la boîte de dialogue avec un champ de saisie
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modifier la valeur seuil'),
          content: TextField(
            controller: _thresholdController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            // Clavier pour nombres décimaux
            decoration: const InputDecoration(
                hintText: "Entrez la nouvelle valeur seuil"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.pop(context); // Ferme la boîte de dialogue
              },
            ),
            TextButton(
              child: const Text('Enregistrer'),
              onPressed: () async {
                try {
                  updating = true;
                  bool isSuccessful = await esp32client.updateThreshold(
                      widget.sensor.type,
                      double.parse(_thresholdController.value.text.trim()));
                  if (isSuccessful) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Seuil modifié avec succès')));
                  }
                  Navigator.pop(context); // Ferme la boîte de dialogue
                } catch (e) {
                  print(e.toString());
                } finally {
                  updating = false;
                }
              },
            ),
          ],
        );
      },
    );
  }
}
