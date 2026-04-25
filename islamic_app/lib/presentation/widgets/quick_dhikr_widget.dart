// lib/presentation/widgets/quick_dhikr_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import '../../core/theme/app_theme.dart';

class QuickDhikrWidget extends StatefulWidget {
  const QuickDhikrWidget({super.key});
  @override
  State<QuickDhikrWidget> createState() => _QuickDhikrWidgetState();
}

class _QuickDhikrWidgetState extends State<QuickDhikrWidget>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  int _counter = 0;
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  static const _dhikrList = [
    _QuickDhikr('سُبْحَانَ اللَّهِ', 'Subhan Allah', 33),
    _QuickDhikr('الْحَمْدُ لِلَّهِ', 'Alhamdulillah', 33),
    _QuickDhikr('اللَّهُ أَكْبَرُ', 'Allahu Akbar', 34),
    _QuickDhikr('أَسْتَغْفِرُ اللَّهَ', 'Astaghfirullah', 100),
    _QuickDhikr('لَا إِلَهَ إِلَّا اللَّهُ', 'La ilaha illa Allah', 100),
    _QuickDhikr('اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ', 'Allahumma Salli ala Muhammad', 100),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _next() {
    _animController.reverse().then((_) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _dhikrList.length;
        _counter = 0;
      });
      _animController.forward();
    });
  }

  void _previous() {
    _animController.reverse().then((_) {
      setState(() {
        _currentIndex = (_currentIndex - 1 + _dhikrList.length) % _dhikrList.length;
        _counter = 0;
      });
      _animController.forward();
    });
  }

  void _random() {
    _animController.reverse().then((_) {
      setState(() {
        _currentIndex = Random().nextInt(_dhikrList.length);
        _counter = 0;
      });
      _animController.forward();
    });
  }

  void _increment() {
    HapticFeedback.selectionClick();
    setState(() {
      _counter++;
      if (_counter >= _dhikrList[_currentIndex].target) {
        _counter = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dhikr = _dhikrList[_currentIndex];
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progress = _counter / dhikr.target;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: isDark
              ? [const Color(0xFF1B3A2D), const Color(0xFF0A1520)]
              : [const Color(0xFFE8F5EC), const Color(0xFFF0EBE0)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gold.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.shuffle_rounded, size: 20),
                onPressed: _random,
                color: AppColors.gold,
                padding: EdgeInsets.zero,
              ),
              const Text(
                '⚡ الذكر السريع',
                style: TextStyle(
                  color: AppColors.gold,
                  fontFamily: 'Amiri',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Text(
                    '${_currentIndex + 1}/${_dhikrList.length}',
                    style: const TextStyle(
                      color: AppColors.darkTextMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Dhikr text
          FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                Text(
                  dhikr.arabic,
                  style: TextStyle(
                    fontSize: 26,
                    fontFamily: 'Uthmanic',
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                    height: 1.8,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  dhikr.transliteration,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.darkTextMuted,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Progress
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$_counter',
                style: const TextStyle(
                  color: AppColors.gold,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                ' / ${dhikr.target}',
                style: const TextStyle(
                  color: AppColors.darkTextMuted,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: AppColors.darkBorder,
              color: AppColors.gold,
            ),
          ),

          const SizedBox(height: 16),

          // Counter button + navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: _previous,
                color: AppColors.darkTextMuted,
              ),
              GestureDetector(
                onTap: _increment,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [AppColors.gold, AppColors.goldDark],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gold.withOpacity(0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'اضغط',
                      style: TextStyle(
                        color: Colors.black87,
                        fontFamily: 'Amiri',
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: _next,
                color: AppColors.darkTextMuted,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickDhikr {
  final String arabic;
  final String transliteration;
  final int target;
  const _QuickDhikr(this.arabic, this.transliteration, this.target);
}

// ================================================================
// Reusable Islamic decorative divider
// ================================================================

class IslamicDivider extends StatelessWidget {
  final double width;
  const IslamicDivider({super.key, this.width = 120});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(width: width / 2, height: 1, color: AppColors.gold.withOpacity(0.3)),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: const Text('✦', style: TextStyle(color: AppColors.gold, fontSize: 14)),
        ),
        Container(width: width / 2, height: 1, color: AppColors.gold.withOpacity(0.3)),
      ],
    );
  }
}

// ================================================================
// Loading shimmer widget
// ================================================================

class IslamicLoadingWidget extends StatelessWidget {
  final String message;
  const IslamicLoadingWidget({super.key, this.message = 'جاري التحميل...'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('☪️', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 20),
          const CircularProgressIndicator(
            color: AppColors.gold,
            strokeWidth: 3,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              color: AppColors.darkTextMuted,
              fontFamily: 'Amiri',
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// Error widget
// ================================================================

class IslamicErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  const IslamicErrorWidget({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 64, color: AppColors.darkTextMuted),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(
                color: AppColors.darkTextMuted,
                fontFamily: 'Amiri',
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('إعادة المحاولة', style: TextStyle(fontFamily: 'Amiri')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  foregroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
