import 'package:flutter/material.dart';
import '../widgets/data_display.dart'; // Assurez-vous que les chemins d'accès correspondent
import '../widgets/led_toggle.dart';
import '../widgets/hardware_info.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Hello there!',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w800, fontSize: 48),
        ),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
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
                      value: '15,8°C',
                      icon: Icons.thermostat_outlined,
                      description:
                          "La température détectée par le capteur est de : ",
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: DataDisplay(
                      value: '17%',
                      icon: Icons.wb_sunny,
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
                    child: LedToggle(ledLabel: 'Led 1'),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: LedToggle(ledLabel: 'Led 2'),
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
            ],
          ),
        ),
      ),
    );
  }
}
