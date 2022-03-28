import 'dart:async';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Partie principale de l'application
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Exercice n°2 Flutter',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              bottom: const TabBar(
// Les deux onglets en haut
                tabs: [
                  Tab(
                      icon: Icon(Icons.calendar_month_outlined),
                      text: 'Calcul d\'âge'),
                  Tab(
                      icon: Icon(Icons.calendar_today_outlined),
                      text: 'Différence entre deux dates'),
                ],
              ),
              title: const Text('Exercice n°2 Flutter'),
            ),
            body: const TabBarView(
              children: [
// Permet d'accéder aux deux pages
                MyHomePage(title: 'Calcul d\'âge'),
                NewPage(title: 'Différence entre deux dates')
              ],
            ),
          ),
        ));
  }
}

// Premier onglet
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// state de la première page
class _MyHomePageState extends State<MyHomePage> {
// Initialisation des variables qui seront utiles au moment pour calculer l'age de la personne

  DateTime pickedDate = DateTime.now();
  Duration dureeEcart = Duration.zero;
  int anneeEcart = 0;
  int jourEcart = 0;
  int heureEcart = 0;
  int minuteEcart = 0;
  int secondeEcart = 0;
  TextEditingController dateCtl =
  TextEditingController(); // Permettra de modifier le texte de l'input du choix de la date, une fois que l'utilisateur a sélectionné la date, la date apparait dans le champ

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Colors.pink,
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text('Date de Naissance :',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32)),
                  Row(children: <Widget>[
                    IconButton(
                        icon: const Icon(Icons.calendar_month_outlined),
                        tooltip: 'Calendrier',
                        onPressed: () {}),
                    Flexible(
                      // Choix de la date et affichage en temps réel de l'âge de la personne grâce à _pickDate() puis dateUpdate() qui tournera chaque seconde une fois une date choisie
                        child: TextField(
                            controller: dateCtl,
                            decoration: const InputDecoration(
                                hintText:
                                'Entrez votre date de naissance (JJ/MM/DD)'),
                            onTap: () {
                              _pickDate();
                            }))
                  ]),
                  if (dureeEcart !=
                      Duration
                          .zero) // Si la personne n'a pas indiqué sa date de naissance, on affichera pas son âge
                    Text(
                        'Tu as $anneeEcart ans \n et \n $jourEcart jour(s), \n $heureEcart heure(s) $minuteEcart minute(s) $secondeEcart seconde(s)',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                  if (jourEcart == 0 &&
                      dureeEcart !=
                          Duration
                              .zero) // Affichage d'un message si c'est l'anniversaire
                    const Text('Joyeux anniversaire 🎂 ! ',
                        style: TextStyle(fontSize: 28, color: Colors.pink))
                ])));
  }

// Selection de la date
  _pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year -
          200), // Dates à partir desquelles on peut la sélectionner
      lastDate: DateTime.now(),
      initialDate: pickedDate,
    );

    if (date != null) {
      setState(() {
        Timer.periodic(const Duration(seconds: 1), (timer) {
          dateUpdate();
// do something or call a function
        });
        pickedDate = date;
        dateCtl.text = DateFormat('dd/MM/yyyy').format(
            pickedDate); // Reformatage de la date récupéré au bon format comme dans l'énoncé
      });
    }
  }

// Cette fonction va permettre de calculer la durée depuis laquelle s'est écoulé depuis la date choisie au format année, jour, heures, minutes, secondes
  void dateUpdate() {
    if (mounted) {
      setState(() {
        dureeEcart = DateTime.now().difference(pickedDate);
        anneeEcart = DateTime.now().year - pickedDate.year;
        jourEcart = DateTime.now().difference(pickedDate).inDays -
            (365 *
                anneeEcart); // A chaque fois, il faut penser à enlever les valeurs déjà utilisé, ici avec les années
        if (jourEcart < 0) {
          anneeEcart -= 1;
          jourEcart += 365;
        }
        heureEcart = DateTime.now().difference(pickedDate).inHours -
            (365 * anneeEcart * 24) -
            (jourEcart * 24);
        minuteEcart = DateTime.now().difference(pickedDate).inMinutes -
            (365 * anneeEcart * 24 * 60) -
            (jourEcart * 24 * 60) -
            (heureEcart * 60);
        secondeEcart = DateTime.now().difference(pickedDate).inSeconds -
            (365 * anneeEcart * 24 * 60 * 60) -
            (jourEcart * 24 * 60 * 60) -
            (heureEcart * 60 * 60) -
            (minuteEcart * 60);
      });
    }
  }
}

// La deuxième page permettant de comparer deux dates
class NewPage extends StatefulWidget {
  const NewPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<NewPage> createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
// Initialisation des variables
  bool datesChoisis = false;
  DateTime pickedDate = DateTime.now();
  DateTime pickedDate2 = DateTime.now();
  Duration dureeEcart = Duration.zero;
  int anneeEcart = 0;
  int moisEcart = 0;
  int jourEcart = 0;
  int heureEcart = 0;
  int minuteEcart = 0;
  int secondeEcart = 0;
  TextEditingController dateCtl =
  TextEditingController(); // Permettra de montrer les dates dans l'input
  TextEditingController dateCtl2 = TextEditingController();

// La partie graphique avec le choix de deux dates et l'affichage du nombres d'années, mois et jours qui s'est écoulé entre les deux dates
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Colors.green,
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(children: <Widget>[
                    const Text(
                      'Date 1',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    IconButton(
                        icon: const Icon(Icons.calendar_month_outlined),
                        tooltip: 'Calendrier',
                        onPressed: () {}),
                    Expanded(
                        child: TextField(
                            decoration: const InputDecoration(hintText: 'JJ/MM/DD'),
                            controller: dateCtl,
                            onTap: () {
                              _pickDate(); // Choix de la date
                            }))
                  ]),
                  Row(children: <Widget>[
                    const Text('Date 2',
                        style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    IconButton(
                        icon: const Icon(Icons.calendar_month_outlined),
                        tooltip: 'Calendrier',
                        onPressed: () {}),
                    Expanded(
                        child: TextField(
                            decoration: const InputDecoration(hintText: 'JJ/MM/DD'),
                            controller: dateCtl2,
                            onTap: () {
                              _pickDate2();
                            }))
                  ]),
                  if (datesChoisis != false)
                    Text(
                        'La différence entre les deux dates est de : \n $anneeEcart an(s), $moisEcart mois $jourEcart jour(s)',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20))
                  // Affichage
                ])));
  }

// Conditions et traitement du choix des dates
  _pickDate() async {
    DateTime? date = await showDatePicker(
        context: context,
        firstDate: DateTime(DateTime.now().year - 200),
        lastDate: DateTime.now(),
        initialDate: pickedDate);

    if (date != null) {
      setState(() {
        // Permettra de dire que l'état du state a été changé et qu'il faut mettre à jour les valeurs
        pickedDate = date;
        dateCtl.text =
            DateFormat('dd/MM/yyyy').format(pickedDate); // Formatage des dates
        dateUpdate(); // Comparaison entre les deux dates
      });
    }
  }

// La même chose pour la deuxième date
  _pickDate2() async {
    DateTime? date2 = await showDatePicker(
        context: context,
        firstDate: DateTime(DateTime.now().year - 200),
        lastDate: DateTime.now(),
        initialDate: pickedDate);

    if (date2 != null) {
      setState(() {
        pickedDate2 = date2;
        dateCtl2.text = DateFormat('dd/MM/yyyy').format(pickedDate2);
        dateUpdate();
      });
    }
  }

// Calcul et mise à jour de l'écart entre les dates
  void dateUpdate() {
    setState(() {
      dureeEcart = pickedDate2
          .difference(pickedDate)
          .abs(); // On veut etre sur que l'écart est positif

      anneeEcart = dureeEcart.inDays ~/ 365;
      moisEcart = (dureeEcart.inDays - (365 * anneeEcart)) ~/ 31;
      jourEcart = dureeEcart.inDays - (365 * anneeEcart) - (moisEcart * 31);

      if (datesChoisis == false && dateCtl.text != '' && dateCtl2.text != '') {
        // Variable permettant de savoir si les dates ont été choisis, on affichera un texte que si les deux dates ont été initialisés
        datesChoisis = true;
      }
    });
  }
}
