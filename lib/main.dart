import 'package:flutter/material.dart';
import 'src/screens/home_screen.dart'; // Assurez-vous que le chemin d'accès correspond à l'emplacement du fichier home_screen.dart

void main() {
  runApp(const MyFlutterApp());
}

class MyFlutterApp extends StatelessWidget {
  const MyFlutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity
      ),
      debugShowCheckedModeBanner: false,
      home:
      HomeScreen(), // Utilisation de HomeScreen comme écran principal
    );
  }
}
