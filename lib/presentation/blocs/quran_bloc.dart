// lib/presentation/blocs/quran/quran_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/surah_model.dart';
import '../../../data/repositories/quran_repository.dart';

// ============ EVENTS ============
abstract class QuranEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadSurahsEvent extends QuranEvent {}

class LoadSurahEvent extends QuranEvent {
  final int surahNumber;
  LoadSurahEvent(this.surahNumber);
  @override
  List<Object?> get props => [surahNumber];
}

class DownloadSurahEvent extends QuranEvent {
  final int surahNumber;
  DownloadSurahEvent(this.surahNumber);
  @override
  List<Object?> get props => [surahNumber];
}

class ToggleFavoriteAyahEvent extends QuranEvent {
  final AyahModel ayah;
  final bool isFavorite;
  ToggleFavoriteAyahEvent(this.ayah, this.isFavorite);
  @override
  List<Object?> get props => [ayah, isFavorite];
}

class SearchQuranEvent extends QuranEvent {
  final String query;
  SearchQuranEvent(this.query);
  @override
  List<Object?> get props => [query];
}

class SelectAyahEvent extends QuranEvent {
  final int? ayahNumber;
  SelectAyahEvent(this.ayahNumber);
  @override
  List<Object?> get props => [ayahNumber];
}

// ============ STATES ============
abstract class QuranState extends Equatable {
  @override
  List<Object?> get props => [];
}

class QuranInitial extends QuranState {}

class QuranLoading extends QuranState {}

class SurahsLoaded extends QuranState {
  final List<SurahModel> surahs;
  SurahsLoaded(this.surahs);
  @override
  List<Object?> get props => [surahs];
}

class SurahLoaded extends QuranState {
  final SurahModel surah;
  final int? selectedAyah;
  final Set<int> favoriteAyahs;
  SurahLoaded({
    required this.surah,
    this.selectedAyah,
    this.favoriteAyahs = const {},
  });
  @override
  List<Object?> get props => [surah, selectedAyah, favoriteAyahs];
}

class SurahDownloading extends QuranState {
  final int surahNumber;
  final double progress;
  SurahDownloading(this.surahNumber, this.progress);
  @override
  List<Object?> get props => [surahNumber, progress];
}

class SurahDownloaded extends QuranState {
  final int surahNumber;
  SurahDownloaded(this.surahNumber);
  @override
  List<Object?> get props => [surahNumber];
}

class QuranError extends QuranState {
  final String message;
  QuranError(this.message);
  @override
  List<Object?> get props => [message];
}

// ============ BLOC ============
class QuranBloc extends Bloc<QuranEvent, QuranState> {
  final QuranRepository _repository;

  QuranBloc({QuranRepository? repository})
      : _repository = repository ?? QuranRepository(),
        super(QuranInitial()) {
    on<LoadSurahsEvent>(_onLoadSurahs);
    on<LoadSurahEvent>(_onLoadSurah);
    on<DownloadSurahEvent>(_onDownloadSurah);
    on<ToggleFavoriteAyahEvent>(_onToggleFavorite);
    on<SelectAyahEvent>(_onSelectAyah);
  }

  Future<void> _onLoadSurahs(LoadSurahsEvent event, Emitter<QuranState> emit) async {
    emit(QuranLoading());
    try {
      final surahs = await _repository.getAllSurahs();
      emit(SurahsLoaded(surahs));
    } catch (e) {
      emit(QuranError(e.toString()));
    }
  }

  Future<void> _onLoadSurah(LoadSurahEvent event, Emitter<QuranState> emit) async {
    emit(QuranLoading());
    try {
      final surah = await _repository.getSurah(event.surahNumber);
      // Load favorites
      final favAyahs = await _repository.getFavoriteAyahs();
      final favIds = favAyahs.map((f) => f['item_id'] as int).toSet();
      emit(SurahLoaded(surah: surah, favoriteAyahs: favIds));
    } catch (e) {
      emit(QuranError(e.toString()));
    }
  }

  Future<void> _onDownloadSurah(DownloadSurahEvent event, Emitter<QuranState> emit) async {
    emit(SurahDownloading(event.surahNumber, 0));
    try {
      await _repository.downloadSurah(event.surahNumber);
      emit(SurahDownloaded(event.surahNumber));
    } catch (e) {
      emit(QuranError(e.toString()));
    }
  }

  Future<void> _onToggleFavorite(
      ToggleFavoriteAyahEvent event, Emitter<QuranState> emit) async {
    if (event.isFavorite) {
      await _repository.removeAyahFromFavorites(event.ayah.number);
    } else {
      await _repository.addAyahToFavorites(event.ayah);
    }
    // Reload current surah state
    if (state is SurahLoaded) {
      final current = state as SurahLoaded;
      final newFavs = Set<int>.from(current.favoriteAyahs);
      if (event.isFavorite) {
        newFavs.remove(event.ayah.number);
      } else {
        newFavs.add(event.ayah.number);
      }
      emit(SurahLoaded(
        surah: current.surah,
        selectedAyah: current.selectedAyah,
        favoriteAyahs: newFavs,
      ));
    }
  }

  void _onSelectAyah(SelectAyahEvent event, Emitter<QuranState> emit) {
    if (state is SurahLoaded) {
      final current = state as SurahLoaded;
      emit(SurahLoaded(
        surah: current.surah,
        selectedAyah: event.ayahNumber,
        favoriteAyahs: current.favoriteAyahs,
      ));
    }
  }
}
