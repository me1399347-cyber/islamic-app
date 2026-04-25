// lib/data/repositories/quran_repository.dart

import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/surah_model.dart';
import '../datasources/local/database_service.dart';
import '../datasources/remote/quran_api_service.dart';

class QuranRepository {
  final DatabaseService _db;
  final QuranApiService _api;
  final Connectivity _connectivity;

  QuranRepository({
    DatabaseService? db,
    QuranApiService? api,
    Connectivity? connectivity,
  })  : _db = db ?? DatabaseService(),
        _api = api ?? QuranApiService(),
        _connectivity = connectivity ?? Connectivity();

  Future<bool> get isOnline async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  // ---- Get all Surahs (local first, then remote) ----
  Future<List<SurahModel>> getAllSurahs() async {
    // Try local first
    final localSurahs = await _db.getAllSurahs();
    if (localSurahs.isNotEmpty) return localSurahs;

    // Fetch from API and cache
    if (await isOnline) {
      final remoteSurahs = await _api.fetchAllSurahs();
      await _db.insertAllSurahs(remoteSurahs);
      return remoteSurahs;
    }

    throw Exception('No internet connection and no cached data');
  }

  // ---- Get Surah with Ayahs ----
  Future<SurahModel> getSurah(int surahNumber) async {
    // Check if ayahs are cached locally
    if (await _db.isAyahsLoaded(surahNumber)) {
      final surahs = await _db.getAllSurahs();
      final surah = surahs.firstWhere((s) => s.number == surahNumber);
      final ayahs = await _db.getAyahsForSurah(surahNumber);
      return surah.copyWith(ayahs: ayahs);
    }

    // Fetch from API
    if (await isOnline) {
      final surah = await _api.fetchSurah(surahNumber);
      await _db.insertSurah(surah);
      return surah;
    }

    throw Exception('Surah not available offline');
  }

  // ---- Download Surah for Offline ----
  Future<void> downloadSurah(int surahNumber) async {
    final surah = await _api.fetchSurah(surahNumber);
    await _db.insertSurah(surah);
    await _db.markSurahDownloaded(surahNumber);
  }

  // ---- Favorites ----
  Future<void> addAyahToFavorites(AyahModel ayah) async {
    await _db.addFavorite('ayah', ayah.number, {
      'number': ayah.number,
      'numberInSurah': ayah.numberInSurah,
      'text': ayah.text,
      'surahNumber': ayah.surahNumber,
    });
  }

  Future<void> removeAyahFromFavorites(int ayahNumber) async {
    await _db.removeFavorite('ayah', ayahNumber);
  }

  Future<bool> isAyahFavorite(int ayahNumber) async {
    return _db.isFavorite('ayah', ayahNumber);
  }

  Future<List<Map<String, dynamic>>> getFavoriteAyahs() async {
    return _db.getFavorites('ayah');
  }

  // ---- Bookmarks ----
  Future<void> addBookmark(int surahNumber, int ayahNumber, String surahName) async {
    await _db.addBookmark(surahNumber, ayahNumber, surahName);
  }

  Future<List<Map<String, dynamic>>> getBookmarks() async {
    return _db.getBookmarks();
  }

  // ---- Audio URL ----
  String getAyahAudioUrl(int ayahNumber, String reciter) {
    return _api.getAyahAudioUrl(ayahNumber, reciter);
  }

  String getSurahAudioUrl(int surahNumber, String reciter) {
    return _api.getSurahAudioUrl(surahNumber, reciter);
  }
}
