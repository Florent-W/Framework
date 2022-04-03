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
      fields[0] as String,
      fields[1] as double,
      fields[2] as String,
      fields[3] as double,
      fields[4] as String,
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
