import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class Job {
  Job({required entreprise, required salaireBrutAnnuel, required choixStatut, required salaireNetMensuel, required sentiment});

  @HiveField(0)
  String entreprise = "";

  @HiveField(1)
  int salaireBrutAnnuel = 0;

  @HiveField(2)
  String choixStatut = "";

  @HiveField(3)
  int salaireNetMensuel = 0;

  @HiveField(4)
  String sentiment = "";

  @override
  String toString() {
    return '$entreprise $salaireBrutAnnuel $choixStatut $salaireNetMensuel $sentiment';
  }
}