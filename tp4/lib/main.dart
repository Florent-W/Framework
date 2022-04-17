import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculateur de salaire',
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
      home: const MyHomePage(title: 'Calculateur de salaire'),
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

enum Statut { cadre, noncadre, publique, liberale, portage }

class _MyHomePageState extends State<MyHomePage> {

  Statut? _statut = Statut.cadre;
  int? _nombreMoisPrime = 12;
  double _currentSliderValue = 1;
  double _sliderSourceValue = 1;

  // Les controlleurs permettant de définir les textes et de les changer
  TextEditingController salaireNetHoraireCtl = TextEditingController();
  TextEditingController salaireBrutHoraireCtl = TextEditingController();

  TextEditingController salaireNetMensuelCtl = TextEditingController();
  TextEditingController salaireBrutMensuelCtl = TextEditingController();

  TextEditingController salaireNetAnnuelCtl = TextEditingController();
  TextEditingController salaireBrutAnnuelCtl = TextEditingController();

  TextEditingController salaireNetMensuelApresImpotsCtl = TextEditingController();
  TextEditingController salaireNetAnnuelApresImpotsCtl = TextEditingController();

  // On créé une clé pour le formulaire, à l'aide de celle-ci, les champs pourront être vérifiés
  final _formKey = GlobalKey<FormState>();

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
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Form(key: _formKey,
          child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[ Text('Calcul du salaire Brut en Net', style:
          TextStyle(fontSize: 31, fontWeight: FontWeight.bold)),
            Row(children: [Text('INDIQUEZ VOTRE SALAIRE BRUT'), Text('RESULTAT DE VOTRE SALAIRE NET'), Text('SELECTIONNEZ VOTRE TEMPS DE TRAVAIL')
  ]),
        Row(children: [Flexible(child:
        TextFormField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.euro_outlined),
            labelText: 'Horaire brut',
            hintText: 'Ex : 19.23',
            border: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: Colors.blue, width: 2.0),
              borderRadius: BorderRadius.circular(25.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
          controller: salaireBrutHoraireCtl,
            onChanged: (Text) => salaireHoraireNetEnBrutUpdate(salaireBrutHoraireCtl, 'salaireBrutHoraire'),
            validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ce champ est vide, veuillez le compléter';
            }
          }
        )),
          Flexible(child:
          TextFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.euro_outlined),
                labelText: 'Horaire net',
                hintText: 'Ex : 15',
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Colors.blue, width: 2.0),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              controller: salaireNetHoraireCtl,
              onChanged: (Text) => salaireHoraireNetEnBrutUpdate(salaireNetHoraireCtl, 'salaireNetHoraire'),
    validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ce champ est vide, veuillez le compléter';
                }
              }
          )),
        ]),
        Row(children: <Widget> [Flexible(child:
        TextFormField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.euro_outlined),
              labelText: 'Mensuel brut',
              hintText: 'Ex : 2916.73',
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: Colors.blue, width: 2.0),
                borderRadius: BorderRadius.circular(25.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
          onChanged: (Text) => salaireHoraireNetEnBrutUpdate(salaireBrutMensuelCtl, 'salaireBrutMensuel'),
          validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ce champ est vide, veuillez le compléter';
              }
            },
          controller: salaireBrutMensuelCtl,
        )), Flexible(child:
        TextFormField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.euro_outlined),
              labelText: 'Mensuel net',
              hintText: 'Ex : 2275.05',
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: Colors.blue, width: 2.0),
                borderRadius: BorderRadius.circular(25.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
            controller: salaireNetMensuelCtl,
            onChanged: (Text) => salaireHoraireNetEnBrutUpdate(salaireNetMensuelCtl, 'salaireNetMensuel'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ce champ est vide, veuillez le compléter';
              }
            }
        )),
          const Text('SELECTIONNEZ LE NOMBRE DE MOIS DE PRIME CONVENTIONNELLE'),

        ]),

            Row(children: <Widget>[Flexible(child:
            TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.euro_outlined),
                  labelText: 'Annuel brut',
                  hintText: '35000.77',
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Colors.blue, width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                controller: salaireBrutAnnuelCtl,
                onChanged: (Text) => salaireHoraireNetEnBrutUpdate(salaireBrutAnnuelCtl, 'salaireBrutAnnuel'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ce champ est vide, veuillez le compléter';
                  }
                }
            )), Flexible(child:
            TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.euro_outlined),
                  labelText: 'Annuel net',
                  hintText: 'Ex : 27300.60',
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Colors.blue, width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                controller: salaireNetAnnuelCtl,
              onChanged: (Text) => salaireHoraireNetEnBrutUpdate(salaireNetAnnuelCtl, 'salaireNetAnnuel'),
              validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ce champ est vide, veuillez le compléter';
                  }
                },

            )), Flexible(
                child: ListTile(
                    title: const Text('12 mois'),
                    leading: Radio<int>(
                      value: 12,
                      groupValue: _nombreMoisPrime,
                      onChanged: (int? value) {
                        // Mise à jour du salaire
                        setState(() {
                          _nombreMoisPrime = value;
                          salaireHoraireNetEnBrutUpdate(salaireNetHoraireCtl, 'mois');
                        });
                      },
                    )
                )),
              Flexible(
                  child: ListTile(
                      title: const Text('13 mois'),
                      leading: Radio<int>(
                        value: 13,
                        groupValue: _nombreMoisPrime,
                        onChanged: (int? value) {
                          // Mise à jour du salaire
                          setState(() {
                            _nombreMoisPrime = value;
                            salaireHoraireNetEnBrutUpdate(salaireNetHoraireCtl, 'mois');
                          });
                        },
                      )
                  )),
              Flexible(
                  child: ListTile(
                      title: const Text('14 mois'),
                      leading: Radio<int>(
                        value: 14,
                        groupValue: _nombreMoisPrime,
                        onChanged: (int? value) {
                          // Mise à jour du salaire
                          setState(() {
                            _nombreMoisPrime = value;
                            salaireHoraireNetEnBrutUpdate(salaireNetHoraireCtl, 'mois');
                          });
                        },
                      )
                  )),
              Flexible(
                  child: ListTile(
                      title: const Text('15 mois'),
                      leading: Radio<int>(
                        value: 15,
                        groupValue: _nombreMoisPrime,
                        onChanged: (int? value) {
                          // Mise à jour du salaire
                          setState(() {
                            _nombreMoisPrime = value;
                            salaireHoraireNetEnBrutUpdate(salaireNetHoraireCtl, 'mois');
                          });
                        },
                      )
                  )),
              Flexible(
                  child: ListTile(
                      title: const Text('16 mois'),
                      leading: Radio<int>(
                        value: 16,
                        groupValue: _nombreMoisPrime,
                        onChanged: (int? value) {
                          // Mise à jour du statut et du salaire
                          setState(() {
                            _nombreMoisPrime = value;
                            salaireHoraireNetEnBrutUpdate(salaireNetHoraireCtl, 'mois');
                          });
                        },
                      )
                  ))
            ]),
            Row(children: [
              const Text('SELECTIONNEZ VOTRE STATUT :'),
              const Text('ESTIMATION DE VOTRE SALAIRE NET APRES LE PRELEVEMENT A LA SOURCE'),
              Slider(
                value: _currentSliderValue,
                max: 100,
                divisions: 5,
                label: _currentSliderValue.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _currentSliderValue = value;
                    salaireHoraireNetEnBrutUpdate(salaireNetHoraireCtl, 'slider');
                  });
                },
              ),

              Slider(
                value: _sliderSourceValue,
                min: 0,
                max: 43,
                divisions: 5,
                label: _sliderSourceValue.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _sliderSourceValue = value;
                    salaireHoraireNetEnBrutUpdate(salaireNetHoraireCtl, 'slider');
                  });
                },
              )
            ],
            ),
            Row(children: <Widget> [
    Flexible(
    child: ListTile(
    title: const Text('Non cadre'),
    leading: Radio<Statut>(
    value: Statut.noncadre,
    groupValue: _statut,
    onChanged: (Statut? value) {
    // Mise à jour du statut et du salaire
    setState(() {
    _statut = value;
    salaireHoraireNetEnBrutUpdate(salaireNetHoraireCtl, 'statut');
    });
    },
    )
    )),
              Flexible(
                  child: ListTile(
                      title: const Text('Cadre'),
                      leading: Radio<Statut>(
                        value: Statut.cadre,
                        groupValue: _statut,
                        onChanged: (Statut? value) {
                          // Mise à jour du statut et du salaire
                          setState(() {
                            _statut = value;
                            salaireHoraireNetEnBrutUpdate(salaireNetHoraireCtl, 'statut');
                          });
                        },
                      )
                  ))
                ,
              Flexible(
                  child: ListTile(
                      title: const Text('Fonction publique'),
                      leading: Radio<Statut>(
                        value: Statut.publique,
                        groupValue: _statut,
                        onChanged: (Statut? value) {
                          // Mise à jour du statut et du salaire
                          setState(() {
                            _statut = value;
                            salaireHoraireNetEnBrutUpdate(salaireNetHoraireCtl, 'statut');
                          });
                        },
                      )
                  )),
              Flexible(
                  child: ListTile(
                      title: const Text('Profession libérale'),
                      leading: Radio<Statut>(
                        value: Statut.liberale,
                        groupValue: _statut,
                        onChanged: (Statut? value) {
                          // Mise à jour du statut et du salaire
                          setState(() {
                            _statut = value;
                            salaireHoraireNetEnBrutUpdate(salaireNetHoraireCtl, 'statut');
                          });
                        },
                      )
                  )), Flexible(
                  child: ListTile(
                      title: const Text('Portage salarial'),
                      leading: Radio<Statut>(
                        value: Statut.portage,
                        groupValue: _statut,
                        onChanged: (Statut? value) {
                          // Mise à jour du statut et du salaire
                          setState(() {
                            _statut = value;
                            salaireHoraireNetEnBrutUpdate(salaireNetHoraireCtl, 'statut');
                          });
                        },
                      )
                  )),
              Flexible(child:
              TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.euro_outlined),
                    labelText: 'Mensuel net après impôts',
                    hintText: 'Ex : 2275.05',
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  controller: salaireNetMensuelApresImpotsCtl,
                  onChanged: (Text) => salaireHoraireNetEnBrutUpdate(salaireNetMensuelApresImpotsCtl, 'salaireNetMensuelApresImpots'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ce champ est vide, veuillez le compléter';
                    }
                  }
              )),
              Flexible(child:
              TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.euro_outlined),
                    labelText: 'Annuel net après impôts',
                    hintText: 'Ex : 27300.60',
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  controller: salaireNetAnnuelApresImpotsCtl,
                  onChanged: (Text) => salaireHoraireNetEnBrutUpdate(salaireNetAnnuelApresImpotsCtl, 'salaireNetAnnuelApresImpots'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ce champ est vide, veuillez le compléter';
                    }
                  }
              )),
            ],),            Row(children: <Widget> [TextButton(onPressed:
                () { // _formKey.currentState?.reset();
              resetFormulaire();
              },
                child: const Text('EFFACER LES CHAMPS'))])
          ],
        ),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    ));
  }

  // Méthode pour mettre à jour le salaire mensuel si le salaire annuel vient d'etre changé
  void salaireNetMensuelUpdate() {
    setState(() {
      // On regarde tout d'abord si le salaire annuel n'est pas vide
      if (salaireNetAnnuelCtl.text != '') {
        double salaire = double.parse(salaireNetAnnuelCtl.text);

        // Récvpération du salaire brut par mois
        salaire = salaire / 12;

        // La différence entre le brut et le net se fait selon le statut, il faut retirer 22 pourcent du salaire
        if (_statut == Statut.noncadre) {
          salaire -= salaire * (22 / 100);
        } else {
          salaire -= salaire * (25 / 100);
        }
        // Affichage du nombre sous forme décimale
        salaireNetMensuelCtl.text = salaire.toStringAsFixed(2);
      }
    });
  }

  // Mise à jour du salaire de net mensuel à brut annuel
  void salaireAnnuelUpdate() {
    setState(() {
      // On regarde tout d'abord si le salaire mensuel n'est pas vide
      if (salaireNetMensuelCtl.text != '') {
        double salaire = double.parse(salaireNetMensuelCtl.text);

        // La différence entre le brut et le net se fait selon le statut, avec cela, on retrouve le salaire mensuek brut
        if (_statut == Statut.noncadre) {
          salaire = (salaire / (78 / 100));
        } else {
          salaire = (salaire / (75 / 100));
        }

        // Récvpération du salaire brut par an
        salaire = salaire * 12;

        // Affichage du nombre sous forme décimale
        salaireNetAnnuelCtl.text = salaire.toStringAsFixed(2);
      }
    });
  }

  // Mise à jour du salaire
  void salaireHoraireNetEnBrutUpdate(TextEditingController champModifier, String typeChamp) {
    setState(() {
      // On regarde tout d'abord si le salaire mensuel n'est pas vide
      if (champModifier.text != '') {
        double salaire = double.parse(champModifier.text);
        double salaireNet = -1;
        double salaireNetMensuel = 0;
        double salaireNetAnnuel = 0;
        double salaireNetMensuelApresImpots = 0;
        double salaireNetAnnuelApresImpots = 0;

        double salaireBrut = -1;
        double salaireBrutMensuel = 0;
        double salaireBrutAnnuel = 0;

        if (typeChamp == 'salaireNetHoraire' || typeChamp == 'salaireNetMensuel' || typeChamp == 'salaireNetAnnuel' || typeChamp == 'salaireNetMensuelApresImpots' || typeChamp == 'salaireNetAnnuelApresImpots') {
          if(typeChamp == 'salaireNetHoraire') {
            salaireNet = salaire;
          }
          else if(typeChamp == 'salaireNetMensuel') {
            salaireNet = salaire / 151.67;
            salaireNetHoraireCtl.text = salaireNet.toStringAsFixed(2);
          }
          else if(typeChamp == 'salaireNetAnnuel') {
            salaireNet = (salaire / 12) / 151.67;
            salaireNetHoraireCtl.text = salaireNet.toStringAsFixed(2);
          }
          else if(typeChamp == 'salaireNetMensuelApresImpots') {
            double pourcentage = (100 - _sliderSourceValue) / 100;
            salaireNet = (salaire / pourcentage) / 151.67;
            salaireNetHoraireCtl.text = salaireNet.toStringAsFixed(2);
          }
          else if(typeChamp == 'salaireNetAnnuelApresImpots') {
            double pourcentage = (100 - _sliderSourceValue) / 100;
            salaireNet = ((salaire / pourcentage) / 12) / 151.67;
            salaireNetHoraireCtl.text = salaireNet.toStringAsFixed(2);
          }

          // La différence entre le brut et le net se fait selon le statut, avec cela, on retrouve le salaire mensuel brut
          switch(_statut) {
            case Statut.noncadre:
              salaireBrut = (salaireNet / (78 / 100));
              break;
            case Statut.cadre:
              salaireBrut = (salaireNet / (75 / 100));
              break;
            case Statut.publique:
              salaireBrut = (salaireNet / (85 / 100));
              break;
            case Statut.liberale:
              salaireBrut = (salaireNet / (55 / 100));
              break;
            default:
              salaireBrut = (salaireNet / (49 / 100));
          }

          salaireBrutHoraireCtl.text = salaireBrut.toStringAsFixed(2);
        }
        else if(typeChamp == 'salaireBrutHoraire' || typeChamp == 'salaireBrutMensuel' || typeChamp == 'salaireBrutAnnuel' || typeChamp == 'statut') {
          if(typeChamp == 'salaireBrutHoraire') {
            salaireBrut = salaire;
          }
          else if(typeChamp == "statut") {
            salaireBrut = double.parse(salaireBrutHoraireCtl.text);
          }
          else if(typeChamp == 'salaireBrutMensuel') {
            salaireBrut = salaire / 151.67;
            salaireBrutHoraireCtl.text = salaireBrut.toStringAsFixed(2);
          }
          else if(typeChamp == 'salaireBrutAnnuel') {
            salaireBrut = (salaire / 12) / 151.67;
            salaireBrutHoraireCtl.text = salaireBrut.toStringAsFixed(2);
          }

          switch(_statut) {
            case Statut.noncadre:
              salaireNet = (salaireBrut * (78 / 100));
              break;
            case Statut.cadre:
              salaireNet = (salaireBrut * (75 / 100));
              break;
            case Statut.publique:
              salaireNet = (salaireBrut * (85 / 100));
              break;
            case Statut.liberale:
              salaireNet = (salaireBrut * (55 / 100));
              break;
            default:
              salaireNet = (salaireBrut * (49 / 100));
          }

          salaireNetHoraireCtl.text = salaireNet.toStringAsFixed(2);
        }

          if(salaireNet == -1 && salaireNetHoraireCtl.text != '') {
            salaireNet = double.parse(salaireNetHoraireCtl.text);
          }
          if(salaireBrut == -1 && salaireBrutHoraireCtl.text != '') {
            salaireBrut = double.parse(salaireBrutHoraireCtl.text);
          }

          salaireNetMensuel = salaireNet * 151.67;
          salaireBrutMensuel = salaireBrut * 151.67;

          if(_currentSliderValue != null) {
            salaireNetMensuel = salaireNetMensuel * (_currentSliderValue / 100);
            salaireBrutMensuel = salaireBrutMensuel * (_currentSliderValue / 100);
          }

          if(typeChamp != 'salaireNetMensuel') {
            salaireNetMensuelCtl.text = salaireNetMensuel.toStringAsFixed(2);
          }
          if(typeChamp != 'salaireBrutMensuel') {
            salaireBrutMensuelCtl.text = salaireBrutMensuel.toStringAsFixed(2);
          }

          if(_sliderSourceValue != null) {
            salaireNetMensuelApresImpots = salaireNetMensuel - (salaireNetMensuel * (_sliderSourceValue / 100));
          } else {
            salaireNetMensuelApresImpots = salaireNetMensuel;
          }

          if(typeChamp != 'salaireNetMensuelApresImpots') {
            salaireNetMensuelApresImpotsCtl.text = salaireNetMensuelApresImpots.toStringAsFixed(2);
          }

          if (_nombreMoisPrime != null) {
            salaireBrutAnnuel = salaireBrutMensuel * _nombreMoisPrime!;
            salaireNetAnnuel = salaireNetMensuel * _nombreMoisPrime!;
            salaireNetAnnuelApresImpots = salaireNetMensuelApresImpots * _nombreMoisPrime!;
          } else {
            salaireBrutAnnuel = salaireBrutMensuel * 12;
            salaireNetAnnuel = salaireNetMensuel * 12;
            salaireNetAnnuelApresImpots = salaireNetMensuelApresImpots * 12;
          }
          if(typeChamp != 'salaireBrutAnnuel') {
            salaireBrutAnnuelCtl.text = salaireBrutAnnuel.toStringAsFixed(2);
          }
          if(typeChamp != 'salaireNetAnnuel') {
            salaireNetAnnuelCtl.text = salaireNetAnnuel.toStringAsFixed(2);
          }
          if(typeChamp != 'salaireNetAnnuelApresImpots') {
            salaireNetAnnuelApresImpotsCtl.text = salaireNetAnnuelApresImpots.toStringAsFixed(2);
          }

        if(typeChamp == 'salaireNetHoraire' || typeChamp == 'salaireNetMensuel' || typeChamp == 'statut12mois') {
          if (_nombreMoisPrime != null) {
            salaireNetAnnuel = salaireNetMensuel * _nombreMoisPrime!;
          }
          else {
            salaireNetAnnuel = salaireNetMensuel * 12;
          }
          salaireNetAnnuelCtl.text = salaireNetAnnuel.toStringAsFixed(2);
        }

        if(typeChamp == 'salaireBrutHoraire' || typeChamp == 'salaireBrutMensuel') {
          if (_nombreMoisPrime != null) {
            salaireBrutAnnuel = salaireBrutMensuel * _nombreMoisPrime!;
          }
          else {
            salaireBrutAnnuel = salaireBrutMensuel * 12;
          }
        }
        }
        }
    );
  }

  void resetFormulaire() {
    salaireNetHoraireCtl.clear();
    salaireBrutHoraireCtl.clear();
    salaireNetMensuelCtl.clear();
    salaireBrutMensuelCtl.clear();
    salaireNetMensuelApresImpotsCtl.clear();
    salaireNetAnnuelCtl.clear();
    salaireBrutAnnuelCtl.clear();
    salaireNetAnnuelApresImpotsCtl.clear();
  }


}
