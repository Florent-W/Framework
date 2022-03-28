// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JobAdapter extends TypeAdapter<Job> {
  @override
  final int typeId = 1;

  @override
  Job read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Job(
      entreprise: fields[0] as dynamic,
      salaireBrutAnnuel: fields[1] as dynamic,
      choixStatut: fields[2] as dynamic,
      salaireNetMensuel: fields[3] as dynamic,
      sentiment: fields[4] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, Job obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.entreprise)
      ..writeByte(1)
      ..write(obj.salaireBrutAnnuel)
      ..writeByte(2)
      ..write(obj.choixStatut)
      ..writeByte(3)
      ..write(obj.salaireNetMensuel)
      ..writeByte(4)
      ..write(obj.sentiment);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
