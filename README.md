# 🌙 نور الإسلام - Islamic App

تطبيق إسلامي متكامل مبني بـ Flutter يعمل على Android, iOS, و Web.

---

## ✨ المميزات

| القسم | المميزات |
|-------|----------|
| 📖 القرآن الكريم | قراءة كاملة، تلاوة صوتية، تحديد آيات، مفضلة، تحميل للأوفلاين |
| 📿 الأذكار | أذكار الصباح والمساء والنوم وبعد الصلاة، عداد ذكي |
| 🔁 السبحة الرقمية | عداد مع اهتزاز، مؤشر دائري، أهداف مخصصة |
| 🤲 الأدعية | تصنيفات متعددة، نسخ ومشاركة، ترجمة |
| ⏰ التنبيهات | تذكيرات دورية تعمل في الخلفية |
| 🎧 مشغل الصوت | تلاوة كاملة، اختيار القارئ، شريط تقدم |
| ⭐ المفضلة | حفظ آيات وأذكار وأدعية |
| ⚙️ الإعدادات | وضع ليلي/نهاري، حجم الخط، نوع الخط |

---

## 🚀 تثبيت وتشغيل المشروع

### المتطلبات

```bash
Flutter SDK >= 3.10.0
Dart SDK >= 3.0.0
Android Studio / VS Code
```

### خطوات التثبيت

```bash
# 1. استنسخ المشروع
git clone https://github.com/your-repo/islamic_app.git
cd islamic_app

# 2. ثبّت الحزم
flutter pub get

# 3. نفّذ code generation (للـ Hive models)
flutter pub run build_runner build --delete-conflicting-outputs

# 4. شغّل التطبيق
# Android
flutter run -d android

# iOS
flutter run -d ios

# Web
flutter run -d chrome

# Build release
flutter build apk --release        # Android APK
flutter build appbundle --release  # Android App Bundle
flutter build ios --release        # iOS
flutter build web --release        # Web
```

---

## 📁 هيكل المشروع

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart       # ثوابت التطبيق
│   └── theme/
│       └── app_theme.dart           # الثيمات (Dark/Light)
│
├── data/
│   ├── models/
│   │   └── surah_model.dart         # موديلات البيانات
│   ├── datasources/
│   │   ├── local/
│   │   │   ├── database_service.dart    # SQLite
│   │   │   ├── audio_player_service.dart
│   │   │   └── notification_service.dart
│   │   └── remote/
│   │       └── quran_api_service.dart   # API calls
│   └── repositories/
│       └── quran_repository.dart        # Data layer
│
└── presentation/
    ├── blocs/
    │   ├── quran_bloc.dart          # Quran state management
    │   └── settings_bloc.dart       # Settings state management
    └── screens/
        ├── home/home_screen.dart
        ├── quran/
        │   ├── surah_list_screen.dart
        │   └── surah_detail_screen.dart
        ├── azkar/azkar_screen.dart
        ├── tasbeeh/tasbeeh_screen.dart
        ├── dua/dua_screen.dart
        ├── favorites/favorites_screen.dart
        └── settings/settings_screen.dart
```

---

## 🎨 تنزيل الخطوط العربية

يجب تنزيل الخطوط العربية ووضعها في `assets/fonts/`:

```bash
# Uthmanic Hafs (الخط العثماني)
https://fonts.qurancomplex.gov.sa/

# Amiri Font
https://fonts.google.com/specimen/Amiri

# Scheherazade New
https://fonts.google.com/specimen/Scheherazade+New
```

**الملفات المطلوبة:**
```
assets/fonts/
├── UthmanicHafs.ttf
├── Amiri-Regular.ttf
├── Amiri-Bold.ttf
├── ScheherazadeNew-Regular.ttf
└── ScheherazadeNew-Bold.ttf
```

---

## 🔧 API المستخدمة

| API | الغرض | رابط |
|-----|-------|------|
| AlQuran Cloud | نصوص القرآن | https://api.alquran.cloud/v1 |
| Islamic Network CDN | الصوتيات | https://cdn.islamic.network/quran/audio |
| Quranic Audio | تلاوة كاملة | https://download.quranicaudio.com |

---

## 🏗️ المعمارية

```
Clean Architecture + BLoC Pattern

Presentation Layer (UI + BLoC)
        ↓
Domain Layer (Use Cases)
        ↓  
Data Layer (Repository + DataSources)
        ↓
Local (SQLite + Hive) / Remote (HTTP)
```

---

## 📱 الأجهزة المدعومة

- ✅ **Android** 5.0+ (API 21+)
- ✅ **iOS** 12.0+
- ✅ **Web** (Chrome, Firefox, Safari)
- ✅ **وضع أوفلاين كامل** بعد التحميل الأول

---

## 📲 إضافات مستقبلية

- [ ] قارئ الصفحات (Page View Mode)
- [ ] إحصائيات القراءة
- [ ] مشاركة آية كصورة
- [ ] Widget للشاشة الرئيسية
- [ ] دعم أكثر من لغة
- [ ] بث مباشر للقرآن

---

## 🤝 المساهمة

Pull requests مرحب بها! للتغييرات الكبيرة، يرجى فتح issue أولاً.

---

## 📄 الرخصة

MIT License - استخدام حر لأغراض إسلامية 🌙
