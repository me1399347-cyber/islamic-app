// lib/presentation/screens/dua/dua_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_theme.dart';

class DuaScreen extends StatefulWidget {
  const DuaScreen({super.key});
  @override
  State<DuaScreen> createState() => _DuaScreenState();
}

class _DuaScreenState extends State<DuaScreen> {
  String _selectedCategory = 'الكل';

  final List<String> _categories = [
    'الكل', 'رزق', 'شفاء', 'تفريج هموم', 'حماية', 'هداية', 'زواج', 'نجاح',
  ];

  final List<_Dua> _duas = [
    _Dua(
      id: 1,
      title: 'دعاء الرزق',
      arabicText: 'اللَّهُمَّ اكْفِنِي بِحَلَالِكَ عَنْ حَرَامِكَ، وَأَغْنِنِي بِفَضْلِكَ عَمَّنْ سِوَاكَ',
      translation: 'O Allah, suffice me with what You have allowed instead of what You have forbidden, and make me independent of all others besides You.',
      source: 'رواه الترمذي',
      category: 'رزق',
    ),
    _Dua(
      id: 2,
      title: 'دعاء الشفاء',
      arabicText: 'اللَّهُمَّ رَبَّ النَّاسِ، أَذْهِبِ الْبَأْسَ، وَاشْفِ، أَنْتَ الشَّافِي، لَا شِفَاءَ إِلَّا شِفَاؤُكَ، شِفَاءً لَا يُغَادِرُ سَقَمًا',
      translation: 'O Allah, Lord of mankind, remove this pain and cure it. You are the one who cures and there is no cure except Your cure.',
      source: 'متفق عليه',
      category: 'شفاء',
    ),
    _Dua(
      id: 3,
      title: 'دعاء تفريج الهموم',
      arabicText: 'اللَّهُمَّ إِنِّي عَبْدُكَ، ابْنُ عَبْدِكَ، ابْنُ أَمَتِكَ، نَاصِيَتِي بِيَدِكَ، مَاضٍ فِيَّ حُكْمُكَ، عَدْلٌ فِيَّ قَضَاؤُكَ',
      translation: 'O Allah, I am Your servant, son of Your servant, son of Your maidservant. My forelock is in Your hand.',
      source: 'رواه أحمد',
      category: 'تفريج هموم',
    ),
    _Dua(
      id: 4,
      title: 'دعاء الحماية',
      arabicText: 'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ',
      translation: 'I seek refuge in the perfect words of Allah from the evil of what He has created.',
      source: 'رواه مسلم',
      category: 'حماية',
    ),
    _Dua(
      id: 5,
      title: 'دعاء الهداية',
      arabicText: 'رَبَّنَا لَا تُزِغْ قُلُوبَنَا بَعْدَ إِذْ هَدَيْتَنَا وَهَبْ لَنَا مِن لَّدُنكَ رَحْمَةً إِنَّكَ أَنتَ الْوَهَّابُ',
      translation: 'Our Lord, let not our hearts deviate after You have guided us and grant us from Yourself mercy.',
      source: 'آل عمران: 8',
      category: 'هداية',
    ),
    _Dua(
      id: 6,
      title: 'دعاء الزواج',
      arabicText: 'رَبَّنَا هَبْ لَنَا مِنْ أَزْوَاجِنَا وَذُرِّيَّاتِنَا قُرَّةَ أَعْيُنٍ وَاجْعَلْنَا لِلْمُتَّقِينَ إِمَامًا',
      translation: 'Our Lord, grant us from among our wives and offspring comfort to our eyes and make us an example for the righteous.',
      source: 'الفرقان: 74',
      category: 'زواج',
    ),
    _Dua(
      id: 7,
      title: 'دعاء النجاح',
      arabicText: 'رَبِّ اشْرَحْ لِي صَدْرِي وَيَسِّرْ لِي أَمْرِي وَاحْلُلْ عُقْدَةً مِّن لِّسَانِي يَفْقَهُوا قَوْلِي',
      translation: 'My Lord, expand for me my breast and ease for me my task.',
      source: 'طه: 25-28',
      category: 'نجاح',
    ),
    _Dua(
      id: 8,
      title: 'دعاء قضاء الدين',
      arabicText: 'اللَّهُمَّ اكْفِنِي بِحَلاَلِكَ عَنْ حَرَامِكَ وَأَغْنِنِي بِفَضْلِكَ عَمَّنْ سِوَاكَ',
      translation: 'O Allah, suffice me with Your lawful against Your prohibited.',
      source: 'رواه الترمذي',
      category: 'رزق',
    ),
    _Dua(
      id: 9,
      title: 'دعاء الكرب الشديد',
      arabicText: 'لَا إِلَهَ إِلَّا اللَّهُ الْعَظِيمُ الْحَلِيمُ، لَا إِلَهَ إِلَّا اللَّهُ رَبُّ الْعَرْشِ الْعَظِيمِ، لَا إِلَهَ إِلَّا اللَّهُ رَبُّ السَّمَوَاتِ وَرَبُّ الأَرْضِ وَرَبُّ الْعَرْشِ الْكَرِيمِ',
      translation: 'There is no god but Allah, the Mighty, the Forbearing...',
      source: 'متفق عليه',
      category: 'تفريج هموم',
    ),
    _Dua(
      id: 10,
      title: 'دعاء السفر',
      arabicText: 'اللَّهُمَّ إِنَّا نَسْأَلُكَ فِي سَفَرِنَا هَذَا الْبِرَّ وَالتَّقْوَى، وَمِنَ الْعَمَلِ مَا تَرْضَى',
      translation: 'O Allah, we ask You on this journey for goodness and piety.',
      source: 'رواه مسلم',
      category: 'حماية',
    ),
  ];

  List<_Dua> get _filteredDuas => _selectedCategory == 'الكل'
      ? _duas
      : _duas.where((d) => d.category == _selectedCategory).toList();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('الأدعية')),
      body: Column(
        children: [
          // Category filter
          SizedBox(
            height: 52,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: _categories.length,
              itemBuilder: (context, i) {
                final cat = _categories[i];
                final isSelected = cat == _selectedCategory;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.gold.withOpacity(0.2)
                          : isDark ? AppColors.darkCard : AppColors.lightCard,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? AppColors.gold : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Text(
                      cat,
                      style: TextStyle(
                        color: isSelected ? AppColors.gold : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                        fontSize: 13,
                        fontFamily: 'Amiri',
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Duas list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _filteredDuas.length,
              itemBuilder: (context, i) => _DuaCard(
                dua: _filteredDuas[i],
                isDark: isDark,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DuaDetailScreen(dua: _filteredDuas[i]),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================

class _DuaCard extends StatelessWidget {
  final _Dua dua;
  final bool isDark;
  final VoidCallback onTap;
  const _DuaCard({required this.dua, required this.isDark, required this.onTap});

  static const _categoryColors = {
    'رزق': Color(0xFF5C3A1E),
    'شفاء': Color(0xFF1A4A2A),
    'تفريج هموم': Color(0xFF1A2A5C),
    'حماية': Color(0xFF4A1A2A),
    'هداية': Color(0xFF3A3A1A),
    'زواج': Color(0xFF3A1A4A),
    'نجاح': Color(0xFF1A4A4A),
  };

  @override
  Widget build(BuildContext context) {
    final color = _categoryColors[dua.category] ?? AppColors.accentBlue;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: color.withOpacity(0.4)),
                  ),
                  child: Text(
                    dua.category,
                    style: TextStyle(color: color.withOpacity(0.9), fontSize: 11, fontFamily: 'Amiri'),
                  ),
                ),
                Text(
                  dua.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Amiri',
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              dua.arabicText,
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Uthmanic',
                color: isDark ? AppColors.darkText : AppColors.lightText,
                height: 1.8,
              ),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.chevron_left, color: AppColors.gold, size: 20),
                if (dua.source != null)
                  Text(
                    dua.source!,
                    style: const TextStyle(color: AppColors.gold, fontSize: 11, fontFamily: 'Amiri'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================

class DuaDetailScreen extends StatefulWidget {
  final _Dua dua;
  const DuaDetailScreen({super.key, required this.dua});
  @override
  State<DuaDetailScreen> createState() => _DuaDetailScreenState();
}

class _DuaDetailScreenState extends State<DuaDetailScreen> {
  bool _isFavorite = false;
  bool _showTranslation = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dua.title),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
              color: _isFavorite ? AppColors.gold : null,
            ),
            onPressed: () => setState(() => _isFavorite = !_isFavorite),
          ),
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: () {
              // Share dua
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Main dua card
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: isDark
                        ? [const Color(0xFF1B3A2D), const Color(0xFF0A1520)]
                        : [const Color(0xFFE8F5EC), const Color(0xFFF0EBE0)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.gold.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Decorative top
                      Text('﷽', style: TextStyle(fontSize: 24, color: AppColors.gold, fontFamily: 'Uthmanic')),
                      const SizedBox(height: 24),

                      // Arabic text
                      Text(
                        widget.dua.arabicText,
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Uthmanic',
                          color: isDark ? AppColors.darkText : AppColors.lightText,
                          height: 2.0,
                        ),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                      ),

                      // Translation toggle
                      if (widget.dua.translation != null) ...[
                        const SizedBox(height: 20),
                        TextButton.icon(
                          icon: Icon(
                            _showTranslation ? Icons.visibility_off : Icons.visibility,
                            size: 18,
                          ),
                          label: Text(
                            _showTranslation ? 'إخفاء الترجمة' : 'عرض الترجمة',
                            style: const TextStyle(fontFamily: 'Amiri'),
                          ),
                          onPressed: () => setState(() => _showTranslation = !_showTranslation),
                          style: TextButton.styleFrom(foregroundColor: AppColors.gold),
                        ),
                        if (_showTranslation)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.gold.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.gold.withOpacity(0.2)),
                            ),
                            child: Text(
                              widget.dua.translation!,
                              style: TextStyle(
                                fontSize: 15,
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                height: 1.6,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],

                      if (widget.dua.source != null) ...[
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.book, size: 14, color: AppColors.gold),
                            const SizedBox(width: 4),
                            Text(
                              widget.dua.source!,
                              style: const TextStyle(
                                color: AppColors.gold,
                                fontSize: 13,
                                fontFamily: 'Amiri',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.copy_rounded, size: 18),
                    label: const Text('نسخ', style: TextStyle(fontFamily: 'Amiri', fontSize: 15)),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: widget.dua.arabicText));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('تم نسخ الدعاء ✅', textDirection: TextDirection.rtl),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gold.withOpacity(0.15),
                      foregroundColor: AppColors.gold,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: const BorderSide(color: AppColors.gold, width: 1),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.share_rounded, size: 18),
                    label: const Text('مشاركة', style: TextStyle(fontFamily: 'Amiri', fontSize: 15)),
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gold,
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================

class _Dua {
  final int id;
  final String title;
  final String arabicText;
  final String? translation;
  final String? source;
  final String category;

  const _Dua({
    required this.id,
    required this.title,
    required this.arabicText,
    this.translation,
    this.source,
    required this.category,
  });
}
