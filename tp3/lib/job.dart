import 'dart:io';
import 'package:hive/hive.dart';
part 'job.g.dart';

// La classe job avec ses différents membres
@HiveType(typeId: 1)
class Job {
  Job(this.entreprise, this.salaireBrutAnnuel, this.choixStatut, this.salaireNetMensuel, this.sentiment);

  @HiveField(0)
  final String entreprise;

  @HiveField(1)
  final double salaireBrutAnnuel;

  @HiveField(2)
  final String choixStatut;

  @HiveField(3)
  final double salaireNetMensuel;

  @HiveField(4)
  final String sentiment;

  // Servira à afficher la description du job
  @override
  String toString() {
    String choixStatutNom = '';

    // Traduction du statut
    if(this.choixStatut == 'Statut.noncadre') {
      choixStatutNom = 'Non cadre';
    }
    else {
      choixStatutNom = 'Cadre';
    }
    return 'Entreprise : $entreprise \n'
            'Salaire Brut Annuel : $salaireBrutAnnuel euros \nSalaire Net Mensuel : $salaireNetMensuel euros\n'
            'Statut : $choixStatutNom \n'
    'Mon avis : $sentiment';
    }
}