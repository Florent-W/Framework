import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class AppThemes {
  static const int bleu = 0;
  static const int rouge = 1;
  static const int vert = 2;
  static const int orange = 3;
  static const int gris = 4;
}

final themeCollection = ThemeCollection(
  themes: {
    AppThemes.bleu: ThemeData(primarySwatch: Colors.blue),
    AppThemes.rouge: ThemeData(primarySwatch: Colors.red),
    AppThemes.vert: ThemeData(primarySwatch: Colors.green),
    AppThemes.orange: ThemeData(primarySwatch: Colors.orange),
    AppThemes.gris: ThemeData(primarySwatch: Colors.grey),
  },
  fallbackTheme: ThemeData.light(),
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
        themeCollection: themeCollection,
        defaultThemeId: AppThemes.bleu,
        builder: (context, theme) {
          return MaterialApp(
            title: 'Calculateur de salaire',
            theme: theme,
            home: const MyHomePage(title: 'Calculateur de salaire'),
          );
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum Statut { cadre, noncadre, publique, liberale, portage }

class _MyHomePageState extends State<MyHomePage> {
  Statut? _statut = Statut.cadre; // Statut professionnel
  int? _nombreMoisPrime = 12;
  double _currentSliderValue = 100; // Temps de travail
  double _sliderSourceValue = 0; // Pourcentage prelevement à la source
  String statutText = 'Cadre - 25%';
  double pourcentageSalaireMedian = 0;
  double pourcentageSalaireMoyen = 0;

  String valeurSelectTheme = 'Bleu / Orange';
  MaterialColor couleurSelection = Colors.blue;
  Color couleurSelectionBackground = Colors.deepOrangeAccent;

  // Les controlleurs permettant de définir les textes et de les changer
  TextEditingController salaireNetHoraireCtl = TextEditingController();
  TextEditingController salaireBrutHoraireCtl = TextEditingController();

  TextEditingController salaireNetMensuelCtl = TextEditingController();
  TextEditingController salaireBrutMensuelCtl = TextEditingController();

  TextEditingController salaireNetAnnuelCtl = TextEditingController();
  TextEditingController salaireBrutAnnuelCtl = TextEditingController();

  TextEditingController salaireNetMensuelApresImpotsCtl =
      TextEditingController();
  TextEditingController salaireNetAnnuelApresImpotsCtl =
      TextEditingController();

  TextEditingController tempsTravailCtl = TextEditingController();
  TextEditingController prelevementSourceCtl = TextEditingController();

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
        backgroundColor: couleurSelectionBackground,
        body: Center(
            child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.8,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 7),
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.white),
                child:
                    // Center is a layout widget. It takes a single child and positions it
                    // in the middle of the parent.
                    SingleChildScrollView(
                        child: CupertinoScrollbar(
                  child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Form(
                        key: _formKey,
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const Text('Calculateur de Salaire',
                                style: TextStyle(
                                    fontSize: 31, fontWeight: FontWeight.bold)),
                            Row(children: const [
                              Text('VOTRE SALAIRE BRUT :',
                                  style: TextStyle(fontWeight: FontWeight.bold))
                            ]),
                            const SizedBox(height: 20),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                // Rangée du salaire brut
                                children: [
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: TextFormField(
                                          decoration: InputDecoration(
                                            prefixIcon:
                                                const Icon(Icons.euro_outlined),
                                            labelText: 'Horaire brut',
                                            hintText: 'Ex : 19.23',
                                            border: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.blue,
                                                  width: 2.0),
                                              borderRadius:
                                                  BorderRadius.circular(25.0),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.red),
                                              borderRadius:
                                                  BorderRadius.circular(25.0),
                                            ),
                                          ),
                                          controller: salaireBrutHoraireCtl,
                                          // Un nombre est demandé, on accepte seulement donc ce type de caractère
                                          keyboardType: const TextInputType
                                              .numberWithOptions(decimal: true),
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'^\d+\.?\d{0,2}')),
                                          ],
                                          onChanged: (Text) =>
                                              salaireHoraireNetEnBrutUpdate(
                                                  salaireBrutHoraireCtl,
                                                  'salaireBrutHoraire'),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Ce champ est vide, veuillez le compléter';
                                            }
                                          })),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          prefixIcon:
                                              const Icon(Icons.euro_outlined),
                                          labelText: 'Mensuel brut',
                                          hintText: 'Ex : 2916.73',
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.blue, width: 2.0),
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.red),
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ),
                                        ),
                                        onChanged: (Text) =>
                                            salaireHoraireNetEnBrutUpdate(
                                                salaireBrutMensuelCtl,
                                                'salaireBrutMensuel'),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Ce champ est vide, veuillez le compléter';
                                          }
                                        },
                                        controller: salaireBrutMensuelCtl,
                                        // Un nombre est demandé, on accepte seulement donc ce type de caractère
                                        keyboardType: const TextInputType
                                            .numberWithOptions(decimal: true),
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'^\d+\.?\d{0,2}')),
                                        ],
                                      )),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: TextFormField(
                                          decoration: InputDecoration(
                                            prefixIcon:
                                                Icon(Icons.euro_outlined),
                                            labelText: 'Annuel brut',
                                            hintText: '35000.77',
                                            border: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.blue,
                                                  width: 2.0),
                                              borderRadius:
                                                  BorderRadius.circular(25.0),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.red),
                                              borderRadius:
                                                  BorderRadius.circular(25.0),
                                            ),
                                          ),
                                          controller: salaireBrutAnnuelCtl,
                                          // Un nombre est demandé, on accepte seulement donc ce type de caractère
                                          keyboardType: const TextInputType
                                              .numberWithOptions(decimal: true),
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'^\d+\.?\d{0,2}')),
                                          ],
                                          onChanged: (Text) =>
                                              salaireHoraireNetEnBrutUpdate(
                                                  salaireBrutAnnuelCtl,
                                                  'salaireBrutAnnuel'),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Ce champ est vide, veuillez le compléter';
                                            }
                                          }))
                                ]),
                            const SizedBox(height: 20),
                            Row(
                              children: const [
                                Text('VOTRE SALAIRE NET :',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold))
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: TextFormField(
                                          decoration: InputDecoration(
                                            prefixIcon:
                                                const Icon(Icons.euro_outlined),
                                            labelText: 'Horaire net',
                                            hintText: 'Ex : 15',
                                            border: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.blue,
                                                  width: 2.0),
                                              borderRadius:
                                                  BorderRadius.circular(25.0),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.red),
                                              borderRadius:
                                                  BorderRadius.circular(25.0),
                                            ),
                                          ),
                                          controller: salaireNetHoraireCtl,
                                          // Un nombre est demandé, on accepte seulement donc ce type de caractère
                                          keyboardType: const TextInputType
                                              .numberWithOptions(decimal: true),
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'^\d+\.?\d{0,2}')),
                                          ],
                                          onChanged: (Text) =>
                                              salaireHoraireNetEnBrutUpdate(
                                                  salaireNetHoraireCtl,
                                                  'salaireNetHoraire'),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Ce champ est vide, veuillez le compléter';
                                            }
                                          })),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: TextFormField(
                                          decoration: InputDecoration(
                                            prefixIcon:
                                                Icon(Icons.euro_outlined),
                                            labelText: 'Mensuel net',
                                            hintText: 'Ex : 2275.05',
                                            border: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.blue,
                                                  width: 2.0),
                                              borderRadius:
                                                  BorderRadius.circular(25.0),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.red),
                                              borderRadius:
                                                  BorderRadius.circular(25.0),
                                            ),
                                          ),
                                          controller: salaireNetMensuelCtl,
                                          // Un nombre est demandé, on accepte seulement donc ce type de caractère
                                          keyboardType: const TextInputType
                                              .numberWithOptions(decimal: true),
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'^\d+\.?\d{0,2}')),
                                          ],
                                          onChanged: (Text) =>
                                              salaireHoraireNetEnBrutUpdate(
                                                  salaireNetMensuelCtl,
                                                  'salaireNetMensuel'),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Ce champ est vide, veuillez le compléter';
                                            }
                                          })),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.euro_outlined),
                                          labelText: 'Annuel net',
                                          hintText: 'Ex : 27300.60',
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.blue, width: 2.0),
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.red),
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ),
                                        ),
                                        controller: salaireNetAnnuelCtl,
                                        // Un nombre est demandé, on accepte seulement donc ce type de caractère
                                        keyboardType: const TextInputType
                                            .numberWithOptions(decimal: true),
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'^\d+\.?\d{0,2}')),
                                        ],
                                        onChanged: (Text) =>
                                            salaireHoraireNetEnBrutUpdate(
                                                salaireNetAnnuelCtl,
                                                'salaireNetAnnuel'),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Ce champ est vide, veuillez le compléter';
                                          }
                                        },
                                      ))
                                ]),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03),
                            Row(
                              children: const [
                                Text('SELECTIONNEZ VOTRE TEMPS DE TRAVAIL :',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold))
                              ],
                            ),
                            Row(
                              children: [
                                Slider(
                                  value: _currentSliderValue,
                                  max: 100,
                                  divisions: 5,
                                  label: _currentSliderValue.round().toString(),
                                  onChanged: (double value) {
                                    setState(() {
                                      _currentSliderValue = value;
                                      salaireHoraireNetEnBrutUpdate(
                                          salaireNetHoraireCtl, 'slider');
                                    });
                                  },
                                ),
                                Text('$_currentSliderValue %')
                              ],
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03),
                            Row(children: const [
                              Text(
                                  'SELECTIONNEZ LE NOMBRE DE MOIS DE PRIME CONVENTIONNELLE :',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ]),
                            Row(children: [
                              Flexible(
                                  child: ListTile(
                                      title: const Text('12 mois'),
                                      leading: Radio<int>(
                                        value: 12,
                                        groupValue: _nombreMoisPrime,
                                        onChanged: (int? value) {
                                          // Mise à jour du salaire
                                          setState(() {
                                            _nombreMoisPrime = value;
                                            salaireHoraireNetEnBrutUpdate(
                                                salaireNetHoraireCtl, 'mois');
                                          });
                                        },
                                      ))),
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
                                            salaireHoraireNetEnBrutUpdate(
                                                salaireNetHoraireCtl, 'mois');
                                          });
                                        },
                                      ))),
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
                                            salaireHoraireNetEnBrutUpdate(
                                                salaireNetHoraireCtl, 'mois');
                                          });
                                        },
                                      ))),
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
                                            salaireHoraireNetEnBrutUpdate(
                                                salaireNetHoraireCtl, 'mois');
                                          });
                                        },
                                      ))),
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
                                            salaireHoraireNetEnBrutUpdate(
                                                salaireNetHoraireCtl, 'mois');
                                          });
                                        },
                                      )))
                            ]),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03),
                            Row(
                              children: [
                                Text('SELECTIONNEZ VOTRE STATUT : $statutText',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Flexible(
                                    child: ListTile(
                                        title: const Text('Non cadre - 22%'),
                                        leading: Radio<Statut>(
                                          value: Statut.noncadre,
                                          groupValue: _statut,
                                          onChanged: (Statut? value) {
                                            // Mise à jour du statut et du salaire
                                            setState(() {
                                              _statut = value;
                                              salaireHoraireNetEnBrutUpdate(
                                                  salaireNetHoraireCtl,
                                                  'statut');
                                              statutText = 'Non cadre - 22%';
                                            });
                                          },
                                        ))),
                                Flexible(
                                    child: ListTile(
                                        title: const Text('Cadre - 25%'),
                                        leading: Radio<Statut>(
                                          value: Statut.cadre,
                                          groupValue: _statut,
                                          onChanged: (Statut? value) {
                                            // Mise à jour du statut et du salaire
                                            setState(() {
                                              _statut = value;
                                              salaireHoraireNetEnBrutUpdate(
                                                  salaireNetHoraireCtl,
                                                  'statut');
                                              statutText = 'Cadre - 25%';
                                            });
                                          },
                                        ))),
                                Flexible(
                                    child: ListTile(
                                        title: const Text(
                                            'Fonction publique - 15%'),
                                        leading: Radio<Statut>(
                                          value: Statut.publique,
                                          groupValue: _statut,
                                          onChanged: (Statut? value) {
                                            // Mise à jour du statut et du salaire
                                            setState(() {
                                              _statut = value;
                                              salaireHoraireNetEnBrutUpdate(
                                                  salaireNetHoraireCtl,
                                                  'statut');
                                              statutText =
                                                  'Fonction publique - 15%';
                                            });
                                          },
                                        ))),
                                Flexible(
                                    child: ListTile(
                                        title: const Text(
                                            'Profession libérale - 45%'),
                                        leading: Radio<Statut>(
                                          value: Statut.liberale,
                                          groupValue: _statut,
                                          onChanged: (Statut? value) {
                                            // Mise à jour du statut et du salaire
                                            setState(() {
                                              _statut = value;
                                              salaireHoraireNetEnBrutUpdate(
                                                  salaireNetHoraireCtl,
                                                  'statut');
                                              statutText =
                                                  'Profession libérale - 45%';
                                            });
                                          },
                                        ))),
                                Flexible(
                                    child: ListTile(
                                        title: const Text(
                                            'Portage salarial - 51%'),
                                        leading: Radio<Statut>(
                                          value: Statut.portage,
                                          groupValue: _statut,
                                          onChanged: (Statut? value) {
                                            // Mise à jour du statut et du salaire
                                            setState(() {
                                              _statut = value;
                                              salaireHoraireNetEnBrutUpdate(
                                                  salaireNetHoraireCtl,
                                                  'statut');
                                              statutText =
                                                  'Portage salarial - 51%';
                                            });
                                          },
                                        ))),
                              ],
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03),
                            Row(children: const [
                              Text(
                                  'ESTIMATION DE VOTRE SALAIRE NET APRES LE PRELEVEMENT A LA SOURCE :',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ]),
                            Row(
                              children: [
                                Slider(
                                  value: _sliderSourceValue,
                                  min: 0,
                                  max: 43,
                                  divisions: 5,
                                  label: _sliderSourceValue.round().toString(),
                                  onChanged: (double value) {
                                    setState(() {
                                      _sliderSourceValue = value;
                                      salaireHoraireNetEnBrutUpdate(
                                          salaireNetHoraireCtl, 'slider');
                                    });
                                  },
                                ),
                                Text('$_sliderSourceValue %')
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    child: TextFormField(
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.euro_outlined),
                                          labelText: 'Mensuel net après impôts',
                                          hintText: 'Ex : 2275.05',
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.blue, width: 2.0),
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.red),
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ),
                                        ),
                                        controller:
                                            salaireNetMensuelApresImpotsCtl,
                                        // Un nombre est demandé, on accepte seulement donc ce type de caractère
                                        keyboardType: const TextInputType
                                            .numberWithOptions(decimal: true),
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'^\d+\.?\d{0,2}')),
                                        ],
                                        onChanged: (Text) =>
                                            salaireHoraireNetEnBrutUpdate(
                                                salaireNetMensuelApresImpotsCtl,
                                                'salaireNetMensuelApresImpots'),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Ce champ est vide, veuillez le compléter';
                                          }
                                        })),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.01),
                                SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    child: TextFormField(
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.euro_outlined),
                                          labelText: 'Annuel net après impôts',
                                          hintText: 'Ex : 27300.60',
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.blue, width: 2.0),
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.red),
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ),
                                        ),
                                        controller:
                                            salaireNetAnnuelApresImpotsCtl,
                                        // Un nombre est demandé, on accepte seulement donc ce type de caractère
                                        keyboardType: const TextInputType
                                            .numberWithOptions(decimal: true),
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'^\d+\.?\d{0,2}')),
                                        ],
                                        onChanged: (Text) =>
                                            salaireHoraireNetEnBrutUpdate(
                                                salaireNetAnnuelApresImpotsCtl,
                                                'salaireNetAnnuelApresImpots'),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Ce champ est vide, veuillez le compléter';
                                          }
                                        }))
                              ],
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.17,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      child: OutlinedButton(
                                          onPressed: () {
                                            clearFormulaire();
                                          },
                                          style: OutlinedButton.styleFrom(
                                            primary: Colors.white,
                                            backgroundColor: Colors.red,
                                            side: const BorderSide(
                                                width: 1.1,
                                                color: Colors.black),
                                          ),
                                          child: const Text(
                                              'Effacer les Champs'))),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.3),
                                  const Text('Thème :',
                                      style: TextStyle(fontSize: 17)),
                                  DropdownButton<String>(
                                    value: valeurSelectTheme,
                                    items: <String>[
                                      'Bleu / Orange',
                                      'Rouge / Vert',
                                      'Vert / Bleu',
                                      'Orange / Jaune',
                                      'Gris'
                                    ].map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (String? nouvelleValeur) {
                                      setState(() {
                                        valeurSelectTheme = nouvelleValeur!;
                                      });
                                      // Selection des couleurs
                                      switch (nouvelleValeur) {
                                        case 'Bleu / Orange':
                                          DynamicTheme.of(context)
                                              ?.setTheme(AppThemes.bleu);
                                          couleurSelection = Colors.blue;
                                          couleurSelectionBackground =
                                              Colors.deepOrangeAccent;
                                          break;
                                        case 'Rouge / Vert':
                                          DynamicTheme.of(context)
                                              ?.setTheme(AppThemes.rouge);
                                          couleurSelection = Colors.red;
                                          couleurSelectionBackground =
                                              Colors.green;
                                          break;
                                        case 'Vert / Bleu':
                                          DynamicTheme.of(context)
                                              ?.setTheme(AppThemes.vert);
                                          couleurSelection = Colors.green;
                                          couleurSelectionBackground =
                                              Colors.blue;
                                          break;
                                        case 'Orange / Jaune':
                                          DynamicTheme.of(context)
                                              ?.setTheme(AppThemes.orange);
                                          couleurSelection = Colors.orange;
                                          couleurSelectionBackground =
                                              Colors.yellow;
                                          break;
                                        case 'Gris':
                                          DynamicTheme.of(context)
                                              ?.setTheme(AppThemes.gris);
                                          couleurSelection = Colors.grey;
                                          couleurSelectionBackground =
                                              Colors.grey;
                                          break;
                                      }
                                    },
                                  )
                                ]),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03),
                            // Affichage du salaire median et moyen, pour le voir, il faut scroller
                            Row(
                              children: [
                                Text(
                                  'Votre salaire correspond à $pourcentageSalaireMedian % du salaire médian et à $pourcentageSalaireMoyen % du salaire moyen en France.',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic),
                                )
                              ],
                            ),
                          ],
                        ),
                      )),
                )))));
  }

  // Mise à jour du salaire
  void salaireHoraireNetEnBrutUpdate(
      TextEditingController champModifier, String typeChamp) {
    setState(() {
      // On regarde tout d'abord si le salaire mensuel n'est pas vide
      if (champModifier.text != '') {
        /*
         Initialisation de toutes les variables
         */
        double salaire = double.parse(champModifier
            .text); // Valeur de départ pris à partir du champ sur lequel l'utilisateur écrit
        double salaireNet = -1;
        double salaireNetMensuel = 0;
        double salaireNetAnnuel = 0;
        double salaireNetMensuelApresImpots = 0;
        double salaireNetAnnuelApresImpots = 0;

        double salaireBrut = -1;
        double salaireBrutMensuel = 0;
        double salaireBrutAnnuel = 0;

        double salaireMedian = 1940;
        double salaireMoyenne = 2424; // INSEE 2019

        // Si le salaire pris est en net (servira à calculer le salaire brut)
        if (typeChamp == 'salaireNetHoraire' ||
            typeChamp == 'salaireNetMensuel' ||
            typeChamp == 'salaireNetAnnuel' ||
            typeChamp == 'salaireNetMensuelApresImpots' ||
            typeChamp == 'salaireNetAnnuelApresImpots') {
          if (typeChamp == 'salaireNetHoraire') {
            salaireNet = salaire; // Salaire horaire net
          } else if (typeChamp == 'salaireNetMensuel') {
            salaireNet = salaire /
                151.67; // Passage du salaire mensuel net à net horaire
            salaireNetHoraireCtl.text = salaireNet.toStringAsFixed(2);
          } else if (typeChamp == 'salaireNetAnnuel') {
            salaireNet = (salaire / 12) /
                151.67; // Passage du salaire annuel net à net horaire
            salaireNetHoraireCtl.text = salaireNet.toStringAsFixed(2);
          } else if (typeChamp == 'salaireNetMensuelApresImpots') {
            double pourcentage = (100 - _sliderSourceValue) /
                100; // Passage du salaire net mensuel apres impot à salaire net horaire
            salaireNet = (salaire / pourcentage) /
                151.67; // On calcule le pourcentage puis on divise le salaire net mensuel apres impots par le pourcentage trouvé
            salaireNetHoraireCtl.text = salaireNet.toStringAsFixed(2);
          } else if (typeChamp == 'salaireNetAnnuelApresImpots') {
            double pourcentage = (100 - _sliderSourceValue) /
                100; // Pareil pour le salaire net annuel apres impots
            salaireNet = ((salaire / pourcentage) / 12) / 151.67;
            salaireNetHoraireCtl.text = salaireNet.toStringAsFixed(2);
          }

          // La différence entre le brut et le net se fait selon le statut, avec cela, on retrouve le salaire brut
          switch (_statut) {
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
        // Pour le salaire brut ou quand on change le statut, servira aussi à calculer le salaire net
        else if (typeChamp == 'salaireBrutHoraire' ||
            typeChamp == 'salaireBrutMensuel' ||
            typeChamp == 'salaireBrutAnnuel' ||
            typeChamp == 'statut') {
          if (typeChamp == 'salaireBrutHoraire') {
            salaireBrut = salaire;
          } else if (typeChamp == "statut") {
            // Quand on change de statut, on se base directement sur le nombre entré pour le salaire brut horaire
            salaireBrut = double.parse(salaireBrutHoraireCtl.text);
          } else if (typeChamp == 'salaireBrutMensuel') {
            salaireBrut = salaire / 151.67;
            salaireBrutHoraireCtl.text = salaireBrut.toStringAsFixed(2);
          } else if (typeChamp == 'salaireBrutAnnuel') {
            salaireBrut = (salaire / 12) / 151.67;
            salaireBrutHoraireCtl.text = salaireBrut.toStringAsFixed(2);
          }

          // Selon le statut, on repasse du salaire brut horaire au salaire net horaire, il y a un pourcentage
          switch (_statut) {
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

        // Pour les calculs suivants, on vérifie si les salaires net horaires et brut sont initialisés
        if (salaireNet == -1 && salaireNetHoraireCtl.text != '') {
          salaireNet = double.parse(salaireNetHoraireCtl.text);
        }
        if (salaireBrut == -1 && salaireBrutHoraireCtl.text != '') {
          salaireBrut = double.parse(salaireBrutHoraireCtl.text);
        }

        // Calcul du salaire horaire à mensuel
        salaireNetMensuel = salaireNet * 151.67;
        salaireBrutMensuel = salaireBrut * 151.67;

        // Calcul du salaire mensuel par rapport au temps travaillé
        if (_currentSliderValue != null) {
          salaireNetMensuel = salaireNetMensuel * (_currentSliderValue / 100);
          salaireBrutMensuel = salaireBrutMensuel * (_currentSliderValue / 100);
        }

        if (typeChamp != 'salaireNetMensuel') {
          salaireNetMensuelCtl.text = salaireNetMensuel.toStringAsFixed(2);
        }
        if (typeChamp != 'salaireBrutMensuel') {
          salaireBrutMensuelCtl.text = salaireBrutMensuel.toStringAsFixed(2);
        }

        // Calcul du salaire net mensuel apres impots (défini par le slider du prélèvement à la source
        if (_sliderSourceValue != null) {
          salaireNetMensuelApresImpots = salaireNetMensuel -
              (salaireNetMensuel * (_sliderSourceValue / 100));
        } else {
          salaireNetMensuelApresImpots = salaireNetMensuel;
        }

        if (typeChamp != 'salaireNetMensuelApresImpots') {
          salaireNetMensuelApresImpotsCtl.text =
              salaireNetMensuelApresImpots.toStringAsFixed(2);
        }

        // Calcul du salaire annuel avec le nombre de mois de prime conventionnelle, on calcule le salaire mensuel par le nombre de mois indiqué
        if (_nombreMoisPrime != null) {
          salaireBrutAnnuel = salaireBrutMensuel * _nombreMoisPrime!;
          salaireNetAnnuel = salaireNetMensuel * _nombreMoisPrime!;
          salaireNetAnnuelApresImpots =
              salaireNetMensuelApresImpots * _nombreMoisPrime!;
        } else {
          salaireBrutAnnuel = salaireBrutMensuel * 12;
          salaireNetAnnuel = salaireNetMensuel * 12;
          salaireNetAnnuelApresImpots = salaireNetMensuelApresImpots * 12;
        }
        if (typeChamp != 'salaireBrutAnnuel') {
          salaireBrutAnnuelCtl.text = salaireBrutAnnuel.toStringAsFixed(2);
        }
        if (typeChamp != 'salaireNetAnnuel') {
          salaireNetAnnuelCtl.text = salaireNetAnnuel.toStringAsFixed(2);
        }
        if (typeChamp != 'salaireNetAnnuelApresImpots') {
          salaireNetAnnuelApresImpotsCtl.text =
              salaireNetAnnuelApresImpots.toStringAsFixed(2);
        }

        pourcentageSalaireMedian =
            ((salaireNetMensuel * 100) / salaireMedian).roundToDouble();
        pourcentageSalaireMoyen =
            ((salaireNetMensuel * 100) / salaireMoyenne).roundToDouble();
      }
    });
  }

  // Reset de tous les champs
  void clearFormulaire() {
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
