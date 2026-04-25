// lib/presentation/screens/azkar/azkar_screen.dart

import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import '../../../core/theme/app_theme.dart';

class AzkarScreen extends StatelessWidget {
  const AzkarScreen({super.key});

  static const _categories = [
    _AzkarCategory('أذكار الصباح', '🌅', Color(0xFF5C3A1E), _morningAzkar),
    _AzkarCategory('أذكار المساء', '🌙', Color(0xFF1A2A5C), _eveningAzkar),
    _AzkarCategory('أذكار النوم', '😴', Color(0xFF2A1A4A), _sleepAzkar),
    _AzkarCategory('أذكار بعد الصلاة', '🕌', Color(0xFF1A4A2A), _prayerAzkar),
    _AzkarCategory('أذكار متنوعة', '📿', Color(0xFF4A1A2A), _miscAzkar),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('الأذكار')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _categories.length,
        itemBuilder: (context, i) {
          final cat = _categories[i];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AzkarDetailScreen(category: cat)),
            ),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cat.color.withOpacity(isDark ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cat.color.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  Text(cat.emoji, style: const TextStyle(fontSize: 36)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          cat.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Amiri',
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkText : AppColors.lightText,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        Text(
                          '${cat.azkar.length} ذكر',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                            fontFamily: 'Amiri',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: cat.color),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Sample Azkar Data
  static const _morningAzkar = [
    _Zikr('أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ وَالْحَمْدُ لِلَّهِ', 1, 'رواه مسلم'),
    _Zikr('اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ وَإِلَيْكَ النُّشُورُ', 1, 'رواه أبو داود'),
    _Zikr('اللَّهُمَّ أَنْتَ رَبِّي لاَ إِلَهَ إِلاَّ أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ', 1, 'رواه البخاري - سيد الاستغفار'),
    _Zikr('سُبْحَانَ اللَّهِ وَبِحَمْدِهِ', 100, 'متفق عليه'),
    _Zikr('لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ', 10, 'رواه البخاري'),
  ];

  static const _eveningAzkar = [
    _Zikr('أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ وَالْحَمْدُ لِلَّهِ', 1, 'رواه مسلم'),
    _Zikr('اللَّهُمَّ بِكَ أَمْسَيْنَا، وَبِكَ أَصْبَحْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ وَإِلَيْكَ الْمَصِيرُ', 1, 'رواه أبو داود'),
    _Zikr('أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ', 3, 'رواه مسلم'),
  ];

  static const _sleepAzkar = [
    _Zikr('بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا', 1, 'رواه البخاري'),
    _Zikr('اللَّهُمَّ قِنِي عَذَابَكَ يَوْمَ تَبْعَثُ عِبَادَكَ', 3, 'رواه أبو داود'),
    _Zikr('سُبْحَانَ اللَّهِ', 33, 'متفق عليه'),
    _Zikr('الْحَمْدُ لِلَّهِ', 33, 'متفق عليه'),
    _Zikr('اللَّهُ أَكْبَرُ', 34, 'متفق عليه'),
  ];

  static const _prayerAzkar = [
    _Zikr('أَسْتَغْفِرُ اللَّهَ', 3, 'رواه مسلم'),
    _Zikr('اللَّهُمَّ أَنْتَ السَّلاَمُ وَمِنْكَ السَّلاَمُ تَبَارَكْتَ يَا ذَا الْجَلاَلِ وَالإِكْرَامِ', 1, 'رواه مسلم'),
    _Zikr('سُبْحَانَ اللَّهِ', 33, 'رواه مسلم'),
    _Zikr('الْحَمْدُ لِلَّهِ', 33, 'رواه مسلم'),
    _Zikr('اللَّهُ أَكْبَرُ', 33, 'رواه مسلم'),
    _Zikr('لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ', 1, 'رواه مسلم'),
    _Zikr('آيَةُ الْكُرْسِيِّ', 1, 'رواه البخاري'),
  ];

  static const _miscAzkar = [
    _Zikr('لاَ حَوْلَ وَلاَ قُوَّةَ إِلاَّ بِاللَّهِ', 1, 'كنز من كنوز الجنة'),
    _Zikr('حَسْبِيَ اللَّهُ لَا إِلَهَ إِلَّا هُوَ عَلَيْهِ تَوَكَّلْتُ وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ', 7, 'رواه أبو داود'),
    _Zikr('بِسْمِ اللَّهِ الَّذِي لاَ يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الأَرْضِ وَلاَ فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ', 3, 'رواه أبو داود'),
  ];
}

// ============================

class AzkarDetailScreen extends StatefulWidget {
  final _AzkarCategory category;
  const AzkarDetailScreen({super.key, required this.category});
  @override
  State<AzkarDetailScreen> createState() => _AzkarDetailScreenState();
}

class _AzkarDetailScreenState extends State<AzkarDetailScreen> {
  int _currentIndex = 0;
  int _counter = 0;

  _Zikr get current => widget.category.azkar[_currentIndex];

  void _increment() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 30);
    }
    setState(() {
      _counter++;
      if (_counter >= current.count) {
        _counter = 0;
        if (_currentIndex < widget.category.azkar.length - 1) {
          _currentIndex++;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progress = current.count > 0 ? _counter / current.count : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.star_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Progress indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_currentIndex + 1} / ${widget.category.azkar.length}',
                  style: TextStyle(color: AppColors.gold, fontFamily: 'Amiri'),
                ),
                Text(
                  widget.category.emoji,
                  style: const TextStyle(fontSize: 24),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: (_currentIndex + 1) / widget.category.azkar.length,
              backgroundColor: AppColors.darkBorder,
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(8),
              minHeight: 6,
            ),

            const SizedBox(height: 24),

            // Zikr Card
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.lightCard,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: widget.category.color.withOpacity(0.4),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      current.text,
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: 'Uthmanic',
                        color: isDark ? AppColors.darkText : AppColors.lightText,
                        height: 2.0,
                      ),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 20),
                    if (current.source != null)
                      Text(
                        current.source!,
                        style: const TextStyle(
                          color: AppColors.gold,
                          fontSize: 13,
                          fontFamily: 'Amiri',
                        ),
                      ),
                    const SizedBox(height: 24),

                    // Counter circle
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.category.color.withOpacity(0.15),
                        border: Border.all(
                          color: widget.category.color.withOpacity(0.5),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$_counter',
                            style: TextStyle(
                              color: isDark ? AppColors.darkText : AppColors.lightText,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'من ${current.count}',
                            style: const TextStyle(
                              color: AppColors.gold,
                              fontSize: 12,
                              fontFamily: 'Amiri',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: AppColors.darkBorder,
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(8),
                      minHeight: 6,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Counter button
            GestureDetector(
              onTap: _increment,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppColors.gold, AppColors.goldDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gold.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text('سبّح', style: TextStyle(
                    color: Colors.black87,
                    fontSize: 22,
                    fontFamily: 'Amiri',
                    fontWeight: FontWeight.bold,
                  )),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.chevron_right),
                  label: const Text('السابق', style: TextStyle(fontFamily: 'Amiri')),
                  onPressed: _currentIndex > 0
                      ? () => setState(() { _currentIndex--; _counter = 0; })
                      : null,
                ),
                TextButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('إعادة', style: TextStyle(fontFamily: 'Amiri')),
                  onPressed: () => setState(() => _counter = 0),
                ),
                TextButton.icon(
                  label: const Text('التالي', style: TextStyle(fontFamily: 'Amiri')),
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _currentIndex < widget.category.azkar.length - 1
                      ? () => setState(() { _currentIndex++; _counter = 0; })
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================

class _AzkarCategory {
  final String name;
  final String emoji;
  final Color color;
  final List<_Zikr> azkar;
  const _AzkarCategory(this.name, this.emoji, this.color, this.azkar);
}

class _Zikr {
  final String text;
  final int count;
  final String? source;
  const _Zikr(this.text, this.count, [this.source]);
}
