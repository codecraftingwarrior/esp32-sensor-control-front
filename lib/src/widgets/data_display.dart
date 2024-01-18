import 'package:flutter/material.dart';

class DataDisplay extends StatelessWidget {
  final String value;
  final IconData icon;
  final String description; // Paramètre supplémentaire pour le texte descriptif

  const DataDisplay({
    Key? key,
    required this.value,
    required this.icon,
    required this.description, // Ne pas oublier d'ajouter le paramètre au constructeur
  }) : super(key: key);

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
          title: Icon(icon,
              size: 40, color: Colors.blue), // Icône du container correspondant
          content: SingleChildScrollView(
            child: RichText(
              // Utilisez RichText pour le texte en ligne
              text: TextSpan(
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16.0), // Style par défaut pour le texte
                children: <TextSpan>[
                  TextSpan(text: description), // Texte descriptif
                  TextSpan(
                    text: ' $value', // Valeur en gras
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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showPopup(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
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
            Icon(icon, size: 40, color: Colors.blue),
            Text(
              value,
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
}
