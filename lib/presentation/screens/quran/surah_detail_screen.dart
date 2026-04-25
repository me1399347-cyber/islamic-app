// lib/presentation/screens/quran/surah_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import '../../blocs/quran_bloc.dart';
import '../../blocs/settings_bloc.dart';
import '../../../data/models/surah_model.dart';
import '../../../data/datasources/local/audio_player_service.dart';
import '../../../core/theme/app_theme.dart';

class SurahDetailScreen extends StatefulWidget {
  final int surahNumber;
  const SurahDetailScreen({super.key, required this.surahNumber});
  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  final _audioService = AudioPlayerService();
  bool _isAudioMode = false;
  bool _isPlaying = false;
  int? _playingAyah;

  @override
  void initState() {
    super.initState();
    context.read<QuranBloc>().add(LoadSurahEvent(widget.surahNumber));
  }

  @override
  void dispose() {
    _audioService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsBloc>().state;
    final isDark = settings.isDarkMode;

    return BlocBuilder<QuranBloc, QuranState>(
      builder: (context, state) {
        if (state is QuranLoading) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(color: AppColors.gold),
                  SizedBox(height: 16),
                  Text('جاري تحميل السورة...', style: TextStyle(fontFamily: 'Amiri', fontSize: 16)),
                ],
              ),
            ),
          );
        }

        if (state is SurahLoaded) {
          final surah = state.surah;
          return Scaffold(
            appBar: AppBar(
              title: Text(surah.nameArabic),
              actions: [
                // Audio toggle
                IconButton(
                  icon: Icon(
                    _isAudioMode ? Icons.headphones : Icons.headphones_outlined,
                    color: _isAudioMode ? AppColors.gold : null,
                  ),
                  onPressed: () => setState(() => _isAudioMode = !_isAudioMode),
                  tooltip: 'وضع التلاوة',
                ),
                // Font size
                IconButton(
                  icon: const Icon(Icons.text_fields),
                  onPressed: () => _showFontSizeDialog(context, settings),
                ),
                // Bookmark
                IconButton(
                  icon: const Icon(Icons.bookmark_outline),
                  onPressed: () {},
                ),
              ],
            ),
            body: Column(
              children: [
                // Surah Info Header
                _buildSurahHeader(surah, isDark),

                // Bismillah
                if (surah.number != 1 && surah.number != 9)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                      style: TextStyle(
                        fontSize: settings.fontSize - 2,
                        fontFamily: settings.fontFamily,
                        color: AppColors.gold,
                        height: 2.0,
                      ),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                  ),

                // Ayahs List
                Expanded(
                  child: surah.ayahs == null
                      ? const Center(child: Text('لا توجد آيات متاحة'))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemCount: surah.ayahs!.length,
                          itemBuilder: (context, index) {
                            final ayah = surah.ayahs![index];
                            final isSelected = state.selectedAyah == ayah.numberInSurah;
                            final isFav = state.favoriteAyahs.contains(ayah.number);
                            return _AyahCard(
                              ayah: ayah,
                              isSelected: isSelected,
                              isFavorite: isFav,
                              isAudioMode: _isAudioMode,
                              isPlaying: _playingAyah == ayah.numberInSurah && _isPlaying,
                              fontSize: settings.fontSize,
                              fontFamily: settings.fontFamily,
                              isDark: isDark,
                              onTap: () {
                                context.read<QuranBloc>().add(
                                    SelectAyahEvent(isSelected ? null : ayah.numberInSurah));
                              },
                              onFavorite: () {
                                context.read<QuranBloc>().add(
                                    ToggleFavoriteAyahEvent(ayah, isFav));
                              },
                              onPlay: () async {
                                if (_playingAyah == ayah.numberInSurah && _isPlaying) {
                                  await _audioService.pause();
                                  setState(() => _isPlaying = false);
                                } else {
                                  await _audioService.playAyah(
                                    ayah.number,
                                    settings.defaultReciter,
                                  );
                                  setState(() {
                                    _isPlaying = true;
                                    _playingAyah = ayah.numberInSurah;
                                  });
                                }
                              },
                            );
                          },
                        ),
                ),

                // Audio Player Bar
                if (_isAudioMode)
                  _buildAudioBar(surah, settings, isDark),
              ],
            ),
          );
        }

        return const Scaffold(
          body: Center(child: Text('حدث خطأ')),
        );
      },
    );
  }

  Widget _buildSurahHeader(SurahModel surah, bool isDark) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1B3A2D), const Color(0xFF0D1F17)]
              : [AppColors.primaryGreen, AppColors.primaryGreenLight],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${surah.numberOfAyahs} آية',
                  style: const TextStyle(color: AppColors.goldLight, fontSize: 13, fontFamily: 'Amiri')),
              Text(surah.revelationType,
                  style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
          Column(
            children: [
              Text(
                surah.nameArabic,
                style: const TextStyle(
                  color: AppColors.gold,
                  fontSize: 22,
                  fontFamily: 'Amiri',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(surah.name,
                  style: const TextStyle(color: Colors.white60, fontSize: 12)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('السورة ${surah.number}',
                  style: const TextStyle(color: AppColors.goldLight, fontSize: 13, fontFamily: 'Amiri')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAudioBar(SurahModel surah, SettingsState settings, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(top: BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        )),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Reciter name
          Text(
            'القارئ: ${_getReciterName(settings.defaultReciter)}',
            style: const TextStyle(color: AppColors.gold, fontFamily: 'Amiri', fontSize: 13),
          ),
          const SizedBox(height: 8),
          // Progress bar
          StreamBuilder<PositionData>(
            stream: _audioService.positionDataStream,
            builder: (context, snapshot) {
              final data = snapshot.data;
              final position = data?.position ?? Duration.zero;
              final duration = data?.duration ?? Duration.zero;
              return Column(
                children: [
                  Slider(
                    value: duration.inMilliseconds > 0
                        ? position.inMilliseconds / duration.inMilliseconds
                        : 0,
                    onChanged: (v) {
                      _audioService.seek(Duration(
                        milliseconds: (v * duration.inMilliseconds).round(),
                      ));
                    },
                    activeColor: AppColors.gold,
                    inactiveColor: AppColors.darkBorder,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_formatDuration(position), style: const TextStyle(fontSize: 11)),
                      Text(_formatDuration(duration), style: const TextStyle(fontSize: 11)),
                    ],
                  ),
                ],
              );
            },
          ),
          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous),
                onPressed: _audioService.previous,
                color: AppColors.gold,
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: AppColors.gold.withOpacity(0.4), blurRadius: 12)],
                ),
                child: IconButton(
                  icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                  color: Colors.black87,
                  iconSize: 32,
                  onPressed: () async {
                    if (_isPlaying) {
                      await _audioService.pause();
                      setState(() => _isPlaying = false);
                    } else {
                      if (_playingAyah == null) {
                        await _audioService.playSurah(
                          surah.number,
                          settings.defaultReciter,
                        );
                      } else {
                        await _audioService.play();
                      }
                      setState(() => _isPlaying = true);
                    }
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.skip_next),
                onPressed: _audioService.next,
                color: AppColors.gold,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getReciterName(String reciter) {
    const names = {
      'ar.alafasy': 'مشاري العفاسي',
      'ar.abdurrahmaansudais': 'السديس',
      'ar.husary': 'الحصري',
      'ar.minshawi': 'المنشاوي',
      'ar.mahermuaiqly': 'ماهر المعيقلي',
    };
    return names[reciter] ?? reciter;
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _showFontSizeDialog(BuildContext context, SettingsState settings) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('حجم الخط', textDirection: TextDirection.rtl),
        content: StatefulBuilder(
          builder: (ctx, setS) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'نموذج للخط',
                style: TextStyle(
                  fontSize: settings.fontSize,
                  fontFamily: settings.fontFamily,
                ),
              ),
              Slider(
                value: settings.fontSize,
                min: 16,
                max: 36,
                divisions: 10,
                label: '${settings.fontSize.round()}',
                onChanged: (v) {
                  context.read<SettingsBloc>().add(ChangeFontSizeEvent(v));
                },
                activeColor: AppColors.gold,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }
}

class _AyahCard extends StatelessWidget {
  final AyahModel ayah;
  final bool isSelected;
  final bool isFavorite;
  final bool isAudioMode;
  final bool isPlaying;
  final double fontSize;
  final String fontFamily;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback onFavorite;
  final VoidCallback onPlay;

  const _AyahCard({
    required this.ayah,
    required this.isSelected,
    required this.isFavorite,
    required this.isAudioMode,
    required this.isPlaying,
    required this.fontSize,
    required this.fontFamily,
    required this.isDark,
    required this.onTap,
    required this.onFavorite,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.gold.withOpacity(0.1)
              : isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppColors.gold.withOpacity(0.5)
                : isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Ayah number row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Actions
                Row(
                  children: [
                    if (isAudioMode)
                      GestureDetector(
                        onTap: onPlay,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.gold.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                            size: 18,
                            color: AppColors.gold,
                          ),
                        ),
                      ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: onFavorite,
                      child: Icon(
                        isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
                        size: 20,
                        color: isFavorite ? AppColors.gold : AppColors.darkTextMuted,
                      ),
                    ),
                  ],
                ),
                // Ayah number badge
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.gold, width: 1.5),
                  ),
                  child: Center(
                    child: Text(
                      '${ayah.numberInSurah}',
                      style: const TextStyle(
                        color: AppColors.gold,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Ayah text
            Text(
              ayah.text,
              style: TextStyle(
                fontSize: fontSize,
                fontFamily: fontFamily,
                color: isDark ? AppColors.darkText : AppColors.lightText,
                height: 2.0,
              ),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
      ),
    );
  }
}
