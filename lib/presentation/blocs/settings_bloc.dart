// lib/presentation/blocs/settings_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/models/surah_model.dart';
import '../../core/constants/app_constants.dart';

// ============ EVENTS ============
abstract class SettingsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadSettingsEvent extends SettingsEvent {}

class ToggleDarkModeEvent extends SettingsEvent {}

class ChangeFontSizeEvent extends SettingsEvent {
  final double size;
  ChangeFontSizeEvent(this.size);
  @override
  List<Object?> get props => [size];
}

class ChangeFontFamilyEvent extends SettingsEvent {
  final String fontFamily;
  ChangeFontFamilyEvent(this.fontFamily);
  @override
  List<Object?> get props => [fontFamily];
}

class ChangeReciterEvent extends SettingsEvent {
  final String reciter;
  ChangeReciterEvent(this.reciter);
  @override
  List<Object?> get props => [reciter];
}

class ToggleVibrationEvent extends SettingsEvent {}
class ToggleRemindersEvent extends SettingsEvent {}
class ToggleTranslationEvent extends SettingsEvent {}

// ============ STATE ============
class SettingsState extends Equatable {
  final bool isDarkMode;
  final double fontSize;
  final String fontFamily;
  final String defaultReciter;
  final bool vibrationEnabled;
  final bool remindersEnabled;
  final bool showTranslation;

  const SettingsState({
    this.isDarkMode = true,
    this.fontSize = 22.0,
    this.fontFamily = 'Uthmanic',
    this.defaultReciter = 'ar.alafasy',
    this.vibrationEnabled = true,
    this.remindersEnabled = true,
    this.showTranslation = false,
  });

  SettingsState copyWith({
    bool? isDarkMode,
    double? fontSize,
    String? fontFamily,
    String? defaultReciter,
    bool? vibrationEnabled,
    bool? remindersEnabled,
    bool? showTranslation,
  }) => SettingsState(
        isDarkMode: isDarkMode ?? this.isDarkMode,
        fontSize: fontSize ?? this.fontSize,
        fontFamily: fontFamily ?? this.fontFamily,
        defaultReciter: defaultReciter ?? this.defaultReciter,
        vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
        remindersEnabled: remindersEnabled ?? this.remindersEnabled,
        showTranslation: showTranslation ?? this.showTranslation,
      );

  @override
  List<Object?> get props => [
        isDarkMode, fontSize, fontFamily, defaultReciter,
        vibrationEnabled, remindersEnabled, showTranslation,
      ];
}

// ============ BLOC ============
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  late Box<dynamic> _box;

  SettingsBloc() : super(const SettingsState()) {
    on<LoadSettingsEvent>(_onLoad);
    on<ToggleDarkModeEvent>(_onToggleDark);
    on<ChangeFontSizeEvent>(_onFontSize);
    on<ChangeFontFamilyEvent>(_onFontFamily);
    on<ChangeReciterEvent>(_onReciter);
    on<ToggleVibrationEvent>(_onVibration);
    on<ToggleRemindersEvent>(_onReminders);
    on<ToggleTranslationEvent>(_onTranslation);
  }

  Future<void> _onLoad(LoadSettingsEvent event, Emitter<SettingsState> emit) async {
    _box = await Hive.openBox(AppConstants.settingsBox);
    emit(SettingsState(
      isDarkMode: _box.get('isDarkMode', defaultValue: true),
      fontSize: _box.get('fontSize', defaultValue: 22.0),
      fontFamily: _box.get('fontFamily', defaultValue: 'Uthmanic'),
      defaultReciter: _box.get('defaultReciter', defaultValue: 'ar.alafasy'),
      vibrationEnabled: _box.get('vibrationEnabled', defaultValue: true),
      remindersEnabled: _box.get('remindersEnabled', defaultValue: true),
      showTranslation: _box.get('showTranslation', defaultValue: false),
    ));
  }

  Future<void> _save(String key, dynamic value) async {
    await _box.put(key, value);
  }

  Future<void> _onToggleDark(ToggleDarkModeEvent e, Emitter<SettingsState> emit) async {
    final newVal = !state.isDarkMode;
    await _save('isDarkMode', newVal);
    emit(state.copyWith(isDarkMode: newVal));
  }

  Future<void> _onFontSize(ChangeFontSizeEvent e, Emitter<SettingsState> emit) async {
    await _save('fontSize', e.size);
    emit(state.copyWith(fontSize: e.size));
  }

  Future<void> _onFontFamily(ChangeFontFamilyEvent e, Emitter<SettingsState> emit) async {
    await _save('fontFamily', e.fontFamily);
    emit(state.copyWith(fontFamily: e.fontFamily));
  }

  Future<void> _onReciter(ChangeReciterEvent e, Emitter<SettingsState> emit) async {
    await _save('defaultReciter', e.reciter);
    emit(state.copyWith(defaultReciter: e.reciter));
  }

  Future<void> _onVibration(ToggleVibrationEvent e, Emitter<SettingsState> emit) async {
    final newVal = !state.vibrationEnabled;
    await _save('vibrationEnabled', newVal);
    emit(state.copyWith(vibrationEnabled: newVal));
  }

  Future<void> _onReminders(ToggleRemindersEvent e, Emitter<SettingsState> emit) async {
    final newVal = !state.remindersEnabled;
    await _save('remindersEnabled', newVal);
    emit(state.copyWith(remindersEnabled: newVal));
  }

  Future<void> _onTranslation(ToggleTranslationEvent e, Emitter<SettingsState> emit) async {
    final newVal = !state.showTranslation;
    await _save('showTranslation', newVal);
    emit(state.copyWith(showTranslation: newVal));
  }
}
