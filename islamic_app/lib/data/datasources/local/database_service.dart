// lib/data/datasources/local/database_service.dart

import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import '../../models/surah_model.dart';
import '../../../core/constants/app_constants.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Future<Database> get database async {
    _db ??= await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), AppConstants.dbName);
    return openDatabase(
      path,
      version: AppConstants.dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE surahs (
        id INTEGER PRIMARY KEY,
        number INTEGER NOT NULL,
        name TEXT NOT NULL,
        name_arabic TEXT NOT NULL,
        name_translation TEXT,
        number_of_ayahs INTEGER NOT NULL,
        revelation_type TEXT,
        is_downloaded INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE ayahs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        number INTEGER NOT NULL,
        number_in_surah INTEGER NOT NULL,
        text TEXT NOT NULL,
        surah_number INTEGER NOT NULL,
        juz INTEGER DEFAULT 0,
        page INTEGER DEFAULT 0,
        is_favorite INTEGER DEFAULT 0,
        is_bookmarked INTEGER DEFAULT 0,
        FOREIGN KEY (surah_number) REFERENCES surahs(number)
      )
    ''');

    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        item_id INTEGER NOT NULL,
        item_data TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE downloads (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        surah_number INTEGER NOT NULL,
        reciter TEXT NOT NULL,
        file_path TEXT NOT NULL,
        file_size INTEGER DEFAULT 0,
        downloaded_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE bookmarks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        surah_number INTEGER NOT NULL,
        ayah_number INTEGER NOT NULL,
        surah_name TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    // Index for faster queries
    await db.execute('CREATE INDEX idx_ayahs_surah ON ayahs(surah_number)');
    await db.execute('CREATE INDEX idx_favorites_type ON favorites(type)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle future migrations here
  }

  // ============ SURAHS ============

  Future<void> insertSurah(SurahModel surah) async {
    final db = await database;
    await db.insert(
      'surahs',
      {
        'number': surah.number,
        'name': surah.name,
        'name_arabic': surah.nameArabic,
        'name_translation': surah.nameTranslation,
        'number_of_ayahs': surah.numberOfAyahs,
        'revelation_type': surah.revelationType,
        'is_downloaded': surah.isDownloaded ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Insert ayahs if available
    if (surah.ayahs != null && surah.ayahs!.isNotEmpty) {
      await insertAyahs(surah.ayahs!, surah.number);
    }
  }

  Future<void> insertAllSurahs(List<SurahModel> surahs) async {
    final db = await database;
    final batch = db.batch();
    for (final surah in surahs) {
      batch.insert(
        'surahs',
        {
          'number': surah.number,
          'name': surah.name,
          'name_arabic': surah.nameArabic,
          'name_translation': surah.nameTranslation,
          'number_of_ayahs': surah.numberOfAyahs,
          'revelation_type': surah.revelationType,
          'is_downloaded': 0,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<SurahModel>> getAllSurahs() async {
    final db = await database;
    final maps = await db.query('surahs', orderBy: 'number ASC');
    return maps.map((m) => SurahModel(
          number: m['number'] as int,
          name: m['name'] as String,
          nameArabic: m['name_arabic'] as String,
          nameTranslation: m['name_translation'] as String? ?? '',
          numberOfAyahs: m['number_of_ayahs'] as int,
          revelationType: m['revelation_type'] as String? ?? '',
          isDownloaded: (m['is_downloaded'] as int) == 1,
        )).toList();
  }

  Future<bool> isSurahsLoaded() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM surahs');
    return (result.first['count'] as int) > 0;
  }

  // ============ AYAHS ============

  Future<void> insertAyahs(List<AyahModel> ayahs, int surahNumber) async {
    final db = await database;
    final batch = db.batch();
    for (final ayah in ayahs) {
      batch.insert(
        'ayahs',
        {
          'number': ayah.number,
          'number_in_surah': ayah.numberInSurah,
          'text': ayah.text,
          'surah_number': surahNumber,
          'juz': ayah.juz,
          'page': ayah.page,
          'is_favorite': 0,
          'is_bookmarked': 0,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<AyahModel>> getAyahsForSurah(int surahNumber) async {
    final db = await database;
    final maps = await db.query(
      'ayahs',
      where: 'surah_number = ?',
      whereArgs: [surahNumber],
      orderBy: 'number_in_surah ASC',
    );
    return maps.map((m) => AyahModel(
          number: m['number'] as int,
          numberInSurah: m['number_in_surah'] as int,
          text: m['text'] as String,
          surahNumber: m['surah_number'] as int,
          juz: m['juz'] as int,
          page: m['page'] as int,
          isFavorite: (m['is_favorite'] as int) == 1,
          isBookmarked: (m['is_bookmarked'] as int) == 1,
        )).toList();
  }

  Future<bool> isAyahsLoaded(int surahNumber) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ayahs WHERE surah_number = ?',
      [surahNumber],
    );
    return (result.first['count'] as int) > 0;
  }

  // ============ FAVORITES ============

  Future<void> addFavorite(String type, int itemId, Map<String, dynamic> data) async {
    final db = await database;
    await db.insert('favorites', {
      'type': type,
      'item_id': itemId,
      'item_data': jsonEncode(data),
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> removeFavorite(String type, int itemId) async {
    final db = await database;
    await db.delete(
      'favorites',
      where: 'type = ? AND item_id = ?',
      whereArgs: [type, itemId],
    );
  }

  Future<bool> isFavorite(String type, int itemId) async {
    final db = await database;
    final result = await db.query(
      'favorites',
      where: 'type = ? AND item_id = ?',
      whereArgs: [type, itemId],
    );
    return result.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> getFavorites(String type) async {
    final db = await database;
    final maps = await db.query(
      'favorites',
      where: 'type = ?',
      whereArgs: [type],
      orderBy: 'created_at DESC',
    );
    return maps.map((m) => {
          ...m,
          'item_data': jsonDecode(m['item_data'] as String),
        }).toList();
  }

  // ============ BOOKMARKS ============

  Future<void> addBookmark(int surahNumber, int ayahNumber, String surahName) async {
    final db = await database;
    await db.insert(
      'bookmarks',
      {
        'surah_number': surahNumber,
        'ayah_number': ayahNumber,
        'surah_name': surahName,
        'created_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getBookmarks() async {
    final db = await database;
    return db.query('bookmarks', orderBy: 'created_at DESC');
  }

  // ============ DOWNLOADS ============

  Future<void> markSurahDownloaded(int surahNumber) async {
    final db = await database;
    await db.update(
      'surahs',
      {'is_downloaded': 1},
      where: 'number = ?',
      whereArgs: [surahNumber],
    );
  }

  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('ayahs');
    await db.delete('surahs');
  }
}
