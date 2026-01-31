// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppSettingsModelAdapter extends TypeAdapter<AppSettingsModel> {
  @override
  final int typeId = 5;

  @override
  AppSettingsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppSettingsModel(
      isDarkMode: fields[0] as bool? ?? true,
      defaultSearchEngine: fields[1] as String? ?? 'https://www.google.com/search?q=',
      defaultLanguage: fields[2] as String? ?? 'en',
      saveHistory: fields[3] as bool? ?? true,
      enableJavascript: fields[4] as bool? ?? true,
      blockPopups: fields[5] as bool? ?? true,
      summaryLength: fields[6] as int? ?? 150,
      autoSummarize: fields[7] as bool? ?? false,
      enableOfflineMode: fields[8] as bool? ?? true,
      lastTabId: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AppSettingsModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.isDarkMode)
      ..writeByte(1)
      ..write(obj.defaultSearchEngine)
      ..writeByte(2)
      ..write(obj.defaultLanguage)
      ..writeByte(3)
      ..write(obj.saveHistory)
      ..writeByte(4)
      ..write(obj.enableJavascript)
      ..writeByte(5)
      ..write(obj.blockPopups)
      ..writeByte(6)
      ..write(obj.summaryLength)
      ..writeByte(7)
      ..write(obj.autoSummarize)
      ..writeByte(8)
      ..write(obj.enableOfflineMode)
      ..writeByte(9)
      ..write(obj.lastTabId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettingsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
