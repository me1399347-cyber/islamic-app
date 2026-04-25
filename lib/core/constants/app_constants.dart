// lib/core/constants/app_constants.dart

class AppConstants {
  // App Info
  static const String appName = 'نور الإسلام';
  static const String appVersion = '1.0.0';

  // API
  static const String quranApiBase = 'https://api.alquran.cloud/v1';
  static const String audioBase = 'https://cdn.islamic.network/quran/audio';
  static const String azkarApiBase = 'https://raw.githubusercontent.com/nawafalqari/azkar-api/main/azkar.json';

  // Reciters
  static const Map<String, String> reciters = {
    'ar.alafasy': 'مشاري العفاسي',
    'ar.abdurrahmaansudais': 'عبدالرحمن السديس',
    'ar.husary': 'محمود خليل الحصري',
    'ar.minshawi': 'محمد صديق المنشاوي',
    'ar.abdullahbasfar': 'عبدالله بصفر',
    'ar.mahermuaiqly': 'ماهر المعيقلي',
  };
  static const String defaultReciter = 'ar.alafasy';

  // Database
  static const String dbName = 'islamic_app.db';
  static const int dbVersion = 1;

  // Hive Boxes
  static const String settingsBox = 'settings';
  static const String favoritesBox = 'favorites';
  static const String tasbeehBox = 'tasbeeh';
  static const String bookmarksBox = 'bookmarks';
  static const String downloadedBox = 'downloaded';

  // Notification Channels
  static const String reminderChannelId = 'islamic_reminder';
  static const String reminderChannelName = 'التذكيرات الإسلامية';
  static const String adhanChannelId = 'adhan_channel';

  // Reminder Intervals (minutes)
  static const List<int> reminderIntervals = [15, 30, 60, 120];

  // Default Reminders
  static const List<String> defaultReminders = [
    'صلّي على محمد ﷺ ❤️',
    'استغفر الله العظيم 🤲',
    'سبحان الله وبحمده',
    'لا إله إلا الله',
    'الحمد لله على كل حال',
    'اللهم صل على محمد',
  ];

  // Font Sizes
  static const double minFontSize = 16.0;
  static const double maxFontSize = 36.0;
  static const double defaultFontSize = 22.0;

  // Font Families
  static const List<String> arabicFonts = [
    'Uthmanic',
    'Amiri',
    'Scheherazade',
  ];
  static const String defaultFont = 'Uthmanic';

  // Tasbeeh Options
  static const List<Map<String, dynamic>> tasbeehOptions = [
    {'text': 'سبحان الله', 'target': 33},
    {'text': 'الحمد لله', 'target': 33},
    {'text': 'الله أكبر', 'target': 33},
    {'text': 'لا إله إلا الله', 'target': 100},
    {'text': 'أستغفر الله', 'target': 100},
    {'text': 'صلى الله على محمد', 'target': 100},
    {'text': 'لا حول ولا قوة إلا بالله', 'target': 33},
  ];
}
