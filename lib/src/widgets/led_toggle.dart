import 'package:flutter/material.dart';

class LedToggle extends StatefulWidget {
  final String ledLabel;

  const LedToggle({
    Key? key,
    required this.ledLabel,
  }) : super(key: key);

  @override
  _LedToggleState createState() => _LedToggleState();
}

class _LedToggleState extends State<LedToggle> {
  bool isOn = false; // La variable booléenne initiale

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Column pour l'icône et le label de la LED
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Change l'icône en fonction de l'état de isOn
                  Icon(
                    isOn ? Icons.lightbulb : Icons.lightbulb_outline,
                    color: Colors.blue,
                    size: 32,
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.ledLabel,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
              const Spacer(),
              // Switch élément
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'On',
                style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey),
              ),
              Switch(
                value: isOn,
                onChanged: (newValue) {
                  setState(() {
                    isOn =
                        newValue; // Met à jour la variable avec la nouvelle valeur
                  });
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
}
