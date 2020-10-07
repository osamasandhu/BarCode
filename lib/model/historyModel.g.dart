// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'historyModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HistoryModelAdapter extends TypeAdapter<HistoryModel> {
  @override
  final int typeId = 0;

  @override
  HistoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HistoryModel(
      format: fields[2] as String,
      rawContent: fields[1] as String,
      resultType: fields[0] as String,
      isFavorite: fields[4] as bool,
      id: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HistoryModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.resultType)
      ..writeByte(1)
      ..write(obj.rawContent)
      ..writeByte(2)
      ..write(obj.format)
      ..writeByte(3)
      ..write(obj.id)
      ..writeByte(4)
      ..write(obj.isFavorite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
