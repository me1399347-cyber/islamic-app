// lib/data/models/surah_model.dart

import 'package:hive/hive.dart';

part 'surah_model.g.dart';

@HiveType(typeId: 0)
class SurahModel extends HiveObject {
  @HiveField(0)
  final int number;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String nameArabic;

  @HiveField(3)
  final String nameTranslation;

  @HiveField(4)
  final int numberOfAyahs;

  @HiveField(5)
  final String revelationType;

  @HiveField(6)
  final List<AyahModel>? ayahs;

  @HiveField(7)
  final bool isDownloaded;

  const SurahModel({
    required this.number,
    required this.name,
    required this.nameArabic,
    required this.nameTranslation,
    required this.numberOfAyahs,
    required this.revelationType,
    this.ayahs,
    this.isDownloaded = false,
  });

  factory SurahModel.fromJson(Map<String, dynamic> json) => SurahModel(
        number: json['number'],
        name: json['englishName'] ?? '',
        nameArabic: json['name'] ?? '',
        nameTranslation: json['englishNameTranslation'] ?? '',
        numberOfAyahs: json['numberOfAyahs'],
        revelationType: json['revelationType'] ?? '',
        ayahs: (json['ayahs'] as List<dynamic>?)
            ?.map((a) => AyahModel.fromJson(a))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'number': number,
        'name': nameArabic,
        'englishName': name,
        'englishNameTranslation': nameTranslation,
        'numberOfAyahs': numberOfAyahs,
        'revelationType': revelationType,
      };

  SurahModel copyWith({bool? isDownloaded, List<AyahModel>? ayahs}) => SurahModel(
        number: number,
        name: name,
        nameArabic: nameArabic,
        nameTranslation: nameTranslation,
        numberOfAyahs: numberOfAyahs,
        revelationType: revelationType,
        ayahs: ayahs ?? this.ayahs,
        isDownloaded: isDownloaded ?? this.isDownloaded,
      );
}

// -----------------------------------------------

@HiveType(typeId: 1)
class AyahModel extends HiveObject {
  @HiveField(0)
  final int number;

  @HiveField(1)
  final int numberInSurah;

  @HiveField(2)
  final String text;

  @HiveField(3)
  final int surahNumber;

  @HiveField(4)
  final int juz;

  @HiveField(5)
  final int page;

  @HiveField(6)
  bool isFavorite;

  @HiveField(7)
  bool isBookmarked;

  AyahModel({
    required this.number,
    required this.numberInSurah,
    required this.text,
    required this.surahNumber,
    required this.juz,
    required this.page,
    this.isFavorite = false,
    this.isBookmarked = false,
  });

  factory AyahModel.fromJson(Map<String, dynamic> json) => AyahModel(
        number: json['number'],
        numberInSurah: json['numberInSurah'],
        text: json['text'],
        surahNumber: json['surahNumber'] ?? 0,
        juz: json['juz'] ?? 0,
        page: json['page'] ?? 0,
      );
}

// -----------------------------------------------

@HiveType(typeId: 2)
class AzkarModel extends HiveObject {
  @HiveField(0)
  final String category;

  @HiveField(1)
  final String text;

  @HiveField(2)
  final String? source;

  @HiveField(3)
  final int count;

  @HiveField(4)
  final String? virtue;

  @HiveField(5)
  bool isFavorite;

  AzkarModel({
    required this.category,
    required this.text,
    this.source,
    required this.count,
    this.virtue,
    this.isFavorite = false,
  });

  factory AzkarModel.fromJson(Map<String, dynamic> json) => AzkarModel(
        category: json['category'] ?? '',
        text: json['content'] ?? json['text'] ?? '',
        source: json['reference'],
        count: json['count'] ?? 1,
        virtue: json['description'],
      );
}

// -----------------------------------------------

@HiveType(typeId: 3)
class DuaModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String arabicText;

  @HiveField(3)
  final String? translation;

  @HiveField(4)
  final String category;

  @HiveField(5)
  final String? source;

  @HiveField(6)
  bool isFavorite;

  DuaModel({
    required this.id,
    required this.title,
    required this.arabicText,
    this.translation,
    required this.category,
    this.source,
    this.isFavorite = false,
  });
}

// -----------------------------------------------

@HiveType(typeId: 4)
class TasbeehModel extends HiveObject {
  @HiveField(0)
  final String text;

  @HiveField(1)
  int count;

  @HiveField(2)
  final int target;

  @HiveField(3)
  final DateTime lastReset;

  TasbeehModel({
    required this.text,
    this.count = 0,
    required this.target,
    required this.lastReset,
  });
}

// -----------------------------------------------

@HiveType(typeId: 5)
class ReminderModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String message;

  @HiveField(2)
  final int intervalMinutes;

  @HiveField(3)
  bool isActive;

  @HiveField(4)
  final DateTime createdAt;

  ReminderModel({
    required this.id,
    required this.message,
    required this.intervalMinutes,
    this.isActive = true,
    required this.createdAt,
  });
}

// -----------------------------------------------

@HiveType(typeId: 6)
class AppSettings extends HiveObject {
  @HiveField(0)
  bool isDarkMode;

  @HiveField(1)
  double fontSize;

  @HiveField(2)
  String fontFamily;

  @HiveField(3)
  String defaultReciter;

  @HiveField(4)
  bool vibrationEnabled;

  @HiveField(5)
  bool remindersEnabled;

  @HiveField(6)
  bool showTranslation;

  AppSettings({
    this.isDarkMode = true,
    this.fontSize = 22.0,
    this.fontFamily = 'Uthmanic',
    this.defaultReciter = 'ar.alafasy',
    this.vibrationEnabled = true,
    this.remindersEnabled = true,
    this.showTranslation = false,
  });
}
