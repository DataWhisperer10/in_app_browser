// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'summary_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SummaryModelAdapter extends TypeAdapter<SummaryModel> {
  @override
  final int typeId = 2;

  @override
  SummaryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SummaryModel(
      id: fields[0] as String,
      sourceUrl: fields[1] as String,
      sourceFilePath: fields[2] as String?,
      originalText: fields[3] as String,
      summarizedText: fields[4] as String,
      originalWordCount: fields[5] as int,
      summarizedWordCount: fields[6] as int,
      createdAt: fields[7] as DateTime,
      type: fields[8] as int,
      translations: (fields[9] as List?)?.cast<TranslationModel>() ?? const [],
    );
  }

  @override
  void write(BinaryWriter writer, SummaryModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.sourceUrl)
      ..writeByte(2)
      ..write(obj.sourceFilePath)
      ..writeByte(3)
      ..write(obj.originalText)
      ..writeByte(4)
      ..write(obj.summarizedText)
      ..writeByte(5)
      ..write(obj.originalWordCount)
      ..writeByte(6)
      ..write(obj.summarizedWordCount)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.type)
      ..writeByte(9)
      ..write(obj.translations);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SummaryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TranslationModelAdapter extends TypeAdapter<TranslationModel> {
  @override
  final int typeId = 3;

  @override
  TranslationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TranslationModel(
      languageCode: fields[0] as String,
      languageName: fields[1] as String,
      translatedText: fields[2] as String,
      createdAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TranslationModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.languageCode)
      ..writeByte(1)
      ..write(obj.languageName)
      ..writeByte(2)
      ..write(obj.translatedText)
      ..writeByte(3)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TranslationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
