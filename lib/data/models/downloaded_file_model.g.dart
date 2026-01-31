// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'downloaded_file_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DownloadedFileModelAdapter extends TypeAdapter<DownloadedFileModel> {
  @override
  final int typeId = 1;

  @override
  DownloadedFileModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DownloadedFileModel(
      id: fields[0] as String,
      name: fields[1] as String,
      path: fields[2] as String,
      extension: fields[3] as String,
      size: fields[4] as int,
      sourceUrl: fields[5] as String,
      downloadedAt: fields[6] as DateTime,
      status: fields[7] as int,
      progress: fields[8] as double? ?? 1.0,
      error: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DownloadedFileModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.path)
      ..writeByte(3)
      ..write(obj.extension)
      ..writeByte(4)
      ..write(obj.size)
      ..writeByte(5)
      ..write(obj.sourceUrl)
      ..writeByte(6)
      ..write(obj.downloadedAt)
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.progress)
      ..writeByte(9)
      ..write(obj.error);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadedFileModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
