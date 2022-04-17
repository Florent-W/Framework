/* Import des packages */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart';
import 'job.dart';

void main() async {
  // Initialisation de Hive pour la bdd local (box)
  await Hive.initFlutter();
  // Enregistrement de l'adaptateur pour avoir la classe Job
  Hive.registerAdapter(JobAdapter());
  // Si la box n'est pas ouvert, on l'ouvre
  if (Hive.isBoxOpen('jobBox') == false) {
    await Hive.openBox<Job>('jobBox');
  }
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
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Suivi de jobs'),
    );
  }
}

/* Page d'accueil de l'application */
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Job> listJob = [];

  // Méthode qui va récupérer les jobs présent dans la box de l  base de données de hive
  void getJobs() async {
    // Si la box n'est pas ouvert, on l'ouvre
    if (Hive.isBoxOpen('jobBox') == false) {
      await Hive.openBox<Job>('jobBox');
    }

    Box<Job> box = Hive.box("jobBox");
    // Les jobs récupérés sont mis dans une liste pour être utilisé plus tard
    listJob = box.values.toList();
  }

  // Lors de l'initialisation, on appelle la méthode
  void initState() {
    getJobs();
  }

  // Méthode pour supprimer un job de la box avec en paramètre l'id correspondant à sa place dans la box
  void supprimerJob(int id) {
    var box = Hive.box<Job>('jobBox');

    box.deleteAt(id);

    // Affichage d'un message pour dire que le job est supprimé
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Suppression du job terminé')));

    getJobs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        // Une couleur de fond pour la page
        backgroundColor: Colors.grey,
        body: Center(
            // Wrap dans un container pour avoir une zone bien visible ou il y aura la liste des jobs
            child: Container(
                width: 800,
                height: 600,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent, width: 3),
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.white),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Text(
                            'Mon Suivi de Jobs',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 32),
                          ),
                        ],
                      ),
                      Container(
                          child: Expanded(
                              // Ici, il y aura une listview contenant les propostions de jobs enregistré, j'ai laissé la scrollbar activée
                              child: CupertinoScrollbar(
                                  isAlwaysShown: true,
                                  child: ListView.builder(
                                    padding: const EdgeInsets.all(32),
                                    itemCount: listJob.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black,
                                                      width: 1.5),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  color: Colors.white),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20),
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      // Affichage du contenu du job
                                                      Expanded(child: Text('${listJob[index]}',
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      20))),
                                                      // Un bouton pour supprimer le job dans hive
                                                      FloatingActionButton
                                                          .extended(
                                                        tooltip:
                                                            'Supprimer la proposition',
                                                        onPressed: () {
                                                          supprimerJob(index);
                                                          // Après la suppression, on rafraichit la page
                                                          Navigator.pushReplacement(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      super
                                                                          .widget));
                                                        },
                                                        backgroundColor:
                                                            Colors.red,
                                                        heroTag:
                                                            "boutonSupprimerJob" +
                                                                index
                                                                    .toString(),
                                                        icon: const Icon(
                                                            Icons.remove),
                                                        label: const Text(
                                                            'Supprimer'),
                                                      )
                                                    ]),
                                              )));
                                    },
                                  )))),
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        Padding(
                            padding:
                                const EdgeInsets.only(bottom: 50.0, right: 40),
                            // Un bouton pour ajouter un job en bas de la page
                            child: FloatingActionButton.extended(
                              tooltip: 'Ajouter une nouvelle proposition',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SecondScreen()),
                                );
                              },
                              backgroundColor: Colors.blue,
                              heroTag: "boutonAjouterJob",
                              // Les heros tags servent à déterminer l'id des boutons
                              icon: const Icon(Icons.add),
                              label: const Text(
                                  'Ajouter une nouvelle proposition'),
                            ))
                      ])
                    ]))));
  }
}

enum Statut { cadre, noncadre }

// L'écran du menu d'ajout de job
class SecondScreen extends StatefulWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  State<SecondScreen> createState() => SecondScreenState();
}

class SecondScreenState extends State<SecondScreen> {
  Statut? _statut = Statut.cadre;

  // Les controlleurs permettant de définir les textes et de les changer
  TextEditingController entrepriseCtl = TextEditingController();
  TextEditingController salaireNetMensuelCtl = TextEditingController();
  TextEditingController salaireNetAnnuelCtl = TextEditingController();
  TextEditingController sentimentCtl = TextEditingController();

  // On créé une clé pour le formulaire, à l'aide de celle-ci, les champs pourront être vérifiés
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext ctxt) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Nouvelle proposition"),
        ),
        backgroundColor: Colors.grey,
        body: Form(
          key: _formKey,
          child: Center(
              child: Container(
            width: 500,
            height: 600,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent, width: 3),
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                const Text('Nouvelle proposition',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 32)),
                Row(
                  children: <Widget>[
                    IconButton(
                        icon: const Icon(Icons.business_outlined),
                        tooltip: 'Entreprise',
                        onPressed: () {}),
                    Flexible(
                        // Un des champs du formulaire, si il est null au moment de la validation, son contour devient rouge et un message s'affiche
                        child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Entreprise',
                              hintText: 'IUT Orsay',
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ce champ est vide, veuillez le compléter';
                              }
                            },
                            controller: entrepriseCtl,
                            onTap: () {})),
                    const SizedBox(width: 10)
                  ],
                ),
                Row(children: <Widget>[
                  IconButton(
                      icon: const Icon(Icons.euro_rounded),
                      tooltip: 'Salaire brut annuel',
                      onPressed: () {}),
                  Flexible(
                      child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Salaire brut annuel (en euros)',
                            hintText: '35000',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.blue, width: 2.0),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                          controller: salaireNetAnnuelCtl,
                          // Un nombre est demandé, on accepte seulement donc ce type de caractère
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}')),
                          ],
                          // Mise à jour du salaire mensuel si changement du salaire annuel
                          onChanged: (Text) => salaireNetMensuelUpdate(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ce champ est vide, veuillez le compléter';
                            }
                          })),
                  const SizedBox(width: 10)
                ]),
                const Text('Choisissez le Statut',
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                Row(children: <Widget>[
                  // Choix du statut, en sélectionnant un des deux, les deux salaires se mettent à jour selon le statut
                  IconButton(
                      icon: const Icon(Icons.person),
                      tooltip: 'Statut',
                      onPressed: () {}),
                  Flexible(
                      child: ListTile(
                    title: const Text('Cadre (25%)'),
                    leading: Radio<Statut>(
                      value: Statut.cadre,
                      groupValue: _statut,
                      onChanged: (Statut? value) {
                        // Mise à jour du statut et du salaire
                        setState(() {
                          _statut = value;
                          changeSalaireStatut();
                        });
                      },
                    ),
                  )),
                  Flexible(
                      child: ListTile(
                    title: const Text('Non cadre (22%)'),
                    leading: Radio<Statut>(
                      value: Statut.noncadre,
                      groupValue: _statut,
                      onChanged: (Statut? value) {
                        setState(() {
                          _statut = value;
                          changeSalaireStatut();
                        });
                      },
                    ),
                  )),
                  const SizedBox(width: 10)
                ]),
                Row(children: <Widget>[
                  IconButton(
                      icon: const Icon(Icons.euro_rounded),
                      tooltip: 'Salaire net mensuel',
                      onPressed: () {}),
                  Flexible(
                      child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Salaire net mensuel (en euros)',
                            hintText: '2187.50',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.blue, width: 2.0),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                          controller: salaireNetMensuelCtl,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          // On accepte seulement les nombres décimaux
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}')),
                          ],
                          // Changement du salaire annuel si changement du salaire mensuel
                          onChanged: (Text) => salaireAnnuelUpdate(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ce champ est vide, veuillez le compléter';
                            }
                          })),
                  const SizedBox(width: 10)
                ]),
                Row(children: <Widget>[
                  IconButton(
                      icon: const Icon(Icons.star_rounded),
                      tooltip: 'Mon sentiment',
                      onPressed: () {}),
                  Flexible(
                      child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Mon sentiment',
                            hintText: 'Un avis sur l\'entreprise',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.blue, width: 2.0),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                          controller: sentimentCtl,
                          // On accepte plus de texte pour ce champ
                          minLines: 3,
                          maxLines: 5,
                          onTap: () {},
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ce champ est vide, veuillez le compléter';
                            }
                          })),
                  const SizedBox(width: 10)
                ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Flexible(
                          child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: OutlinedButton.styleFrom(
                                primary: Colors.white,
                                backgroundColor: Colors.red,
                              ),
                              // Un bouton pour revenir au menu principal
                              child: const Text('Retour'))),
                      const SizedBox(width: 10),
                      Flexible(
                          child: OutlinedButton(
                              onPressed: () {
                                ajouterJob();
                              },
                              style: OutlinedButton.styleFrom(
                                primary: Colors.white,
                                backgroundColor: Colors.green,
                              ),
                              // Un bouton pour valider et enregistrer le job dans la box si il n'y a pas de problème
                              child: const Text('Valider'))),
                      const SizedBox(width: 5),
                    ])
              ],
            ),
          )),
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

  // Cette méthode s'occupe de changer le salaire selon le statut de la personne quand il y a un changement de statut
  void changeSalaireStatut() {
    setState(() {
      if (salaireNetMensuelCtl.text != '' && salaireNetAnnuelCtl.text != '') {
        double salaireMensuel = double.parse(salaireNetMensuelCtl.text);
        double salaireAnnuel = double.parse(salaireNetAnnuelCtl.text);

        if (_statut == Statut.noncadre) {
          // Calcul du salaire brut en partant du salaire du cadre
          salaireMensuel = (salaireMensuel / (75 / 100));
          // Conversion en salaire net pour le non cadre
          salaireMensuel -= (salaireMensuel * (22 / 100));
        } else {
          salaireMensuel = (salaireMensuel / (78 / 100));
          salaireMensuel -= (salaireMensuel * (25 / 100));
        }

        // Le salaire annuel brut reste le même en changeant de statut

        salaireNetMensuelCtl.text = salaireMensuel.toStringAsFixed(2);
        salaireNetAnnuelCtl.text = salaireAnnuel.toStringAsFixed(2);
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

  // Pour ajouter un job
  void ajouterJob() {
    // On regarde si il n'y a pas d'erreur dans le formulaire
    if (_formKey.currentState!.validate()) {
      var box = Hive.box<Job>('jobBox');

      // Récupération des informations
      var job = Job(
          entrepriseCtl.text,
          double.parse(salaireNetAnnuelCtl.text),
          _statut.toString(),
          double.parse(salaireNetMensuelCtl.text),
          sentimentCtl.text);

      box.add(job);

      // Renvoi au menu avec un remplacement de la page, ce qui va la recharger pour recharger la liste des jobs
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  const MyHomePage(title: 'Liste des propositions')));

      // Message en bas
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Ajout du job terminé')));
    }
  }
}
