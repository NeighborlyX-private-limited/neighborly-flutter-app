part of 'app_localization_bloc.dart';

class AppLocalizationState extends Equatable {
  final Locale selectedLocale;
  AppLocalizationState({Locale? locale})
      : selectedLocale = locale ?? Language[0];
  @override
  List<Object?> get props => [selectedLocale];
  AppLocalizationState copyWith({Locale? selectedLocale}) {
    return AppLocalizationState(
      locale: selectedLocale ?? this.selectedLocale,
    );
  }
}
