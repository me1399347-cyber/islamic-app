// lib/presentation/screens/tasbeeh/tasbeeh_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import 'dart:math' as math;

class TasbeehScreen extends StatefulWidget {
  const TasbeehScreen({super.key});
  @override
  State<TasbeehScreen> createState() => _TasbeehScreenState();
}

class _TasbeehScreenState extends State<TasbeehScreen>
    with SingleTickerProviderStateMixin {
  int _count = 0;
  int _selectedIndex = 0;
  bool _vibrationEnabled = true;
  int _totalCount = 0;
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _count = prefs.getInt('tasbeeh_count_$_selectedIndex') ?? 0;
      _totalCount = prefs.getInt('tasbeeh_total') ?? 0;
    });
  }

  Future<void> _saveCount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('tasbeeh_count_$_selectedIndex', _count);
    await prefs.setInt('tasbeeh_total', _totalCount);
  }

  void _increment() async {
    // Haptic feedback
    HapticFeedback.lightImpact();
    if (_vibrationEnabled && (await Vibration.hasVibrator() ?? false)) {
      Vibration.vibrate(duration: 25);
    }

    // Animation
    _animController.forward().then((_) => _animController.reverse());

    setState(() {
      _count++;
      _totalCount++;
      // Auto-reset at target
      final target = AppConstants.tasbeehOptions[_selectedIndex]['target'] as int;
      if (_count >= target) {
        _count = 0;
      }
    });
    await _saveCount();
  }

  void _reset() async {
    setState(() => _count = 0);
    await _saveCount();
    HapticFeedback.mediumImpact();
  }

  void _changeTasbeeh(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getInt('tasbeeh_count_$index') ?? 0;
    setState(() {
      _selectedIndex = index;
      _count = saved;
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final option = AppConstants.tasbeehOptions[_selectedIndex];
    final target = option['target'] as int;
    final progress = _count / target;
    final text = option['text'] as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text('السبحة الرقمية'),
        actions: [
          IconButton(
            icon: Icon(
              _vibrationEnabled ? Icons.vibration : Icons.phone_android,
              color: _vibrationEnabled ? AppColors.gold : AppColors.darkTextMuted,
            ),
            onPressed: () => setState(() => _vibrationEnabled = !_vibrationEnabled),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Tasbeeh selector
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                reverse: true,
                itemCount: AppConstants.tasbeehOptions.length,
                itemBuilder: (context, i) {
                  final opt = AppConstants.tasbeehOptions[i];
                  final isSelected = i == _selectedIndex;
                  return GestureDetector(
                    onTap: () => _changeTasbeeh(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.gold.withOpacity(0.2)
                            : isDark ? AppColors.darkCard : AppColors.lightCard,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? AppColors.gold : AppColors.darkBorder,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Text(
                        opt['text'] as String,
                        style: TextStyle(
                          color: isSelected ? AppColors.gold : AppColors.darkTextMuted,
                          fontSize: 13,
                          fontFamily: 'Amiri',
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            // Circular progress
            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background circle
                    CustomPaint(
                      size: const Size(280, 280),
                      painter: _CircularProgressPainter(
                        progress: progress,
                        bgColor: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        fgColor: AppColors.gold,
                      ),
                    ),

                    // Count button
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: GestureDetector(
                        onTap: _increment,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                AppColors.gold.withOpacity(0.3),
                                AppColors.goldDark.withOpacity(0.1),
                              ],
                            ),
                            border: Border.all(
                              color: AppColors.gold.withOpacity(0.5),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.gold.withOpacity(0.2),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                text,
                                style: TextStyle(
                                  color: AppColors.gold,
                                  fontSize: 18,
                                  fontFamily: 'Uthmanic',
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '$_count',
                                style: TextStyle(
                                  color: isDark ? AppColors.darkText : AppColors.lightText,
                                  fontSize: 56,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'من $target',
                                style: const TextStyle(
                                  color: AppColors.gold,
                                  fontSize: 16,
                                  fontFamily: 'Amiri',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Stats row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatCard('الجلسة', '$_count', isDark),
                _StatCard('الإجمالي', '$_totalCount', isDark),
                _StatCard('الهدف', '$target', isDark),
              ],
            ),

            const SizedBox(height: 20),

            // Reset button
            TextButton.icon(
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('إعادة تعيين', style: TextStyle(fontFamily: 'Amiri', fontSize: 16)),
              onPressed: _reset,
              style: TextButton.styleFrom(foregroundColor: AppColors.darkTextMuted),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  const _StatCard(this.label, this.value, this.isDark);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(color: AppColors.gold, fontSize: 22, fontWeight: FontWeight.bold)),
          Text(label,
              style: TextStyle(
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                fontSize: 12,
                fontFamily: 'Amiri',
              )),
        ],
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color bgColor;
  final Color fgColor;

  _CircularProgressPainter({
    required this.progress,
    required this.bgColor,
    required this.fgColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    const startAngle = -math.pi / 2;

    // Background
    final bgPaint = Paint()
      ..color = bgColor
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress
    final fgPaint = Paint()
      ..color = fgColor
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: startAngle,
        endAngle: startAngle + 2 * math.pi * progress,
        colors: [fgColor, fgColor.withOpacity(0.6)],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      2 * math.pi * progress,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(_CircularProgressPainter old) =>
      old.progress != progress;
}
