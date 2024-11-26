import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';
import 'package:neighborly_flutter_app/l10n/language.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'app_localization_event.dart';
part 'app_localization_state.dart';

class AppLocalizationBloc
    extends Bloc<AppLocalizationEvent, AppLocalizationState> {
  AppLocalizationBloc() : super(AppLocalizationState()) {
    on<ChangeAppLocalization>(onLanguageChange);
    on<GetLocale>(onGetLocale);
  }
  onLanguageChange(
    ChangeAppLocalization event,
    Emitter<AppLocalizationState> emit,
  ) {
    final String languageCode = event.selectedLocale.languageCode;
    ShardPrefHelper.setLanguage(languageCode);

    emit(state.copyWith(selectedLocale: event.selectedLocale));
  }

  onGetLocale(
    GetLocale event,
    Emitter<AppLocalizationState> emit,
  ) async {
    final language = ShardPrefHelper.getLanguage();
    Locale _locale = Language[0];
    if (language == 'hi') {
      _locale = Language[1];
    }

    emit(state.copyWith(selectedLocale: _locale));
  }
}
