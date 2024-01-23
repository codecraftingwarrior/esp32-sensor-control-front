# Smart Sensor Control

Smart Sensor Control est une application mobile Flutter conçue pour interagir avec un réseau de capteurs et de LED via Firebase Realtime Database. Elle permet aux utilisateurs de visualiser et de contrôler l'environnement de leur maison intelligente ou de leur espace de travail avec facilité et en temps réel.

## Fonctionnalités Principales

- **Contrôle de LED** : Allumez et éteignez les LED connectées avec une simple interaction utilisateur.
- **Réglage des Seuils de Capteurs** : Modifiez les seuils critiques pour chaque capteur pour personnaliser les alertes et les automatisations.
- **Affichage des Données des Capteurs** : Consultez les valeurs actuelles des capteurs, comme la température, l'humidité, la luminosité, et plus.
- **Streaming de Données en Temps Réel** : Recevez les données des capteurs en continu grâce à l'intégration avec Firebase Realtime Database.
- **Visualisation de Statistiques** : Analysez l'évolution des mesures des capteurs au fil du temps à travers des graphiques et des statistiques détaillées.
- **Interface Réactive** : Profitez d'une interface utilisateur intuitive et réactive qui s'adapte aux différents appareils et orientations d'écran.
- **Alertes et Notifications** : Soyez informé instantanément lorsqu'un capteur dépasse le seuil critique défini.
- **Support Multiplateforme** : Utilisez l'application sur n'importe quel appareil mobile avec la même expérience fluide.
- **Personnalisation Avancée** : Configurez les paramètres avancés des capteurs pour une automatisation et un contrôle précis.

## Prérequis

- Flutter SDK (version 2.x.x ou supérieure)
- Dart SDK (version 2.x.x ou supérieure)
- Une carte ESP32 avec une carte TTGO intégrée
- Un dispositif physique ou un émulateur pour tester l'application
- Accès configuré à une instance Firebase Realtime Database

## Installation

1. Clonez le dépôt Git :
```sh
git clone [https://your-repository-link](https://github.com/codecraftingwarrior/esp32-sensor-control-front.git)
cd esp32-sensor-control-front
```

1. Installez les dépendances :

```sh
flutter pub get
```

2. Configurez Firebase :

- Ajoutez `google-services.json` dans `android/app` pour Android.
- Ajoutez `GoogleService-Info.plist` dans `ios/Runner` pour iOS.

## Lancement de l'Application

Exécutez l'application en utilisant la commande suivante :

```sh
flutter run
```

## Contribution
Les contributions sont ce qui rend la communauté open source si incroyable. Tout type de contribution est grandement apprécié.
