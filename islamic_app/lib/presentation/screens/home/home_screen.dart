// lib/presentation/screens/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../blocs/settings_bloc.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _randomDhikr = '';

  final List<String> _dhikrList = [
    'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
    'لَا إِلَهَ إِلَّا اللَّهُ',
    'اللَّهُ أَكْبَرُ',
    'سُبْحَانَ اللَّهِ الْعَظِيمِ',
    'أَسْتَغْفِرُ اللَّهَ الْعَظِيمَ',
    'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
    'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ',
    'سُبْحَانَ اللَّهِ وَالْحَمْدُ لِلَّهِ وَلَا إِلَهَ إِلَّا اللَّهُ وَاللَّهُ أَكْبَرُ',
  ];

  @override
  void initState() {
    super.initState();
    _getRandomDhikr();
  }

  void _getRandomDhikr() {
    final rand = Random();
    setState(() {
      _randomDhikr = _dhikrList[rand.nextInt(_dhikrList.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsBloc>().state;
    final isDark = settings.isDarkMode;
    final now = DateTime.now();
    final greeting = _getGreeting(now.hour);
    final dateStr = DateFormat('EEEE، d MMMM yyyy', 'ar').format(now);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ---- Header ----
          SliverAppBar(
            expandedHeight: 220,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [const Color(0xFF1B3A2D), const Color(0xFF0A0F1A)]
                        : [AppColors.primaryGreen, AppColors.primaryGreenLight],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 16),
                        Text(
                          '﷽',
                          style: TextStyle(
                            fontSize: 28,
                            color: AppColors.gold,
                            fontFamily: 'Uthmanic',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          greeting,
                          style: const TextStyle(
                            color: AppColors.goldLight,
                            fontSize: 16,
                            fontFamily: 'Amiri',
                          ),
                        ),
                        Text(
                          dateStr,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 13,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ---- Content ----
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Quick Dhikr Card
                _buildDhikrCard(context, isDark),
                const SizedBox(height: 16),

                // Features Grid
                Text(
                  'الأقسام الرئيسية',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 12),
                _buildFeaturesGrid(context),
                const SizedBox(height: 16),

                // Daily Reminder
                _buildDailyReminderCard(context, isDark),
                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting(int hour) {
    if (hour >= 5 && hour < 12) return 'صباح الخير 🌅';
    if (hour >= 12 && hour < 17) return 'مساء النور ☀️';
    if (hour >= 17 && hour < 20) return 'مساء الخير 🌆';
    return 'تصبح على خير 🌙';
  }

  Widget _buildDhikrCard(BuildContext context, bool isDark) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ذكر اليوم',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.refresh_rounded),
                  onPressed: _getRandomDhikr,
                  color: AppColors.gold,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _randomDhikr,
              style: TextStyle(
                fontSize: 22,
                fontFamily: 'Uthmanic',
                color: isDark ? AppColors.darkText : AppColors.lightText,
                height: 1.8,
              ),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                // Share dhikr
              },
              icon: const Icon(Icons.share_rounded, size: 18),
              label: const Text('مشاركة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                foregroundColor: Colors.black87,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesGrid(BuildContext context) {
    final features = [
      _Feature('القرآن الكريم', Icons.menu_book_rounded, AppColors.primaryGreen, 1),
      _Feature('الأذكار', Icons.wb_sunny_rounded, const Color(0xFF5C4A1E), 2),
      _Feature('السبحة', Icons.rotate_right_rounded, const Color(0xFF1A3A5C), 3),
      _Feature('الأدعية', Icons.volunteer_activism_rounded, const Color(0xFF4A1A3A), 4),
      _Feature('المفضلة', Icons.star_rounded, const Color(0xFF3A1A1A), 5),
      _Feature('التنبيهات', Icons.notifications_rounded, const Color(0xFF1A3A3A), 6),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) => _buildFeatureCard(context, features[index]),
    );
  }

  Widget _buildFeatureCard(BuildContext context, _Feature feature) {
    return GestureDetector(
      onTap: () {
        // Navigate to feature
      },
      child: Container(
        decoration: BoxDecoration(
          color: feature.color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: feature.color.withOpacity(0.3), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: feature.color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(feature.icon, color: feature.color, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              feature.name,
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'Amiri',
                color: feature.color,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyReminderCard(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.gold.withOpacity(0.15),
            AppColors.goldDark.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gold.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const Text('💫', style: TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Text(
            'قال رسول الله ﷺ',
            style: TextStyle(
              color: AppColors.gold,
              fontSize: 14,
              fontFamily: 'Amiri',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'مَن قالَ: سُبْحانَ اللهِ وبِحَمْدِهِ، في يَومٍ مِئَةَ مَرَّةٍ، حُطَّتْ خَطايَاهُ وإنْ كانَتْ مِثْلَ زَبَدِ البَحْرِ',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Uthmanic',
              color: isDark ? AppColors.darkText : AppColors.lightText,
              height: 1.8,
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 8),
          Text(
            'متفق عليه',
            style: TextStyle(
              color: AppColors.goldDark,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _Feature {
  final String name;
  final IconData icon;
  final Color color;
  final int index;
  _Feature(this.name, this.icon, this.color, this.index);
}
