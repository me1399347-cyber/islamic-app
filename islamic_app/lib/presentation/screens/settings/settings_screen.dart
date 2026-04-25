// lib/presentation/screens/settings/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/settings_bloc.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/datasources/local/notification_service.dart';
import '../../../data/models/surah_model.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _notificationService = NotificationService();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settings) {
        return Scaffold(
          appBar: AppBar(title: const Text('الإعدادات')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ---- Appearance ----
              _SectionHeader('المظهر', Icons.palette_rounded),
              _SettingCard(isDark: isDark, children: [
                _SwitchTile(
                  title: 'الوضع الليلي',
                  subtitle: 'تفعيل المظهر الداكن',
                  icon: Icons.dark_mode_rounded,
                  value: settings.isDarkMode,
                  onChanged: (_) => context.read<SettingsBloc>().add(ToggleDarkModeEvent()),
                ),
                const Divider(height: 1),
                _SliderTile(
                  title: 'حجم الخط',
                  icon: Icons.text_fields_rounded,
                  value: settings.fontSize,
                  min: AppConstants.minFontSize,
                  max: AppConstants.maxFontSize,
                  onChanged: (v) => context.read<SettingsBloc>().add(ChangeFontSizeEvent(v)),
                  preview: Text(
                    'بِسْمِ اللَّهِ',
                    style: TextStyle(
                      fontSize: settings.fontSize * 0.7,
                      fontFamily: settings.fontFamily,
                      color: AppColors.gold,
                    ),
                  ),
                ),
                const Divider(height: 1),
                _DropdownTile(
                  title: 'نوع الخط',
                  icon: Icons.font_download_rounded,
                  value: settings.fontFamily,
                  options: AppConstants.arabicFonts,
                  onChanged: (v) {
                    if (v != null) {
                      context.read<SettingsBloc>().add(ChangeFontFamilyEvent(v));
                    }
                  },
                ),
              ]),

              const SizedBox(height: 16),

              // ---- Audio ----
              _SectionHeader('الصوت', Icons.headphones_rounded),
              _SettingCard(isDark: isDark, children: [
                _DropdownTile(
                  title: 'القارئ الافتراضي',
                  icon: Icons.record_voice_over_rounded,
                  value: settings.defaultReciter,
                  options: AppConstants.reciters.keys.toList(),
                  labels: AppConstants.reciters.values.toList(),
                  onChanged: (v) {
                    if (v != null) {
                      context.read<SettingsBloc>().add(ChangeReciterEvent(v));
                    }
                  },
                ),
              ]),

              const SizedBox(height: 16),

              // ---- Notifications ----
              _SectionHeader('التنبيهات', Icons.notifications_rounded),
              _SettingCard(isDark: isDark, children: [
                _SwitchTile(
                  title: 'التذكيرات الإسلامية',
                  subtitle: 'تفعيل إشعارات الأذكار',
                  icon: Icons.notifications_active_rounded,
                  value: settings.remindersEnabled,
                  onChanged: (_) => context.read<SettingsBloc>().add(ToggleRemindersEvent()),
                ),
                const Divider(height: 1),
                _SwitchTile(
                  title: 'الاهتزاز',
                  subtitle: 'اهتزاز عند العدّ',
                  icon: Icons.vibration_rounded,
                  value: settings.vibrationEnabled,
                  onChanged: (_) => context.read<SettingsBloc>().add(ToggleVibrationEvent()),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.alarm_add_rounded, color: AppColors.gold),
                  title: const Text('إضافة تذكير', style: TextStyle(fontFamily: 'Amiri')),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showAddReminderDialog(context),
                ),
              ]),

              const SizedBox(height: 16),

              // ---- Quran ----
              _SectionHeader('القرآن الكريم', Icons.menu_book_rounded),
              _SettingCard(isDark: isDark, children: [
                _SwitchTile(
                  title: 'عرض الترجمة',
                  subtitle: 'إظهار الترجمة الإنجليزية',
                  icon: Icons.translate_rounded,
                  value: settings.showTranslation,
                  onChanged: (_) => context.read<SettingsBloc>().add(ToggleTranslationEvent()),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.download_rounded, color: AppColors.gold),
                  title: const Text('إدارة التنزيلات', style: TextStyle(fontFamily: 'Amiri')),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ]),

              const SizedBox(height: 16),

              // ---- About ----
              _SectionHeader('عن التطبيق', Icons.info_rounded),
              _SettingCard(isDark: isDark, children: [
                ListTile(
                  leading: const Icon(Icons.app_settings_alt_rounded, color: AppColors.gold),
                  title: const Text('الإصدار', style: TextStyle(fontFamily: 'Amiri')),
                  trailing: const Text('1.0.0', style: TextStyle(color: AppColors.gold)),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.star_rounded, color: AppColors.gold),
                  title: const Text('قيّم التطبيق', style: TextStyle(fontFamily: 'Amiri')),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.share_rounded, color: AppColors.gold),
                  title: const Text('مشاركة التطبيق', style: TextStyle(fontFamily: 'Amiri')),
                  onTap: () {},
                ),
              ]),

              const SizedBox(height: 80),
            ],
          ),
        );
      },
    );
  }

  void _showAddReminderDialog(BuildContext context) {
    int selectedInterval = 30;
    String selectedMessage = AppConstants.defaultReminders.first;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.darkSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setS) => Padding(
          padding: EdgeInsets.only(
            left: 20, right: 20, top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('إضافة تذكير',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Amiri',
                    color: AppColors.gold,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center),
              const SizedBox(height: 20),

              const Text('الرسالة:', style: TextStyle(fontFamily: 'Amiri', color: AppColors.darkTextMuted)),
              const SizedBox(height: 8),
              ...AppConstants.defaultReminders.map((msg) => RadioListTile<String>(
                    title: Text(msg, textDirection: TextDirection.rtl,
                        style: const TextStyle(fontFamily: 'Amiri')),
                    value: msg,
                    groupValue: selectedMessage,
                    activeColor: AppColors.gold,
                    onChanged: (v) => setS(() => selectedMessage = v!),
                  )),

              const SizedBox(height: 12),
              const Text('التكرار:', style: TextStyle(fontFamily: 'Amiri', color: AppColors.darkTextMuted)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: AppConstants.reminderIntervals.map((mins) {
                  final label = mins >= 60 ? '${mins ~/ 60} ساعة' : '$mins دقيقة';
                  return ChoiceChip(
                    label: Text(label, style: const TextStyle(fontFamily: 'Amiri')),
                    selected: selectedInterval == mins,
                    selectedColor: AppColors.gold.withOpacity(0.3),
                    onSelected: (_) => setS(() => selectedInterval = mins),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await _notificationService.schedulePeriodicReminder(
                    id: DateTime.now().millisecondsSinceEpoch % 1000000,
                    message: selectedMessage,
                    intervalMinutes: selectedInterval,
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم إضافة التذكير ✅', textDirection: TextDirection.rtl)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('حفظ التذكير', style: TextStyle(fontFamily: 'Amiri', fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionHeader(this.title, this.icon);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, right: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(title, style: const TextStyle(
            color: AppColors.gold,
            fontSize: 16,
            fontFamily: 'Amiri',
            fontWeight: FontWeight.bold,
          )),
          const SizedBox(width: 8),
          Icon(icon, color: AppColors.gold, size: 20),
        ],
      ),
    );
  }
}

class _SettingCard extends StatelessWidget {
  final List<Widget> children;
  final bool isDark;
  const _SettingCard({required this.children, required this.isDark});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
        child: Column(children: children),
      );
}

class _SwitchTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool value;
  final Function(bool) onChanged;
  const _SwitchTile({required this.title, required this.subtitle, required this.icon, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) => SwitchListTile(
        title: Text(title, textDirection: TextDirection.rtl, style: const TextStyle(fontFamily: 'Amiri')),
        subtitle: Text(subtitle, textDirection: TextDirection.rtl, style: const TextStyle(fontSize: 12)),
        secondary: Icon(icon, color: AppColors.gold),
        value: value,
        activeColor: AppColors.gold,
        onChanged: onChanged,
      );
}

class _SliderTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final double value;
  final double min, max;
  final Function(double) onChanged;
  final Widget? preview;
  const _SliderTile({required this.title, required this.icon, required this.value, required this.min, required this.max, required this.onChanged, this.preview});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (preview != null) preview!,
                Row(children: [
                  Text(title, style: const TextStyle(fontFamily: 'Amiri')),
                  const SizedBox(width: 8),
                  Icon(icon, color: AppColors.gold),
                ]),
              ],
            ),
            Slider(
              value: value,
              min: min,
              max: max,
              divisions: 10,
              label: '${value.round()}',
              activeColor: AppColors.gold,
              onChanged: onChanged,
            ),
          ],
        ),
      );
}

class _DropdownTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final String value;
  final List<String> options;
  final List<String>? labels;
  final Function(String?) onChanged;
  const _DropdownTile({required this.title, required this.icon, required this.value, required this.options, this.labels, required this.onChanged});

  @override
  Widget build(BuildContext context) => ListTile(
        leading: Icon(icon, color: AppColors.gold),
        title: Text(title, textDirection: TextDirection.rtl, style: const TextStyle(fontFamily: 'Amiri')),
        trailing: DropdownButton<String>(
          value: value,
          underline: const SizedBox(),
          items: options.asMap().entries.map((e) => DropdownMenuItem(
                value: e.value,
                child: Text(
                  labels != null ? labels![e.key] : e.value,
                  style: const TextStyle(fontFamily: 'Amiri', fontSize: 13),
                ),
              )).toList(),
          onChanged: onChanged,
        ),
      );
}
