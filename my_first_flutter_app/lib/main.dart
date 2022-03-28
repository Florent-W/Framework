import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Exercice n°1 Flutter',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(
            title: 'Exercice n°1 Flutter') // Lancement de la première page
        );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// Les states de la page d'accueil
class _MyHomePageState extends State<MyHomePage> {
  int compteur = 0;
  int? meilleurTemps;

  int temps = 0;
  late Timer timerCompteur;

  // Cette fonction va servir à incrémenter le compteur qui ira jusqu'à 10 avant de changer de page
  void _augmenterCompteur() {
    setState(() {
      compteur++;
      if (compteur > 10) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const NewPage(
                title:
                    'Exercice n°1 Flutter')))
            .then((value) {
              startTimer();
        }); // On remet à zéro le compteur et on passe à la page suivante
        timerCompteur.cancel();
        if(meilleurTemps == null || temps < meilleurTemps!) {
          setState(() {
            meilleurTemps = temps;
          });
        }
      }
    });
  }

  // Cette fonction va servir à diminuer le compteur
  void _diminuerCompteur() {
    setState(() {
      compteur--;
    });
  }

  void startTimer() {
    setState(() {
      temps = 0;
      compteur = 0;
    });

    timerCompteur = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        temps = temps + 1;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        // Le menu de la première page
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: [
                  const Text(
                    'Meilleur temps : ',
                    style: TextStyle(fontSize: 23),
                  ),
                  Text(
                   meilleurTemps == null ? "Aucun record" : meilleurTemps.toString(),
                    style: const TextStyle(fontSize: 23),
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.end,
              ),
              Row(
                children: [
                  const Text(
                    'Timer : ',
                    style: TextStyle(fontSize: 23),
                  ),
                  Text(
                    '$temps',
                    style: const TextStyle(fontSize: 23),
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.end,
              ),
              Row(
                children: const [
                  Text(
                    'Compteur',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 43),
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceAround, // Permet de séparer les élements sur une ligne avec autant d'espace
                  children: <Widget>[
                    FloatingActionButton(
                        // Un bouton qui permet d'augmenter le compteur
                        tooltip: 'Augmente le compteur de 1',
                        onPressed: () {
                          _augmenterCompteur();
                        },
                        backgroundColor: Colors.green,
                        child: const Icon(Icons.add_circle),
                        heroTag:
                            "boutonPlus" // Les heros tags servent à déterminer l'id des boutons
                        ),
                    Text('$compteur', style: const TextStyle(fontSize: 32)),
                    FloatingActionButton(
                        tooltip: 'Diminue le compteur de 1',
                        onPressed: () {
                          _diminuerCompteur();
                        },
                        backgroundColor: Colors.red,
                        child: const Icon(Icons.remove_circle),
                        heroTag:
                            "boutonMoins" // Les heros tags servent à déterminer l'id des boutons
                        )
                  ])
            ]));
  }
}

// La deuxième page de l'application contenant le helloworld et un bouton retour pour revenir sur la page d'accueil
class NewPage extends StatefulWidget {
  const NewPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<NewPage> createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green, // Changement de la couleur de la barre
          title: Text(widget.title),
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
            Widget>[
          Row(
            children: const [
              Text(
                'Hello World',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 43), // Bouton pour revenir à l'écran précédent
              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                // Changement des styles des boutons
                textStyle: const TextStyle(fontSize: 32),
              ),
              onPressed: () {
                Navigator.pop(context);
              }, // Un appui sur le bouton permet de revenir en arrière
              child: const Text('Retour'),
            )
          ])
        ]));
  }
}
