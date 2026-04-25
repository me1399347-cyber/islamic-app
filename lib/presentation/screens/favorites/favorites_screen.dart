// lib/presentation/screens/favorites/favorites_screen.dart

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/datasources/local/database_service.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _db = DatabaseService();
  List<Map<String, dynamic>> _ayahs = [];
  List<Map<String, dynamic>> _azkar = [];
  List<Map<String, dynamic>> _duas = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadFavorites();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadFavorites() async {
    setState(() => _loading = true);
    final ayahs = await _db.getFavorites('ayah');
    final azkar = await _db.getFavorites('zikr');
    final duas = await _db.getFavorites('dua');
    setState(() {
      _ayahs = ayahs;
      _azkar = azkar;
      _duas = duas;
      _loading = false;
    });
  }

  Future<void> _removeAyah(int itemId) async {
    await _db.removeFavorite('ayah', itemId);
    await _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('المفضلة'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.gold,
          unselectedLabelColor: AppColors.darkTextMuted,
          indicatorColor: AppColors.gold,
          tabs: const [
            Tab(text: 'آيات'),
            Tab(text: 'أذكار'),
            Tab(text: 'أدعية'),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildAyahsList(isDark),
                _buildAzkarList(isDark),
                _buildDuasList(isDark),
              ],
            ),
    );
  }

  Widget _buildAyahsList(bool isDark) {
    if (_ayahs.isEmpty) return _buildEmpty('لا توجد آيات في المفضلة', Icons.menu_book_rounded);
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _ayahs.length,
      itemBuilder: (context, i) {
        final data = _ayahs[i]['item_data'] as Map<String, dynamic>;
        return _FavoriteCard(
          isDark: isDark,
          onDelete: () => _removeAyah(_ayahs[i]['item_id'] as int),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'سورة ${data['surahNumber']} - آية ${data['numberInSurah']}',
                    style: const TextStyle(color: AppColors.gold, fontSize: 12, fontFamily: 'Amiri'),
                  ),
                  const Icon(Icons.format_quote_rounded, color: AppColors.gold, size: 20),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                data['text'] as String,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Uthmanic',
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                  height: 1.9,
                ),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAzkarList(bool isDark) {
    if (_azkar.isEmpty) return _buildEmpty('لا توجد أذكار في المفضلة', Icons.wb_sunny_rounded);
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _azkar.length,
      itemBuilder: (context, i) {
        final data = _azkar[i]['item_data'] as Map<String, dynamic>;
        return _FavoriteCard(
          isDark: isDark,
          onDelete: () async {
            await _db.removeFavorite('zikr', _azkar[i]['item_id'] as int);
            await _loadFavorites();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    data['category'] as String? ?? '',
                    style: const TextStyle(color: AppColors.gold, fontSize: 12, fontFamily: 'Amiri'),
                  ),
                  const Icon(Icons.auto_awesome, color: AppColors.gold, size: 18),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                data['text'] as String,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Uthmanic',
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                  height: 1.9,
                ),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDuasList(bool isDark) {
    if (_duas.isEmpty) return _buildEmpty('لا توجد أدعية في المفضلة', Icons.volunteer_activism_rounded);
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _duas.length,
      itemBuilder: (context, i) {
        final data = _duas[i]['item_data'] as Map<String, dynamic>;
        return _FavoriteCard(
          isDark: isDark,
          onDelete: () async {
            await _db.removeFavorite('dua', _duas[i]['item_id'] as int);
            await _loadFavorites();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    data['category'] as String? ?? '',
                    style: const TextStyle(color: AppColors.gold, fontSize: 12, fontFamily: 'Amiri'),
                  ),
                  Text(
                    data['title'] as String? ?? '',
                    style: TextStyle(
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                      fontFamily: 'Amiri',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                data['text'] as String,
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Uthmanic',
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                  height: 1.9,
                ),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmpty(String msg, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppColors.darkTextMuted),
          const SizedBox(height: 16),
          Text(
            msg,
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

class _FavoriteCard extends StatelessWidget {
  final Widget child;
  final bool isDark;
  final VoidCallback onDelete;

  const _FavoriteCard({
    required this.child,
    required this.isDark,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.red),
      ),
      onDismissed: (_) => onDelete(),
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
        child: child,
      ),
    );
  }
}
