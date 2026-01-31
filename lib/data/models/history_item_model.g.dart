// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HistoryItemModelAdapter extends TypeAdapter<HistoryItemModel> {
  @override
  final int typeId = 4;

  @override
  HistoryItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HistoryItemModel(
      id: fields[0] as String,
      url: fields[1] as String,
      title: fields[2] as String,
      favicon: fields[3] as String?,
      visitedAt: fields[4] as DateTime,
      type: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HistoryItemModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.favicon)
      ..writeByte(4)
      ..write(obj.visitedAt)
      ..writeByte(5)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoryItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
