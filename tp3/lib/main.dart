import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:build_runner/build_runner.dart';
part 'job.dart';

void main() async {

  // Initialize hive
  await Hive.initFlutter();
 // Hive.registerAdapter("Job");

  var box = await Hive.openBox('jobBox');

  var job = Job(
      entreprise: 'IUT',
      salaireBrutAnnuel: 51000,
      choixStatut: 'cadre',
      salaireNetMensuel: 2500,
      sentiment: 'Bonne entreprise'
  );

  await box.put('job', job);

  print(box.get('job'));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jobs',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Suivi de jobs'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        children: <Widget>[Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Mon suivi de jobs',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
            ),
          ],
        ),    
          Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[IconButton(
          icon: const Icon(Icons.add_circle),
          tooltip: 'Ajouter une nouvelle proposition',
          onPressed: () {
              Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SecondScreen()),
  );
          }),
            const Text(
              ' Nouvelle proposition',
            ),
          ],
        ),
        ],
      ),
    );
  }
}

enum Statut { cadre, noncadre }

class SecondScreen extends StatefulWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  State<SecondScreen> createState() => SecondScreenState();
}

class SecondScreenState extends State<SecondScreen> {
  Statut? _statut = Statut.cadre;

  @override
  Widget build (BuildContext ctxt) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nouvelle proposition"),
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                const Text('Nouvelle proposition', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32)),
                Row(children: <Widget>[
                  IconButton(
                      icon: const Icon(Icons.calendar_month_outlined),
                      tooltip: 'Calendrier',
                      onPressed: () {
                      }),
                  Flexible( // Choix de la date et affichage en temps réel de l'âge de la personne grâce à _pickDate() puis dateUpdate() qui tournera chaque seconde une fois une date choisie
                      child: TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Entreprise'
                          ),
                          onTap: () {
                          }))
                ]),
                Row(children: <Widget>[
                  IconButton(
                      icon: const Icon(Icons.calendar_month_outlined),
                      tooltip: 'Calendrier',
                      onPressed: () {
                      }),
                  Flexible(
                      child: TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Salaire brut annuel (en euros)'
                          ),
                          onTap: () {
                          }))
                ]),  Row(children: <Widget>[
                  IconButton(
                      icon: const Icon(Icons.calendar_month_outlined),
                      tooltip: 'Calendrier',
                      onPressed: () {
                      }),
                   Flexible(child: ListTile(
                    title: const Text('Cadre (25%)'),
                    leading: Radio<Statut>(
                    value: Statut.cadre,
                    groupValue: _statut,
                    onChanged: (Statut? value) {
                      setState(() {
                        _statut = value;
                      });
                    },
                  ),
                  )),
                   Flexible(child: ListTile(
                    title: Text('Non cadre (22%)'),
                    leading: Radio<Statut>(
                      value: Statut.noncadre,
                      groupValue: _statut,
                      onChanged: (Statut? value) {
                        setState(() {
                          _statut = value;
                        });
                      },
                    ),
                  )),
                ]),
                Row(children: <Widget>[
                  IconButton(
                      icon: const Icon(Icons.calendar_month_outlined),
                      tooltip: 'Calendrier',
                      onPressed: () {
                      }),
                  Flexible(
                      child: TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Salaire net mensuel (en euros)'
                          ),
                          onTap: () {
                          }))
                ]),
                Row(children: <Widget>[
                  IconButton(
                      icon: const Icon(Icons.calendar_month_outlined),
                      tooltip: 'Calendrier',
                      onPressed: () {
                      }),
                  Flexible(
                      child: TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Mon sentiment'
                          ),
                          minLines: 3,
                          maxLines: 5,
                          onTap: () {
                          }))
                ]),
                TextFormField(decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Entrez l\'entreprise'
                ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                Row(mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                  Flexible(
                      child: TextButton(
                        onPressed: () {},
                        child: const Text('Valider')
                      )
                  )
                ])
              ],
          ),
      )
      ,
    );
  }
}
