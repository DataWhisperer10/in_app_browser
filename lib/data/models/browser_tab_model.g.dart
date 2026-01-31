// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'browser_tab_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BrowserTabModelAdapter extends TypeAdapter<BrowserTabModel> {
  @override
  final int typeId = 0;

  @override
  BrowserTabModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BrowserTabModel(
      id: fields[0] as String,
      url: fields[1] as String,
      title: fields[2] as String,
      favicon: fields[3] as String?,
      createdAt: fields[4] as DateTime,
      lastVisited: fields[5] as DateTime,
      cachedContent: fields[6] as String?,
      isIncognito: fields[7] as bool? ?? false,
    );
  }

  @override
  void write(BinaryWriter writer, BrowserTabModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.favicon)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.lastVisited)
      ..writeByte(6)
      ..write(obj.cachedContent)
      ..writeByte(7)
      ..write(obj.isIncognito);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrowserTabModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
