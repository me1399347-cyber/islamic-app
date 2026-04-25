// lib/data/datasources/remote/quran_api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/surah_model.dart';
import '../../../core/constants/app_constants.dart';

class QuranApiService {
  final http.Client _client;
  QuranApiService({http.Client? client}) : _client = client ?? http.Client();

  // ---- Fetch all surahs list ----
  Future<List<SurahModel>> fetchAllSurahs() async {
    final response = await _client.get(
      Uri.parse('${AppConstants.quranApiBase}/surah'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List surahsList = data['data'];
      return surahsList.map((s) => SurahModel.fromJson(s)).toList();
    }
    throw Exception('Failed to load surahs: ${response.statusCode}');
  }

  // ---- Fetch single surah with ayahs ----
  Future<SurahModel> fetchSurah(int surahNumber) async {
    final response = await _client.get(
      Uri.parse('${AppConstants.quranApiBase}/surah/$surahNumber'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return SurahModel.fromJson(data['data']);
    }
    throw Exception('Failed to load surah $surahNumber');
  }

  // ---- Fetch surah with translation ----
  Future<List<AyahModel>> fetchSurahWithTranslation(
      int surahNumber, String edition) async {
    final response = await _client.get(
      Uri.parse('${AppConstants.quranApiBase}/surah/$surahNumber/$edition'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List ayahsList = data['data']['ayahs'];
      return ayahsList
          .map((a) => AyahModel.fromJson({...a, 'surahNumber': surahNumber}))
          .toList();
    }
    throw Exception('Failed to load translation');
  }

  // ---- Get audio URL for ayah ----
  String getAyahAudioUrl(int ayahNumber, String reciter) {
    final paddedNumber = ayahNumber.toString().padLeft(6, '0');
    return '${AppConstants.audioBase}/64/$reciter/$paddedNumber.mp3';
  }

  // ---- Get full surah audio URL ----
  String getSurahAudioUrl(int surahNumber, String reciter) {
    final paddedNumber = surahNumber.toString().padLeft(3, '0');
    return 'https://download.quranicaudio.com/quran/$reciter/$paddedNumber.mp3';
  }

  // ---- Search in Quran ----
  Future<List<AyahModel>> searchQuran(String query) async {
    final response = await _client.get(
      Uri.parse('${AppConstants.quranApiBase}/search/$query/all/ar'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List matches = data['data']['matches'];
      return matches.map((a) => AyahModel.fromJson(a)).toList();
    }
    throw Exception('Search failed');
  }
}
